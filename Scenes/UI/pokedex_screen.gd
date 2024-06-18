extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var cursor: TextureRect = $Cursor;
@onready var index_container: ScrollContainer = $Index/ScrollContainer;
@onready var pokedex_container: ScrollContainer = $List/PageList/ScrollContainer;
@onready var habitat: TextureRect = $Index/Habitat;
@onready var seen: RichTextLabel = $Index/Seen;
@onready var owned: RichTextLabel = $Index/Owned;
@onready var anim_arrows: AnimationPlayer = $Arrows/AnimationPlayer;
@onready var red_arrow_up: Sprite2D = $Arrows/ArrowUp;
@onready var red_arrow_down: Sprite2D = $Arrows/ArrowDown;

const MAX_INDEX_SCROLL_HEIGHT = 96;
const INDEX_ITEM_HEIGHT = 15;
const LIST_ITEM_HEIGHT = 16;
const ITEM_scene = preload("res://Scenes/UI/pokedex_item.tscn");

enum Views { INDEX, LIST, INFO, AREA }

@onready var view_list = {
	Views.INDEX: $Index,
	Views.LIST: $List
}

var red_arrow_positions = {
	Views.INDEX: 155,
	Views.LIST: 226
}

var selected_option = int(ENUMS.PokedexIndexOptions.NUMERICAL);
var selected_view = int(Views.INDEX);
var list_size: int;
var showcase = [];
var pokedex_created = false;
var index_options;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
	view_list[Views.INDEX].visible = true;
	showcase = POKEDEX.get_showcase();
	index_container.scroll_vertical = 0;
	pokedex_container.scroll_vertical = 0;
	list_size = ENUMS.PokedexIndexOptions.keys().size();
	index_options = LIBRARIES.POKEDEX.index_options;
	update_cursor();
	set_arrows(false, true);

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open
	): return;
	#CLOSE
	if(Input.is_action_just_pressed("backMenu")): 
		handle_can_close();
		return;
	#DOWN
	if(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	#SELECT
	elif(Input.is_action_just_pressed("space")): select_slot();
		
	update_scroll();

func select_slot() -> void:
	match selected_view:
		Views.INDEX: handle_index_select()

func handle_index_select() -> void:
	var last_option = list_size - 1;
	match selected_option:
		#NUMERICAL
		ENUMS.PokedexIndexOptions.NUMERICAL: go_to_list();
		#CANCEL
		last_option: close_pokedex();

#VIEW
func change_view(view: Views) -> void:
	var current_node = view_list[int(selected_view)];
	var next_node = view_list[int(view)];
	if(current_node): current_node.visible = false;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	selected_view = int(view);
	if(next_node): next_node.visible = true;

func handle_DOWN() -> void:
	var size: int;
	match selected_view:
		Views.INDEX: size = list_size;
		Views.LIST: size = showcase.size()
		
	if(selected_option == size - 1): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_view == Views.INDEX): select_habitat();

