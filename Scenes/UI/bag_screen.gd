extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var title: TextureRect = $Title;
@onready var bag_sprite: Sprite2D = $BagSprite;

#ARROWS
@onready var arrow_left: Sprite2D = $Arrows/ArrowLeft;
@onready var arrow_right: Sprite2D = $Arrows/ArrowRight;
@onready var arrow_up: Sprite2D = $Arrows/ArrowUp;
@onready var arrow_down: Sprite2D = $Arrows/ArrowDown;

@onready var items_container: VBoxContainer = $Items/ScrollContainer/VBoxContainer;
@onready var pokeball_container: VBoxContainer = $Pokeball/ScrollContainer/VBoxContainer;
@onready var key_container: VBoxContainer = $Key/ScrollContainer/VBoxContainer;
@onready var cursor: TextureRect = $Cursor;
@onready var item_image: Sprite2D = $Sprite2D;
@onready var description: RichTextLabel = $Description;
@onready var select: Control = $Select;
@onready var select_cursor: TextureRect = $Select/Cursor;
@onready var info: Node2D = $Info;
@onready var selected: RichTextLabel = $Info/Selected;

@onready var CANCEL_ITEM = {
	"id": -1,
	"name": "CANCEL", 
	"description": "CLOSE THE BAG",
	"image": preload("res://Assets/UI/Bag/back.png")
}

enum SelectSlot { FIRST, SECOND, THIRD, FOURTH }
const ITEM_scene = preload("res://Scenes/UI/bag_item.tscn");
const LIST_ITEM_HEIGHT = 16;
const CURSOR_HEIGHT_BOTTOM = 62;
var picked = false;

@onready var view_list = {
	ENUMS.BagScreen.ITEMS: {
		"node": $Items,
		"title": LIBRARIES.IMAGES.TITLE_ITEMS,
		"container": $Items/ScrollContainer
	},
	ENUMS.BagScreen.POKEBALL: {
		"node": $Pokeball,
		"title": LIBRARIES.IMAGES.TITLE_POKEBALL,
		"container": $Pokeball/ScrollContainer
	},
	ENUMS.BagScreen.KEY: {
		"node": $Key,
		"title": LIBRARIES.IMAGES.TITLE_KEY,
		"container": $Key/ScrollContainer
	}
}

var selected_view = int(ENUMS.BagScreen.ITEMS);
var pokeball_list = [];
var items_list = [];
var key_list = [];
var views_size: int;
var selected_option = 0;
var select_index = int(SelectSlot.FIRST);
var select_open = false;

var SELECT_CURSOR_POSITION = [
	Vector2(23, -6), Vector2(23, 10), Vector2(23, 26), Vector2(23, 42)
];

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
	selected_view = BAG.last_bag_screen;
	views_size = view_list.keys().size();
	create_bag();
	set_textures();
	update_item();
	select.visible = false;
	info.visible = false;
	move_select_arrow();

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition ||
		GLOBAL.dialog_open ||
		event.is_echo() ||
		!event.is_pressed() ||
		Input.is_action_just_pressed("menu") ||
		picked
	): return;
	
	#CLOSE
	if(Input.is_action_just_pressed("backMenu") && !select_open): 
		close_bag();
		return;
	#SELECT
	if(Input.is_action_just_pressed("backMenu") && select_open): 
		close_select();
		return;
	#DOWN
	if(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		(Input.is_action_just_pressed("moveRight") || 
		Input.is_action_just_pressed("ui_right")) && 
		selected_view + 1 < views_size): handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_just_pressed("moveLeft") || 
		Input.is_action_just_pressed("ui_left")) && 
		selected_view - 1 >= 0): handle_LEFT();
	#SELECT
	elif(Input.is_action_just_pressed("space")): select_slot();

func select_slot() -> void:
	var current_item = get_current_item();
	if(current_item.id == -1): 
		close_bag();
		return;
	if(!select_open): open_select(current_item);
	else:
		match select_index:
			SelectSlot.FIRST, SelectSlot.SECOND, SelectSlot.THIRD: handle_input(current_item); 
			SelectSlot.FOURTH: close_select();
	#NORMAL PARTY
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	
func handle_input(item: Dictionary) -> void:
	match select_index:
		SelectSlot.FIRST:
			if(GLOBAL.on_battle):
				picked = true;
				GLOBAL.emit_signal("use_item", item);
				close_bag();

func open_select(current_item: Dictionary) -> void:
	select_open = true;
	select.visible = true;
	info.visible = true;
	selected.text = current_item.name + " is selected.";
	set_arrows_visibility();

