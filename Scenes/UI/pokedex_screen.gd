extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var cursor: TextureRect = $Index/Cursor;
@onready var scroll_container: ScrollContainer = $Index/ScrollContainer;
@onready var habitat: TextureRect = $Index/Habitat;
@onready var seen: RichTextLabel = $Index/Seen;
@onready var owned: RichTextLabel = $Index/Owned;

const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");

enum SelectOptions {
	NUMERICAL,
	GRASS,
	WATER,
	SEA,
	CAVE,
	MOUNTAIN,
	ROUGH,
	URBAN,
	RARE,
	CLOSE
}

enum Views { INDEX, LIST, INFO, AREA }

@onready var view_list = {
	Views.INDEX: $Index,
	Views.LIST: $List
}

var selected_option = int(SelectOptions.NUMERICAL);
var selected_view = int(Views.INDEX);
var list_size: int;

@onready var options = {
	SelectOptions.NUMERICAL: {
		"texture": load("res://Assets/UI/Pokedex/numerical.png"),
		"cursor": Vector2(12, 35.5)
	},
	SelectOptions.GRASS: {
		"texture": load("res://Assets/UI/Pokedex/grass.png"),
		"cursor": Vector2(12, 69.5)
	},
	SelectOptions.WATER: {
		"texture": load("res://Assets/UI/Pokedex/water.png"),
		"cursor": Vector2(12, 84.5)
	},
	SelectOptions.SEA: {
		"texture": load("res://Assets/UI/Pokedex/sea.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.CAVE: {
		"texture": load("res://Assets/UI/Pokedex/cave.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.MOUNTAIN: {
		"texture": load("res://Assets/UI/Pokedex/mountain.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.ROUGH: {
		"texture": load("res://Assets/UI/Pokedex/rough.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.URBAN: {
		"texture": load("res://Assets/UI/Pokedex/urban.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.RARE: {
		"texture": load("res://Assets/UI/Pokedex/rare.png"),
		"cursor": Vector2(12, 99.5)
	},
	SelectOptions.CLOSE: {
		"texture": load("res://Assets/UI/Pokedex/close.png"),
		"cursor": Vector2(12, 126.5)
	}
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
	view_list[Views.INDEX].visible = true;
	update_cursor();
	scroll_container.scroll_vertical = 0;
	list_size = SelectOptions.keys().size();

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
		close_pokedex();
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
	#UPDATE
	update_scroll();
	select_habitat();

func update_scroll() -> void:
	var scroll = get_scroll(selected_option);
	scroll_container.scroll_vertical = scroll;
	update_cursor();

func get_scroll(selected: int) -> int:
	if(selected < 4): return 0;
	elif(selected == 9): return 81;
	return (selected - 3) * 15;

func select_slot() -> void:
	if(selected_view == Views.INDEX):
		var last_option = list_size - 1;
		match selected_option:
			#NUMERICAL
			SelectOptions.NUMERICAL: 
				change_view(Views.LIST);
				
			#CANCEL
			last_option: close_pokedex();

func change_view(view: Views) -> void:
	view_list[int(selected_view)].visible = false;
	play_audio(GUI_SEL_DECISION);
	selected_view = view;
	view_list[int(view)].visible = true;

func handle_DOWN() -> void:
	if(selected_option == list_size - 1): return;
	play_audio(GUI_SEL_CURSOR);
	selected_option += 1;

func handle_UP() -> void:
	if(selected_option == 0): return;
	play_audio(GUI_SEL_CURSOR);
	selected_option -= 1;

func select_habitat() -> void:
	var opt = options[int(selected_option)];
	if("texture" in opt): habitat.texture = opt.texture;

func can_close() -> bool: return selected_view == int(Views.INDEX);

func close_pokedex() -> void:
	if(can_close()):
		GLOBAL.on_overlay = false;
		play_audio(GUI_MENU_CLOSE);
		await GLOBAL.timeout(.2);
		GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokedexScreen");
		process_mode = Node.PROCESS_MODE_DISABLED;
	else:
		match selected_view:
			Views.LIST: 
				change_view(Views.INDEX);
				

func update_cursor() -> void:
	var new_position = options[selected_option].cursor;
	cursor.position = new_position;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
