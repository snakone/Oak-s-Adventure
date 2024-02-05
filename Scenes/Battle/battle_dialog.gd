extends Node2D

const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const PKMN_LEVEL_UP = preload("res://Assets/Sounds/Pkmn level up.ogg");

@onready var timer: Timer = $Timer
@onready var label = $Label;
@onready var marker = $Marker;
@onready var audio: AudioStreamPlayer = $"../AudioPlayer"
@onready var level_up_timer: Timer = $LevelUpTimer

var pressed = false;
var array: Array
var line: int
var current_text: String = "";
var participant: Object;

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
	if(BATTLE.enemy_death && !BATTLE.on_victory): AUDIO.play_battle_win();
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
		BATTLE.show_level_up_panel.emit(participant);
		marker.visible = true;
		pressed = false;

#ATTACK
func attack(input_arr: Array) -> void:
	visible = true;
	timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	
	await GLOBAL.timeout(.8);
	current_text = "";
	BATTLE.after_dialog_attack.emit();
	BATTLE.dialog_finished.emit();

#LEVEL UP
func level_up(input_arr: Array, poke: Object) -> void:
	BATTLE.state = BATTLE.States.LEVELLING;
	participant = poke;
	current_text = "";
	level_up_timer.start();
	play_audio(PKMN_LEVEL_UP, 0.3, -5);
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await level_up_timer.timeout;
			current_text += input_arr[i][j];
			label.text = current_text;
	
	marker.visible = true;
	await GLOBAL.timeout(0.2);
	pressed = false;

#SWITCH
func switch(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.SWITCHING;
	BATTLE.can_use_menu = false;
	marker.visible = false;
	visible = true;
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
	BATTLE.dialog_finished.emit();

#END
func end_dialog() -> void:
	BATTLE.state = BATTLE.States.NONE;
	timer.stop();
	current_text = "";
	pressed = (BATTLE.enemy_death || BATTLE.pokemon_death);
	if(
		!BATTLE.intro_dialog && 
		!BATTLE.pokemon_death && 
		!BATTLE.enemy_death &&
		!BATTLE.escaping
	): close(0);
	BATTLE.dialog_finished.emit();
	await GLOBAL.timeout(.3);
	if(!BATTLE.exp_loop): BATTLE.state = BATTLE.States.MENU;

#ESCAPE
func escape(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.ESCAPING;
	pressed = true;
	marker.visible = false;
	visible = true;
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

func escape_input() -> void:
	if(pressed): return;
	if Input.is_action_just_pressed("space"):

		pressed = true;
		BATTLE.state = BATTLE.States.NONE;
		play_audio(CONFIRM);
		await audio.finished;
		marker.visible = false;
		await GLOBAL.timeout(.2);
		BATTLE.dialog_finished.emit();
		pressed = false;
		current_text = "";
		label.text = "";

#NEXT POKEMON
func next_pokemon(input_arr: Array) -> void:
	BATTLE.state = BATTLE.States.NONE;
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
	
	await GLOBAL.timeout(.2);
	pressed = false;
	BATTLE.dialog_finished.emit();

#CLOSE
func close(time: float) -> void:
	visible = false;
	await GLOBAL.timeout(time);
	BATTLE.can_use_menu = true;

func set_label(text: String) -> void: label.text = text;
func set_current_text(text: String) -> void: current_text = text;

func play_audio(stream: AudioStream, delay = 0.0, volume = -10) -> void:
	await GLOBAL.timeout(delay);
	audio.volume_db = volume;
	audio.stream = stream;
	audio.play();
