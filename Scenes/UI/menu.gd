extends CanvasLayer

@onready var control = $Control
@onready var arrow = $Control/NinePatchRect/TextureRect

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
var screen_loaded = ScreenLoaded.NONE;
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

var options_length = ScreenLoaded.keys().size() - 1;
var selected_option = 0;
var is_player_moving = false;

func _ready():
	control.visible = false;
	update_arrow();
	GLOBAL.connect("player_moving", _on_player_moving);
	
func _unhandled_input(event):
	if(is_player_moving): return;
	match (screen_loaded):
		ScreenLoaded.NONE:
			if(event.is_action_pressed("menu")):
				control.visible = true;
				screen_loaded = ScreenLoaded.MENU;
				GLOBAL.emit_signal("menu_opened", true);
		ScreenLoaded.MENU:
			#CLOSE
			if(
				event.is_action_pressed("menu") || 
				event.is_action_pressed("backMenu") ||
				event.is_action_pressed("escape")
			):
				control.visible = false;
				screen_loaded = ScreenLoaded.NONE;
				GLOBAL.emit_signal("menu_opened", false);
			#DOWN
			elif(
				event.is_action_pressed("moveDown") || 
				event.is_action_pressed("ui_down")
			):
				selected_option += 1;
				update_arrow();
			#UP
			elif(
				event.is_action_pressed("moveUp") || 
				event.is_action_pressed("ui_up")
			):
				if(selected_option == 0):
					selected_option = options_length;
				else: selected_option -= 1;
				update_arrow();
		ScreenLoaded.PARTY:
			pass

func update_arrow() -> void:
	arrow.position.y = 11 + (selected_option % options_length) * 16;

func _on_player_moving(value: bool): 
	is_player_moving = value;