func handle_UP() -> void:
	if(selected_option == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option -= 1;
	if(selected_view == Views.INDEX): select_habitat();

#INDEX VIEW
func go_to_index() -> void:
	selected_option = 0;
	change_view(Views.INDEX);
	update_cursor();
	update_red_arrow_position();

#LIST VIEW
func go_to_list() -> void:
	selected_option = 0;
	change_view(Views.LIST);
	if(!pokedex_created): create_pokedex();
	update_red_arrow_position();

#CLOSE
func handle_can_close() -> void:
	match selected_view:
		Views.INDEX: close_pokedex()
		Views.LIST: go_to_index()

func update_cursor() -> void:
	var size = showcase.size();
	match selected_view:
		Views.INDEX:
			var cursor_option = index_options[selected_option];
			if("cursor" in cursor_option): cursor.position = cursor_option.cursor;
		Views.LIST:
			var y_position = get_cursor_y(selected_option, size);
			if(y_position != 0.0): cursor.position = Vector2(5, y_position);

func get_cursor_y(option: int, size: int) -> float:
	if(option == 0): return 23.5
	elif(size != 0):
		if(option < 5):
			return (option % size) * 16 + 23.5;
		elif option + 2 < size - 1: return 87.5;
		elif option + 2 == size - 1: return 95.5;
		elif option + 1 == size - 1: return 111.5;
		elif option == size - 1: return 127.5;
	return 0.0;

func update_scroll() -> void:
	match selected_view:
		Views.INDEX: update_index_scroll()
		Views.LIST: update_list_scroll()

#SCROLL
func update_index_scroll() -> void:
	update_cursor();
	var scroll = get_scroll(selected_option);
	index_container.scroll_vertical = scroll;
	set_arrows(selected_option > 3, selected_option < (list_size - 2));

func update_list_scroll() -> void:
	update_cursor();
	if(selected_option + 2 > showcase.size() - 1): return;
	var scroll = get_scroll(selected_option);
	pokedex_container.scroll_vertical = scroll;
	set_arrows(selected_option > 4, selected_option + 2 < (showcase.size() - 1));

func update_red_arrow_position() -> void:
	var position_x = red_arrow_positions[selected_view];
	red_arrow_down.position.x = position_x;
	red_arrow_up.position.x = position_x;

func set_arrows(up: bool, down: bool) -> void:
	red_arrow_up.visible = up;
	red_arrow_down.visible = down;

func get_scroll(selected: int) -> int:
	match selected_view:
		Views.INDEX:
			if(selected < 4): return 0;
			elif(selected >= list_size - 2): return MAX_INDEX_SCROLL_HEIGHT;
			return (selected - 3) * INDEX_ITEM_HEIGHT;
		Views.LIST:
			if(selected < 5): return 0;
			return (selected - 4) * LIST_ITEM_HEIGHT;
		_: return 0;

#CREATE POKEDEX SHOWCASE
func create_pokedex() -> void:
	for index in range(0, showcase.size()):
		var poke = showcase[index];
		var data = {};
		var item = ITEM_scene.instantiate();
		
		if(poke == null): 
			data = create_item_data(format_number(index + 1));
		else:
			var types = convert_types(poke);
			data = create_item_data(
				format_number(poke.number), 
				poke.owned,
				POKEDEX.get_pokemon_prop(poke.number, 'name'),
				types[0],
				types[1]
			);
		item.set_data(data);
		pokedex_container.get_node("VBoxContainer").add_child(item);
		pokedex_created = true;

func convert_types(poke: Dictionary) -> Array:
	var types = get_poke_types(poke.number);
	var type1_texture = MOVES.get_type_sprite(types[0]);
	var type2_texture = null;
	if(types.size() > 1): type2_texture = MOVES.get_type_sprite(types[1]);
	return [type1_texture, type2_texture];

func create_item_data(
	number: String, 
	is_owned: bool = false, 
	poke_name: String = '------------', 
	type1_texture: Texture = null, 
	type2_texture: Texture = null
	) -> Dictionary:
	return {
		"number": number,
		"owned": is_owned,
		"name": poke_name,
		"type1_texture": type1_texture,
		"type2_texture": type2_texture
	}

func format_number(num: int) -> String:
	if(num < 10): return 'No00' + str(num);
	elif(num >= 10 && num < 100): return 'No0' + str(num);
	return 'No' + str(num);

func get_poke_types(index: int) -> Array:
	return POKEDEX.get_pokemon_prop(index, 'types');

#HABITAT SPRITE
func select_habitat() -> void:
	var opt = index_options[int(selected_option)];
	if("texture" in opt): habitat.texture = opt.texture;

func close_pokedex() -> void:
	GLOBAL.on_overlay = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokedexScreen");
	process_mode = Node.PROCESS_MODE_DISABLED;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
