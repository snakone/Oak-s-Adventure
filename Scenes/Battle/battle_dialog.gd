extends Node2D

const CONFIRM = preload("res://Assets/Sounds/confirm.wav");

@onready var timer: Timer = $Timer
@onready var label = $Label;
@onready var marker = $Marker;
@onready var audio: AudioStreamPlayer = $"../AudioPlayer"
@onready var level_up_timer: Timer = $LevelUpTimer

var pressed = false;
var array: Array
var line: int
var current_text: String = "";

#DIALOG STATE
func start(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.DIALOG;
	pressed = true;
	marker.visible = false;
	visible = true;
	array = input_arr.duplicate();
	line = 1;
	timer.start();
	
	for i in range(line):
		for j in range(len(input_arr[i])):
			await timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	
	marker.visible = true;
	await GLOBAL.timeout(.2);
	pressed = false;

func input() -> void:
	await get_tree().process_frame;
	if(pressed): return;
	if Input.is_action_just_pressed("space"):
		marker.visible = false;
		pressed = true;
		play_audio(CONFIRM);
		await audio.finished;
		if line < len(array): next_dialog();
		elif(BATTLE.state != BATTLE.States.LEVELLING): end_dialog();

func next_dialog() -> void:
	#if(BATTLE.enemy_death): AUDIO.play_battle_win(battle_data.type);
	current_text = current_text.erase(0, current_text.find("\n") + 1)
	label.text = current_text;
	if current_text.find("\n") == -1:
		for i in range(len(array[line])):
			await timer.timeout
			current_text += array[line][i];
			label.text = current_text;
	line += 1;
	await GLOBAL.timeout(.2);
	pressed = false;
	if(BATTLE.intro_dialog):
		marker.visible = false;
		end_dialog();
	else: marker.visible = true;

#LEVELLING INPUT
func levelling_input() -> void:
	if(pressed): return;
	if Input.is_action_just_pressed("space"):
		pressed = true;
		play_audio(CONFIRM);
		await audio.finished;
		if(BATTLE.level_up_panel_visible):
			if(BATTLE.can_close_level_up_panel): 
				BATTLE.close_level_up_panel.emit();
				marker.visible = false;
			else: 
				BATTLE.show_total_stats_panel.emit();
				pressed = false;
			return;
		BATTLE.show_level_up_panel.emit();
		marker.visible = true;
		pressed = false;

#ATTACK
func start_attack(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.NONE;
	visible = true;
	array = input_arr.duplicate();
	timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	
	await GLOBAL.timeout(.7);
	current_text = "";
	label.text = "";
	BATTLE.after_dialog_attack.emit();
	BATTLE.dialog_finished.emit();

#LEVEL UP
func start_level_up(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.LEVELLING;
	current_text = "";
	level_up_timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await level_up_timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	
	marker.visible = true;
	await GLOBAL.timeout(0.2);
	pressed = false;

func switch(input_arr: Array) -> void:
	BATTLE.can_use_menu = false;
	BATTLE.state = BATTLE.States.SWITCHING;
	marker.visible = false;
	visible = true;
	array = input_arr.duplicate();
	line = 1;
	timer.start();
	
	for i in range(line):
		for j in range(len(input_arr[i])):
			await timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	await GLOBAL.timeout(1);
	timer.stop();
	current_text = "";
	BATTLE.switch_dialog_end.emit();

#END
func end_dialog() -> void:
	timer.stop();
	current_text = "";
	pressed = (BATTLE.enemy_death || BATTLE.pokemon_death);
	if(!BATTLE.intro_dialog && !BATTLE.pokemon_death && !BATTLE.enemy_death): 
		close(0);
	await GLOBAL.timeout(.2);
	BATTLE.state = BATTLE.States.MENU;
	BATTLE.dialog_finished.emit();

func close(time: float) -> void:
	visible = false;
	await GLOBAL.timeout(time);
	BATTLE.can_use_menu = true;

func set_label(text: String) -> void: label.text = text;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