func handle_DOWN() -> void:
	if(select_open):
		select_DOWN();
		return;
	var size = get_list().size();
	if(selected_option == size - 1 || size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	update_cursor();
	update_item();
	update_scroll();
	set_arrows_visibility();

func handle_UP() -> void:
	if(select_open):
		select_UP();
		return;
	var size = get_list().size();
	if(selected_option == 0 || size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option -= 1;
	update_cursor();
	update_item();
	update_scroll();
	set_arrows_visibility();

func handle_RIGHT() -> void:
	if(select_open): return;
	set_view_visibility(false);
	selected_option = 0;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	selected_view += 1;
	set_textures();
	update_cursor();
	update_item();

func handle_LEFT() -> void:
	if(select_open): return;
	set_view_visibility(false);
	selected_option = 0;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	selected_view -= 1;
	set_textures();
	update_cursor();
	update_item();

#SELECT
func select_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	select_index += 1;
	if(select_index > SelectSlot.FOURTH): 
		select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func select_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(select_index == SelectSlot.FIRST): 
		select_index = int(SelectSlot.FOURTH);
	else: select_index -= 1;
	move_select_arrow();

#ITEM
func get_current_item() -> Dictionary:
	var list = get_list();
	return list[selected_option];

func update_item() -> void:
	var item = get_current_item();
	if(item != null):
		item_image.texture = item.image;
		description.text = item.description;

#CURSOR
func update_cursor() -> void:
	var size = get_list().size();
	var y_position = get_cursor_y(selected_option, size);
	if(y_position != 0.0): cursor.position = Vector2(91, y_position);

func get_cursor_y(option: int, size: int) -> float:
	if(option == 0): return 14;
	elif(size != 0):
		if(option < 4):
			return (option % size) * LIST_ITEM_HEIGHT + 14;
		elif(
			option + 2 < size - 1 || 
			option + 2 == size - 1 || 
			option + 1 == size - 1
		): return CURSOR_HEIGHT_BOTTOM;
		elif option == size - 1: 
			return CURSOR_HEIGHT_BOTTOM + LIST_ITEM_HEIGHT;
	return 0.0;

#SCROLL
func get_scroll() -> int:
	if(selected_option < 4): return 0;
	return (selected_option - 3) * LIST_ITEM_HEIGHT;

func update_scroll() -> void:
	var size = get_list().size();
	var scroll = get_scroll();
	if(selected_option + 2 > size): return;
	var view = view_list[int(selected_view)];
	if("container" in view):
		view.container.scroll_vertical = scroll;

#CREATE
func create_bag() -> void:
	for item in BAG.items:
		var item_info = BAG.get_item_by_id(item.id);
		item_info["amount"] = item.amount;
		match item_info.type:
			ENUMS.BagScreen.POKEBALL:
				pokeball_list.push_back(item_info);
			ENUMS.BagScreen.ITEMS:
				items_list.push_back(item_info);
			ENUMS.BagScreen.KEY:
				key_list.push_back(item_info);
			
	create_all_list();

func create_all_list() -> void:
	create_list(items_list, items_container);
	create_list(pokeball_list, pokeball_container);
	create_list(key_list, key_container);

func create_list(arr: Array, container: VBoxContainer) -> void:
	arr.push_back(CANCEL_ITEM);
	for item in arr:
		var node = ITEM_scene.instantiate();
		node.set_data(item);
		container.add_child(node);

func close_bag() -> void:
	GLOBAL.on_overlay = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	BAG.last_bag_screen = selected_view;
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/BagScreen");
	if(GLOBAL.on_battle): BATTLE.state = ENUMS.BattleStates.MENU;
	process_mode = Node.PROCESS_MODE_DISABLED;

func set_textures() -> void:
	set_view_visibility(true);
	title.texture = view_list[int(selected_view)].title;
	bag_sprite.frame = selected_view;
	set_arrows_visibility();

func set_arrows_visibility() -> void:
	var size = get_list().size();
	arrow_left.visible = !select_open && selected_view > 0;
	arrow_right.visible = !select_open && selected_view < views_size - 1;
	arrow_down.visible = !select_open && size > 5 && selected_option + 2 < size;
	arrow_up.visible = !select_open && size > 5 && selected_option > 3;

func set_view_visibility(val: bool) -> void:
	var view = view_list[int(selected_view)]; 
	view.node.visible = val;
	view.container.scroll_vertical = 0;

func get_list() -> Array:
	var arr: Array;
	match int(selected_view):
		ENUMS.BagScreen.ITEMS: arr = items_list;
		ENUMS.BagScreen.POKEBALL: arr = pokeball_list;
		ENUMS.BagScreen.KEY: arr = key_list;
		_: arr = [];
	return arr;

#CLOSE SELECT
func close_select(sound = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	select_open = false;
	select.visible = false;
	info.visible = false;
	selected.text = "";
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();
	set_arrows_visibility();

func move_select_arrow() -> void:
	select_cursor.position = SELECT_CURSOR_POSITION[select_index];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
