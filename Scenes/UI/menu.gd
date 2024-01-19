extends CanvasLayer

@onready var control = $Control
@onready var arrow = $Control/NinePatchRect/TextureRect
@onready var audio_player = $AudioStreamPlayer;

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

var screen_loaded = ScreenLoaded.NONE;
var party_screen_path = "res://Scenes/UI/party_screen.tscn";
var party_screen_node =  "CurrentScene/PartyScreen";

const GUI_MENU_CLOSE = preload("res://Assets/GUI menu close.ogg");
const GUI_MENU_OPEN = preload("res://Assets/GUI menu open.ogg");
const GUI_SEL_CURSOR = preload("res://Assets/GUI sel cursor.ogg");
const GUI_SAVE_GAME = preload("res://Assets/GUI save game.ogg");
const GUI_SEL_DECISION = preload("res://Assets/GUI sel decision.ogg")

var options_length = MenuOptions.keys().size();
var selected_option = 0;
var is_player_moving = false;
var scene_manager: Node2D;

func _ready():
	control.visible = false;
	update_arrow();
	connect_signals();
	scene_manager = get_parent();

func _unhandled_input(event: InputEvent) -> void:
	if(
		is_player_moving || 
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open
	): return;
	
	if(event.is_action_pressed("bike") && !GLOBAL.inside_house && !GLOBAL.menu_open):
		GLOBAL.emit_signal("get_on_bike", !GLOBAL.on_bike);

	match (screen_loaded):
		ScreenLoaded.NONE: if(Input.is_action_pressed("menu")): handle_MENU();
		ScreenLoaded.MENU:
			#CLOSE
			if(
				Input.is_action_pressed("menu") || 
				Input.is_action_pressed("backMenu") ||
				Input.is_action_pressed("escape")): close_menu()
			#DOWN
			elif(
				Input.is_action_pressed("moveDown") || 
				Input.is_action_pressed("ui_down")): handle_DOWN();
			#UP
			elif(
				Input.is_action_pressed("moveUp") || 
				Input.is_action_pressed("ui_up")): handle_UP();
			#ACCEPT
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
	GLOBAL.emit_signal("menu_opened", false);
	selected_option = MenuOptions.POKEDEX;
	update_arrow();

func open_party() -> void:
	audio_player.stream = GUI_SEL_DECISION;
	audio_player.play();
	await audio_player.finished;
	control.visible = false;
	screen_loaded = ScreenLoaded.PARTY;
	scene_manager.transition_to_scene(party_screen_path, true, false);
	process_mode = Node.PROCESS_MODE_DISABLED;
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
	audio_player.stream = GUI_SAVE_GAME;
	audio_player.play();
	MEMORY._save();

func connect_signals() -> void:
	GLOBAL.connect("player_moving", _on_player_moving);
	GLOBAL.connect("party_opened", _on_party_opened);

