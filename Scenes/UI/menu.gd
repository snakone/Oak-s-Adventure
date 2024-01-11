extends CanvasLayer

@onready var control = $Control
@onready var arrow = $Control/NinePatchRect/TextureRect

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
var screen_loaded = ScreenLoaded.NONE;
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

var party_screen_path = "res://Scenes/UI/party_screen.tscn";
var party_screen_node =  "CurrentScene/PartyScreen"

var options_length = MenuOptions.keys().size();
var selected_option = 0;
var is_player_moving = false;
var scene_manager: Node2D;

func _ready():
	control.visible = false;
	update_arrow();
	GLOBAL.connect("player_moving", _on_player_moving);
	GLOBAL.connect("party_opened", _on_party_opened);
	scene_manager = get_parent();

func _unhandled_input(event: InputEvent):
	if(
		is_player_moving || 
		GLOBAL.on_transition || 
		GLOBAL.party_open || 
		!event.is_pressed() ||
		event.is_echo()
	): return;
	
	match (screen_loaded):
		ScreenLoaded.NONE:
			if(Input.is_action_pressed("menu")): handle_MENU();
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
			elif(event.is_action_pressed("space")): select_option()

func select_option() -> void:
	match(selected_option):
		MenuOptions.PARTY: open_party()
		MenuOptions.EXIT: close_menu()
	
func update_arrow() -> void:
	arrow.position.y = 11 + (selected_option % options_length) * 16;

func _on_player_moving(value: bool) -> void:
	is_player_moving = value;
	
func close_menu() -> void:
	control.visible = false;
	GLOBAL.menu_open = false;
	screen_loaded = ScreenLoaded.NONE;
	GLOBAL.emit_signal("menu_opened", false);
	selected_option = MenuOptions.POKEDEX;
	update_arrow();

func open_party() -> void:
	control.visible = false;
	screen_loaded = ScreenLoaded.PARTY;
	scene_manager.transition_to_scene(party_screen_path, true, true);
	GLOBAL.party_open = true;
	GLOBAL.menu_open = false;
	GLOBAL.emit_signal("party_opened", true);

func _on_party_opened(value: bool) -> void:
	#CLOSED
	if(!value):
		GLOBAL.party_open = false;
		control.visible = true;
		screen_loaded = ScreenLoaded.MENU;
		scene_manager.get_node(party_screen_node).queue_free();

func handle_MENU() -> void:
	control.visible = true;
	screen_loaded = ScreenLoaded.MENU;
	GLOBAL.emit_signal("menu_opened", true);
	GLOBAL.menu_open = true;

func handle_DOWN() -> void:
	selected_option += 1;
	if(selected_option > options_length - 1): selected_option = MenuOptions.POKEDEX;
	update_arrow();

func handle_UP() -> void:
	if(selected_option == MenuOptions.POKEDEX):
		selected_option = MenuOptions.EXIT;
	else: selected_option -= 1;
	update_arrow();

