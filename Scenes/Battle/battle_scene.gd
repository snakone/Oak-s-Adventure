extends Node

enum states {
	MENU = 0, 
	FIGHT = 1, 
	BAG = 2, 
	POKEMON = 3, 
	RUN = 4, 
	DIALOUGE = 5, 
	NONE = 6, 
	ATTACKING = 7
}

const FIELD_BG = preload("res://Assets/UI/Battle/field_bg.png");
const SNOW_BG = preload("res://Assets/UI/Battle/snow_bg.png");
@onready var anim_player = $anim_player;
@onready var audio = $audio_stream_player;

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

var data: Dictionary;
var current_state: states = states.NONE;
var dialog_pressed = false;

func _ready():
	set_battle_ui();
	match(data.type):
		BATTLE.Type.WILD: battle_wild()
	
func battle_wild() -> void:
	anim_player.play("start");

func set_battle_ui() -> void:
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func set_battle_data(battle_data: Dictionary):
	data = battle_data;
	
func _unhandled_input(event):
	if(event.is_action_pressed("escape")):
		GLOBAL.emit_signal("close_battle");

#func start_dialouge(input_arr: Array) -> void:
	#dialog_pressed = true
	#current_state = states.NONE
	#
	#dialouge_nde.visible = true
	#dialouge_text = input_arr.duplicate()
	#
	#dialouge_line = 1
	#dialouge_timer.start()
	#
	#for i in range(dialouge_line):
		#for j in range(len(input_arr[i])):
			#
			#await dialouge_timer.timeout
			#current_dialouge_str += input_arr[i][j]
			#dialouge_label.text = current_dialouge_str
	#
	#current_state = states.DIALOUGE
	#dialouge_pressed = false
