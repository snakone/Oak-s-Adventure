extends CanvasLayer

@onready var control = $Control
@onready var arrow = $Control/NinePatchRect/TextureRect

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
var screen_loaded = ScreenLoaded.NONE;
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

var options_length = MenuOptions.keys().size();
var selected_option = 0;
var is_player_moving = false;

func _ready():
	control.visible = false;
	update_arrow();
	GLOBAL.connect("player_moving", _on_player_moving);
	_unhandled_input(null)
	
func _unhandled_input(event):
	#@TODO firing twice
	if(is_player_moving || GLOBAL.on_transition): return;
	match (screen_loaded):
		ScreenLoaded.NONE:
			if(Input.is_action_pressed("menu")):
				control.visible = true;
				screen_loaded = ScreenLoaded.MENU;
				GLOBAL.emit_signal("menu_opened", true);
		ScreenLoaded.MENU:
			#CLOSE
			if(
				Input.is_action_pressed("menu") || 
				Input.is_action_pressed("backMenu") ||
				Input.is_action_pressed("escape")
			): close_menu()
				
			#DOWN
			elif(
				Input.is_action_pressed("moveDown") || 
				Input.is_action_pressed("ui_down")
			):
				selected_option += 1;
				if(selected_option > options_length - 1): selected_option = 0;
				update_arrow();
			#UP
			elif(
				Input.is_action_pressed("moveUp") || 
				Input.is_action_pressed("ui_up")
			):
				if(selected_option == 0):
					selected_option = options_length - 1;
					update_arrow();
				else: selected_option -= 1;
				update_arrow();
			#ACCEPT
			elif(event.is_action_pressed("accept")): on_player_select()
		ScreenLoaded.PARTY:
			pass

func on_player_select() -> void:
	match(selected_option):
		MenuOptions.EXIT: close_menu()
	
func update_arrow() -> void:
	arrow.position.y = 11 + (selected_option % options_length) * 16;

func _on_player_moving(value: bool): 
	is_player_moving = value;
	
func close_menu() -> void:
	control.visible = false;
	screen_loaded = ScreenLoaded.NONE;
	GLOBAL.emit_signal("menu_opened", false);
	selected_option = 0;
	update_arrow();
