extends Node

enum States {
	MENU = 0, 
	FIGHT = 1, 
	BAG = 2, 
	PARTY = 3, 
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
@onready var menu_cursor = $Menu/MenuCursor;
@onready var attack_selection = $Selection;
@onready var bag = $Bag;

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

const menu_cursor_positions: Array = [
	[Vector2(135, 129), Vector2(194, 129)], 
	[Vector2(135, 144), Vector2(194, 144)]
];

var data: Dictionary;
var current_state: States = States.NONE;
var dialog_pressed = false;
var dialog_text: Array
var dialog_line: int
var current_dialog_txt: String = "";

var green_bar = Color(122, 248, 174, 1);
var yellow_bar = Color();
var red_bar = Color();
var menu_cursor_index = Vector2.ZERO;
var can_use_menu = false;

var enemy = "Mewtwo";
var yo = "Treecko";

var intro_dialog = true;

func _ready():
	set_battle_ui();
	match(data.type):
		BATTLE.Type.WILD: battle_wild();

func _input(event: InputEvent) -> void:
	if(!event.is_pressed() || event.is_echo()): return;
	match current_state:
		States.MENU: menu_input(event);
		#States.FIGHT:
			#attack_select_input(event)
		#States.BAG:
			#bag_input(event)
		#States.POKEDEX:
			#pokemon_input(event)
#		states.RUN:
#			action(3, "Flee")
		States.DIALOG: dialog_input(event);

func battle_wild() -> void:
	anim_player.play("Start");
	await anim_player.animation_finished;
	start_dialog(["A wild " + enemy + " appeared!\n", "Go " + yo + "!" ]);
	await dialog_finished;
	anim_player.play("Go")
	await anim_player.animation_finished;
	battle_anim_player.play("Idle");
	if(intro_dialog):
		dialog.visible = false;
		menu_label.text = "Ready! What will be your next move?"
		menu.visible = true;
		intro_dialog = false;
		await GLOBAL.timeout(.3);
		can_use_menu = true;

func set_battle_ui() -> void:
	var enemy_dist = eneny_name_text.get_content_width() + eneny_name_text.position.x + 5;
	enemy_gender.position.x = enemy_dist;
	var player_dist = player_name_text.get_content_width() + player_name_text.position.x + 6;
	player_gender.position.x = player_dist;
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func play_shout() -> void: enemy_anim_player.play("Shout");
func set_battle_data(battle_data: Dictionary): data = battle_data;

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

#MENU STATE
func menu_input(event: InputEvent) -> void:
	if(!can_use_menu): return;
	if event.is_action_pressed("moveLeft") && menu_cursor_index.x > 0:
		menu_cursor_index.x -= 1
	elif event.is_action_pressed("moveRight") && menu_cursor_index.x < 1:
		menu_cursor_index.x += 1
	elif event.is_action_pressed("moveDown") && menu_cursor_index.y < 1:
		menu_cursor_index.y += 1
	elif event.is_action_pressed("moveUp") && menu_cursor_index.y > 0:
		menu_cursor_index.y -= 1
	
	menu_cursor.position = menu_cursor_positions[menu_cursor_index.y][menu_cursor_index.x]
	
	if event.is_action_pressed("space"):
		audio.stream = CONFIRM;
		audio.play();
		await audio.finished;
		match_menue_input();

func match_menue_input() -> void:
	if menu_cursor_index == Vector2.ZERO:
		attack_selection.visible = true
		current_state = States.FIGHT;
	elif menu_cursor_index == Vector2(1, 0):
		bag.visible = true
		current_state = States.BAG;
	#elif menu_cursor_index == Vector2i(0, 1):
		#pokemon.visible = true
		current_state = States.PARTY;
	elif menu_cursor_index == Vector2(1, 1):
		GLOBAL.emit_signal("close_battle");

#DIALOG STATE
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
	await GLOBAL.timeout(.2);
	dialog_pressed = false;
	if(intro_dialog):
		dialog_marker.visible = false;
		end_dialog();
	else: dialog_marker.visible = true;

func end_dialog() -> void:
	dialog_timer.stop()
	current_dialog_txt = ""
	if(!intro_dialog):
		dialog.visible = false;
		menu.visible = true;
		can_use_menu = true;
	dialog_pressed = false;
	await GLOBAL.timeout(.2);
	current_state = States.MENU;
	dialog_finished.emit();
