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
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");

signal dialog_finished()

@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var idle_enemy_animation_player = $IdleEnemyAnimationPlayer
@onready var menu = $Menu;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var dialog = $Dialog;
@onready var dialog_timer = $Dialog/Timer;
@onready var dialog_label = $Dialog/Label;
@onready var dialog_marker = $Dialog/Marker;
@onready var enemy_anim_player = $UI/EnemySprite/AnimationPlayer;
@onready var menu_label = $Menu/Label;
@onready var menu_cursor = $Menu/MenuCursor;
@onready var attack_selection = $Selection;
@onready var bag = $Bag;
@onready var attack_cursor = $Selection/AttackCursor

@onready var player_sprite = $UI/PlayerSprite;
@onready var enemy_sprite = $UI/EnemySprite;
@onready var player_info = $Info/PlayerInfo;
@onready var enemy_info = $Info/EnemyInfo;

@onready var attack_01 = $Selection/Attack01;
@onready var attack_02 = $Selection/Attack02;
@onready var attack_03 = $Selection/Attack03;
@onready var attack_04 = $Selection/Attack04;

@onready var player_attacks = [attack_01, attack_02, attack_03, attack_04];

var active_pokemon: Object;
var enemy: Object;

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

const menu_cursor_positions: Array = [
	[Vector2(135, 129), Vector2(194, 129)], 
	[Vector2(135, 144), Vector2(194, 144)]
];

const attack_cursor_positons: Array = [
	[Vector2(13, 127), Vector2(80, 127)], 
	[Vector2(13, 145), Vector2(80, 145)]
];

var battle_data: Dictionary;
var current_state: States = States.NONE;
var dialog_pressed = false;
var dialog_text: Array
var dialog_line: int
var current_dialog_txt: String = "";

var green_bar = Color(122, 248, 174, 1);
var yellow_bar = Color();
var red_bar = Color();
var menu_cursor_index = Vector2.ZERO;
var attack_cursor_index = Vector2.ZERO;
var can_use_menu = false;
var attack_pressed = false;

var intro_dialog = true;

var player_moves = [];
var enemy_moves = [];

func _ready():
	set_battle_ui();
	match(battle_data.type):
		BATTLE.Type.WILD: battle_wild();

func _input(event: InputEvent) -> void:
	if(!event.is_pressed() || event.is_echo()): return;
	match current_state:
		States.MENU: menu_input(event);
		States.FIGHT: attack_select_input(event)
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
	start_dialog(["A wild " + enemy.data.name + " appeared!\n", "Go " + active_pokemon.data.name + "!" ]);
	await dialog_finished;
	anim_player.play("Go")
	await anim_player.animation_finished;
	battle_anim_player.play("Idle");
	idle_enemy_animation_player.play("Idle");
	if(intro_dialog):
		dialog.visible = false;
		menu_label.text = "Ready! What will be your next move?"
		menu.visible = true;
		intro_dialog = false;
		await GLOBAL.timeout(.3);
		can_use_menu = true;

func set_battle_ui() -> void:
	active_pokemon = PARTY.get_active_pokemon();
	player_sprite.texture = active_pokemon.data.back_texture;
	player_info.get_node("Name").text = active_pokemon.data.name;
	player_info.get_node("Gender").frame = active_pokemon.data.gender;
	player_info.get_node("Level").text = "Lv" + str(active_pokemon.data.level);
	player_info.get_node("HP").text = str(active_pokemon.data.current_hp) + "/" + str(active_pokemon.data.total_hp);
	
	var enemy_dist = enemy_info.get_node("Name").get_content_width() + enemy_info.get_node("Name").position.x + 5;
	enemy_info.get_node("Gender").position.x = enemy_dist;
	var player_dist = player_info.get_node("Name").get_content_width() + player_info.get_node("Name").position.x + 6;
	player_info.get_node("Gender").position.x = player_dist;

	enemy = Pokemon.new(POKEDEX.get_pokemon(battle_data.enemy), true);
	
	enemy_sprite.texture = enemy.data.front_texture;
	enemy_info.get_node("Name").text = enemy.data.name;
	enemy_info.get_node("Gender").frame = enemy.data.gender;
	enemy_info.get_node("Level").text = "Lv" + str(battle_data.levels[randi() % battle_data.levels.size()]);
	
	for move in active_pokemon.data.moves:
		player_moves.push_back(MOVES.get_move(move));
	
	for i in range(len(player_moves)):
		var move = player_moves[i];
		player_attacks[i].visible = true;
		player_attacks[i].text = move.name.to_upper();
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func play_shout() -> void: enemy_anim_player.play("Shout");
func set_battle_data(data: Dictionary): battle_data = data;

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
		menu_cursor_index.x -= 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveRight") && menu_cursor_index.x < 1:
		menu_cursor_index.x += 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveDown") && menu_cursor_index.y < 1:
		menu_cursor_index.y += 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveUp") && menu_cursor_index.y > 0:
		menu_cursor_index.y -= 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	
	menu_cursor.position = menu_cursor_positions[menu_cursor_index.y][menu_cursor_index.x]
	
	if event.is_action_pressed("space"):
		audio.stream = CONFIRM;
		audio.play();
		await audio.finished;
		match_menu_input();

func match_menu_input() -> void:
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
	
func attack_select_input(event: InputEvent) -> void:
	var pre_position = attack_cursor_index;
	if event.is_action_pressed("moveLeft") and attack_cursor_index.x > 0:
		attack_cursor_index.x -= 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveRight") and attack_cursor_index.x < 1:
		attack_cursor_index.x += 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveUp") and attack_cursor_index.y > 0:
		attack_cursor_index.y -= 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
	elif event.is_action_pressed("moveDown") and attack_cursor_index.y < 1:
		attack_cursor_index.y += 1;
		audio.stream = GUI_SEL_DECISION;
		audio.play();
		
	var new_position = attack_cursor_positons[attack_cursor_index.y][attack_cursor_index.x];
	print(new_position)
	
	if(
		(new_position == Vector2(80, 145) && player_attacks[3].text == "") ||
		(new_position == Vector2(13, 145) && player_attacks[2].text == "") ||
		(new_position == Vector2(80, 127) && player_attacks[1].text == "")
	): 
		attack_cursor_index = pre_position;
		return;
	attack_cursor.position = new_position;
		
	if event.is_action_pressed("backMenu"):
		audio.stream = GUI_MENU_CLOSE;
		audio.play();
		attack_selection.visible = false;
		current_state = States.MENU;
	elif event.is_action_pressed("space") and !attack_pressed:
		attack_pressed = true;
		audio.stream = CONFIRM;
		audio.play();
		print("ATTACK ANIMATION!");
