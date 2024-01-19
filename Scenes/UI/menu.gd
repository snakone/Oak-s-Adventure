extends CanvasLayer

@onready var control = $Control
@onready var arrow = $Control/NinePatchRect/TextureRect
@onready var audio_player = $AudioStreamPlayer;
@onready var nine_patch_rect = $Control/NinePatchRect;

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

const party_screen_path = "res://Scenes/UI/party_screen.tscn";
const save_scene_path = "res://Scenes/UI/save_scene.tscn";
const party_screen_node =  "CurrentScene/PartyScreen";
const save_scene_node =  "CurrentScene/SaveScene";

const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_MENU_OPEN = preload("res://Assets/Sounds/GUI menu open.ogg");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_SAVE_GAME = preload("res://Assets/Sounds/GUI save game.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg")

var options_length = MenuOptions.keys().size();
var selected_option = 0;
var is_player_moving = false;
var scene_manager: Node2D;
var screen_loaded = ScreenLoaded.NONE;

func _ready():
	if(SETTINGS.selected_marker):
		nine_patch_rect.texture = SETTINGS.selected_marker;
	scene_manager = get_parent();
	control.visible = false;
	update_arrow();
	connect_signals();

func _unhandled_input(event: InputEvent) -> void:
	if(
		is_player_moving || 
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open
	): return;
	
	if(
		event.is_action_pressed("bike") && 
		!GLOBAL.inside_house && 
		!GLOBAL.menu_open
	): GLOBAL.emit_signal("get_on_bike", !GLOBAL.on_bike);

	match (screen_loaded):
		ScreenLoaded.NONE: if(Input.is_action_pressed("menu")): handle_MENU();
		ScreenLoaded.MENU:
			if(
				Input.is_action_pressed("menu") || 
				Input.is_action_pressed("backMenu") ||
				Input.is_action_pressed("escape")): close_menu()
			elif(
				Input.is_action_pressed("moveDown") || 
				Input.is_action_pressed("ui_down")): handle_DOWN();
			elif(
				Input.is_action_pressed("moveUp") || 
				Input.is_action_pressed("ui_up")): handle_UP();
			elif(event.is_action_pressed("space")): select_option();

func select_option() -> void:
	match(selected_option):
		MenuOptions.PARTY: open_party()
		MenuOptions.SAVE: handle_save()
		MenuOptions.EXIT: close_menu()

func update_arrow() -> void: arrow.position.y = 11 + (selected_option % options_length) * 16;
func _on_player_moving(value: bool) -> void: is_player_moving = value;

func close_menu() -> void:
	audio_player.stream = GUI_MENU_OPEN;
	audio_player.play();
	control.visible = false;
	GLOBAL.menu_open = false;
	screen_loaded = ScreenLoaded.NONE;
	selected_option = MenuOptions.POKEDEX;
	GLOBAL.emit_signal("menu_opened", false);
	update_arrow();

func open_party() -> void:
	audio_player.stream = GUI_SEL_DECISION;
	audio_player.play();
	await audio_player.finished;
	control.visible = false;
	screen_loaded = ScreenLoaded.PARTY;
	process_mode = Node.PROCESS_MODE_DISABLED;
	scene_manager.transition_to_scene(party_screen_path, true, false);
	GLOBAL.emit_signal("party_opened", true);

func _on_party_opened(value: bool) -> void:
	#CLOSED
	if(!value):
		control.visible = true;
		screen_loaded = ScreenLoaded.MENU;
		scene_manager.get_node(party_screen_node).queue_free();
		process_mode = Node.PROCESS_MODE_INHERIT;

func handle_MENU() -> void:
	audio_player.stream = GUI_MENU_OPEN;
	audio_player.play();
	control.visible = true;
	screen_loaded = ScreenLoaded.MENU;
	GLOBAL.emit_signal("menu_opened", true);
	GLOBAL.menu_open = true;

func handle_DOWN() -> void:
	audio_player.stream = GUI_SEL_CURSOR;
	audio_player.play();
	selected_option += 1;
	if(selected_option > options_length - 1): selected_option = MenuOptions.POKEDEX;
	update_arrow();

func handle_UP() -> void:
	audio_player.stream = GUI_SEL_CURSOR;
	audio_player.play();
	if(selected_option == MenuOptions.POKEDEX):
		selected_option = MenuOptions.EXIT;
	else: selected_option -= 1;
	update_arrow();
	
func handle_save() -> void:
	audio_player.stream = GUI_SEL_DECISION;
	audio_player.play();
	control.visible = false;
	GLOBAL.menu_open = false;
	screen_loaded = ScreenLoaded.NONE;
	selected_option = MenuOptions.POKEDEX;
	scene_manager.transition_to_scene(save_scene_path, false, false);
	GLOBAL.emit_signal("start_dialog", 10);
	update_arrow();

func connect_signals() -> void:
	GLOBAL.connect("player_moving", _on_player_moving);
	GLOBAL.connect("party_opened", _on_party_opened);

