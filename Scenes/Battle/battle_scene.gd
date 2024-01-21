extends Node

enum States {
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
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");

signal dialog_finished()

@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var menu = $Menu
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var dialog = $Dialog;
@onready var dialog_timer = $Dialog/Timer;
@onready var dialog_label = $Dialog/Label;

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

var data: Dictionary;
var current_state: States = States.NONE;
var dialog_pressed = false;
var dialog_text: Array
var dialog_line: int
var current_dialog_txt: String = "";

var enemy = "Mewtwo";
var yo = "Trecko";

func _ready():
	set_battle_ui();
	match(data.type):
		BATTLE.Type.WILD: battle_wild();

func _input(event: InputEvent) -> void:
	match current_state:
		#States.MENUE:
			#menue_input(event)
		#States.FIGHT:
			#attack_select_input(event)
		#States.BAG:
			#bag_input(event)
		#States.POKEMON:
			#pokemon_input(event)
#		states.RUN:
#			action(3, "Flee")
		States.DIALOUGE:
			dialouge_input(event)

func battle_wild() -> void:
	anim_player.play("Start");
	await anim_player.animation_finished;
	start_dialog(["Wild " + enemy + " appeared!\n", "Go " + yo + "." ]);
	await dialog_finished;
	anim_player.play("Go")
	await anim_player.animation_finished
	battle_anim_player.play("Idle")

func set_battle_ui() -> void:
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func set_battle_data(battle_data: Dictionary):
	data = battle_data;
	
func _unhandled_input(event):
	if(event.is_action_pressed("escape")):
		GLOBAL.emit_signal("close_battle");

func start_dialog(input_arr: Array) -> void:
	dialog_pressed = true
	current_state = States.NONE
	
	dialog.visible = true
	dialog_text = input_arr.duplicate()
	
	dialog_line = 1
	dialog_timer.start();
	
	for i in range(dialog_line):
		for j in range(len(input_arr[i])):
			await dialog_timer.timeout;
			current_dialog_txt += input_arr[i][j]
			dialog_label.text = current_dialog_txt;
	
	current_state = States.DIALOUGE
	dialog_pressed = false;
	
func dialouge_input(event: InputEvent) -> void:
	if !dialog_pressed:
		if event.is_action_pressed("space"):
			
			dialog_pressed = true
			
			audio.stream = CONFIRM;
			audio.play();
			await audio.finished;

			if dialog_line < len(dialog_text):
				
				current_dialog_txt = current_dialog_txt.erase(0, current_dialog_txt.find("\n") + 1)
				dialog_label.text = current_dialog_txt
				
				if current_dialog_txt.find("\n") == -1:
					
					for i in range(len(dialog_text[dialog_line])):
						
						await dialog_timer.timeout
						current_dialog_txt += dialog_text[dialog_line][i]
						dialog_label.text = current_dialog_txt
					
				else:
					pass
				
				dialog_line += 1
				dialog_pressed = false
				
			else:
				
				end_dialog();

func end_dialog() -> void:
	dialog_timer.stop()
	current_dialog_txt = ""
	dialog_label.text = ""
	menu.visible = true
	dialog.visible = false
	dialog_pressed = false
	current_state = States.MENU;
	dialog_finished.emit()
