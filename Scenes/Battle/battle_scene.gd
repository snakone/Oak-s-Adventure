extends Node

enum States {
	MENU = 0, 
	FIGHT = 1, 
	BAG = 2, 
	POKEMON = 3, 
	RUN = 4, 
	DIALOG = 5, 
	NONE = 6, 
	ATTACKING = 7
}

const FIELD_BG = preload("res://Assets/UI/Battle/field_bg.png");
const SNOW_BG = preload("res://Assets/UI/Battle/snow_bg.png");
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");

signal dialog_finished()

@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var menu = $Menu;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var dialog = $Dialog;
@onready var dialog_timer = $Dialog/Timer;
@onready var dialog_label = $Dialog/Label;
@onready var eneny_name_text = $Info/EnemyInfo/Name;
@onready var enemy_gender = $Info/EnemyInfo/Gender;
@onready var dialog_marker = $Dialog/Marker;
@onready var player_name_text = $Info/PlayerInfo/Name
@onready var player_gender = $Info/PlayerInfo/Gender;
@onready var enemy_anim_player = $UI/EnemySprite/AnimationPlayer;
@onready var menu_label = $Menu/Label;

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
var yo = "Treecko";

func _ready():
	set_battle_ui();
	match(data.type):
		BATTLE.Type.WILD: battle_wild();

func _input(event: InputEvent) -> void:
	if(!event.is_pressed() || event.is_echo()): return;
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
		States.DIALOG: dialog_input(event);

func battle_wild() -> void:
	anim_player.play("Start");
	await anim_player.animation_finished;
	start_dialog(["A wild " + enemy + " appeared!\n", "Go " + yo + "!" ]);
	enemy_anim_player.play("Shout");
	await dialog_finished;
	anim_player.play("Go")
	await anim_player.animation_finished;
	battle_anim_player.play("Idle");
	menu_label.text = "Ready! What will be your next move?"

func set_battle_ui() -> void:
	var enemy_dist = eneny_name_text.get_content_width() + eneny_name_text.position.x + 5;
	enemy_gender.position.x = enemy_dist;
	var player_dist = player_name_text.get_content_width() + player_name_text.position.x + 6;
	player_gender.position.x = player_dist;
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func set_battle_data(battle_data: Dictionary): data = battle_data;

func _unhandled_input(event):
	if(event.is_action_pressed("escape")):
		GLOBAL.emit_signal("close_battle");

func start_dialog(input_arr: Array) -> void:
	dialog_pressed = true
	current_state = States.NONE;
	dialog_marker.visible = false;
	
	dialog.visible = true
	dialog_text = input_arr.duplicate()
	
	dialog_line = 1
	dialog_timer.start();
	
	for i in range(dialog_line):
		for j in range(len(input_arr[i])):
			await dialog_timer.timeout;
			current_dialog_txt += input_arr[i][j]
			dialog_label.text = current_dialog_txt;
	
	dialog_marker.visible = true;
	current_state = States.DIALOG;
	await GLOBAL.timeout(.2);
	dialog_pressed = false;

func dialog_input(event: InputEvent) -> void:
	if(dialog_pressed): return;
	if event.is_action_pressed("space"):
		dialog_marker.visible = false;
		dialog_pressed = true
		audio.stream = CONFIRM;
		audio.play();
		await audio.finished;
		if dialog_line < len(dialog_text): write_dialog();
		else: end_dialog();

func write_dialog() -> void:
	current_dialog_txt = current_dialog_txt.erase(0, current_dialog_txt.find("\n") + 1)
	dialog_label.text = current_dialog_txt;
	if current_dialog_txt.find("\n") == -1:
		for i in range(len(dialog_text[dialog_line])):
			await dialog_timer.timeout
			current_dialog_txt += dialog_text[dialog_line][i]
			dialog_label.text = current_dialog_txt
	dialog_line += 1;
	dialog_marker.visible = true;
	await GLOBAL.timeout(.2);
	dialog_pressed = false;

func end_dialog() -> void:
	dialog_timer.stop()
	current_dialog_txt = ""
	dialog_label.text = "";
	dialog_pressed = false;
	await GLOBAL.timeout(.2);
	dialog.visible = false;
	menu.visible = true;
	current_state = States.MENU;
	dialog_finished.emit();
