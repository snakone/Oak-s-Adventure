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

const menu_cursor_pos: Array = [
	[Vector2(135, 129), Vector2(194, 129)], 
	[Vector2(135, 144), Vector2(194, 144)]
];

const attack_cursor_pos: Array = [
	[Vector2(13, 127), Vector2(80, 127)], 
	[Vector2(13, 145), Vector2(80, 145)]
];

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

#PLAYER
@onready var player_info = $Info/PlayerInfo;
@onready var attack_cursor = $Selection/AttackCursor
@onready var player_sprite = $UI/PlayerSprite;

#ENEMY
@onready var enemy_info = $Info/EnemyInfo;
@onready var idle_enemy_animation_player = $IdleEnemyAnimationPlayer;
@onready var enemy_anim_player = $UI/EnemySprite/AnimationPlayer;
@onready var enemy_sprite = $UI/EnemySprite;

#BATTLE
@onready var menu = $Menu;
@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var dialog = $Dialog;
@onready var dialog_timer = $Dialog/Timer;
@onready var dialog_label = $Dialog/Label;
@onready var dialog_marker = $Dialog/Marker;
@onready var menu_label = $Menu/Label;
@onready var menu_cursor = $Menu/MenuCursor;
@onready var bag = $Bag;

#ATTACKS
@onready var attack_01 = $Selection/Attack01;
@onready var attack_02 = $Selection/Attack02;
@onready var attack_03 = $Selection/Attack03;
@onready var attack_04 = $Selection/Attack04;
@onready var attack_selection = $Selection;
@onready var player_attacks = [attack_01, attack_02, attack_03, attack_04];

var pokemon: Object;
var enemy: Object;
var battle_data: Dictionary;
var current_state: States = States.NONE;
var can_use_menu = false;
var attack_pressed = false;

var dialog_pressed = false;
var dialog_array: Array
var dialog_line: int
var current_dialog_text: String = "";
var intro_dialog = true;

var green_bar = Color(122, 248, 174, 1);
var yellow_bar = Color();
var red_bar = Color();

var menu_cursor_index = Vector2.ZERO;
var attack_cursor_index = Vector2.ZERO;
var player_moves = [];
var enemy_moves = [];

func _ready():
	set_battle_ui();
	match(battle_data.type):
		BATTLE.Type.WILD: battle_wild();

func set_battle_data(data: Dictionary): battle_data = data;

func _input(event: InputEvent) -> void:
	if(!event.is_pressed() || event.is_echo()): return;
	match current_state:
		States.MENU: menu_input(event);
		States.FIGHT: attack_input(event)
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
	start_dialog(["A wild " + enemy.data.name + " appeared!\n", "Go " + pokemon.data.name + "!" ]);
	await BATTLE.dialog_finished;
	anim_player.play("Go");
	await anim_player.animation_finished;
	battle_anim_player.play("Idle");
	idle_enemy_animation_player.play("Idle");
	check_intro_dialog();

func check_intro_dialog() -> void:
	if(intro_dialog):
		menu_label.text = "Ready! What will be your next move?"
		dialog.visible = false;
		menu.visible = true;
		intro_dialog = false;
		await GLOBAL.timeout(.3);
		can_use_menu = true;

func set_battle_ui() -> void:
	set_player_ui();
	set_enemy_ui();
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

func set_player_ui() -> void:
	pokemon = PARTY.get_active_pokemon();
	var name_node = player_info.get_node("Name");
	var player_dist = name_node.get_content_width() + name_node.position.x + 6;
	var health = str(pokemon.data.current_hp) + "/" + str(pokemon.data.total_hp);
	
	#INFO
	player_sprite.texture = pokemon.data.back_texture;
	name_node.text = pokemon.data.name;
	player_info.get_node("Gender").frame = pokemon.data.gender;
	player_info.get_node("Level").text = "Lv" + str(pokemon.data.level);
	player_info.get_node("HP").text = health;
	player_info.get_node("Gender").position.x = player_dist;
	
	#MOVES
	for move in pokemon.data.moves:
		player_moves.push_back(MOVES.get_move(move));
	
	for i in range(len(player_moves)):
		var move = player_moves[i];
		player_attacks[i].visible = true;
		player_attacks[i].text = move.name.to_upper();

func set_enemy_ui() -> void:
	enemy = Pokemon.new(POKEDEX.get_pokemon(battle_data["enemy"]), true);
	var enemy_node_name = enemy_info.get_node("Name");
	var enemy_dist = enemy_node_name.get_content_width() + enemy_node_name.position.x + 5;
	var level = str(battle_data.levels[randi() % battle_data.levels.size()]);
	
	enemy_sprite.texture = enemy.data.front_texture;
	enemy_info.get_node("Name").text = enemy.data.name;
	enemy_info.get_node("Gender").frame = enemy.data.gender;
	enemy_info.get_node("Level").text = "Lv" + level;
	enemy_info.get_node("Gender").position.x = enemy_dist;

func start_dialog(input_arr: Array) -> void:
	current_state = States.DIALOG;
	dialog_pressed = true;
	dialog_marker.visible = false;
	dialog.visible = true;
	dialog_array = input_arr.duplicate();
	dialog_line = 1;
	dialog_timer.start();
	
	for i in range(dialog_line):
		for j in range(len(input_arr[i])):
			await dialog_timer.timeout;
			current_dialog_text += input_arr[i][j];
			dialog_label.text = current_dialog_text;
	
	dialog_marker.visible = true;
	await GLOBAL.timeout(.2);
	dialog_pressed = false;

#MENU STATE
func menu_input(event: InputEvent) -> void:
	#ARROW
	if(!can_use_menu): return;
	if event.is_action_pressed("moveLeft") && menu_cursor_index.x > 0:
		menu_cursor_index.x -= 1;
		play_audio(GUI_SEL_DECISION);
	elif event.is_action_pressed("moveRight") && menu_cursor_index.x < 1:
		menu_cursor_index.x += 1;
		play_audio(GUI_SEL_DECISION);
	elif event.is_action_pressed("moveDown") && menu_cursor_index.y < 1:
		menu_cursor_index.y += 1;
		play_audio(GUI_SEL_DECISION);
	elif event.is_action_pressed("moveUp") && menu_cursor_index.y > 0:
		menu_cursor_index.y -= 1;
		play_audio(GUI_SEL_DECISION);
	
	menu_cursor.position = menu_cursor_pos[menu_cursor_index.y][menu_cursor_index.x];
	
	#SELECTION
	if event.is_action_pressed("space"):
		play_audio(CONFIRM);
		await audio.finished;
		match_menu_input();

func match_menu_input() -> void:
	if menu_cursor_index == Vector2.ZERO:
		attack_selection.visible = true;
		current_state = States.FIGHT;
	elif menu_cursor_index == Vector2.RIGHT: pass
		#bag.visible = true;
		#current_state = States.BAG;
	elif menu_cursor_index == Vector2.DOWN: pass
		#pokemon.visible = true
		#current_state = States.PARTY;
	elif menu_cursor_index == Vector2(1, 1):
		GLOBAL.emit_signal("close_battle");

#DIALOG STATE
func dialog_input(event: InputEvent) -> void:
	if(dialog_pressed): return;
	if event.is_action_pressed("space"):
		dialog_marker.visible = false;
		dialog_pressed = true
		play_audio(CONFIRM);
		await audio.finished;
		if dialog_line < len(dialog_array): next_dialog();
		else: end_dialog();

func next_dialog() -> void:
	current_dialog_text = current_dialog_text.erase(0, current_dialog_text.find("\n") + 1)
	dialog_label.text = current_dialog_text;
	if current_dialog_text.find("\n") == -1:
		for i in range(len(dialog_array[dialog_line])):
			await dialog_timer.timeout
			current_dialog_text += dialog_array[dialog_line][i];
			dialog_label.text = current_dialog_text;
	dialog_line += 1;
	await GLOBAL.timeout(.2);
	dialog_pressed = false;
	if(intro_dialog):
		dialog_marker.visible = false;
		end_dialog();
	else: dialog_marker.visible = true;

func end_dialog() -> void:
	dialog_timer.stop();
	current_dialog_text = "";
	dialog_pressed = false;
	if(!intro_dialog):
		dialog.visible = false;
		menu.visible = true;
		can_use_menu = true;
	await GLOBAL.timeout(.2);
	current_state = States.MENU;
	BATTLE.dialog_finished.emit();

#ATTACKS
func attack_input(event: InputEvent) -> void:
	var pre_position = attack_cursor_index;
	if event.is_action_pressed("moveLeft") and attack_cursor_index.x > 0:
		attack_cursor_index.x -= 1;
	elif event.is_action_pressed("moveRight") and attack_cursor_index.x < 1:
		attack_cursor_index.x += 1;
	elif event.is_action_pressed("moveUp") and attack_cursor_index.y > 0:
		attack_cursor_index.y -= 1;
	elif event.is_action_pressed("moveDown") and attack_cursor_index.y < 1:
		attack_cursor_index.y += 1;

	var new_position = attack_cursor_pos[attack_cursor_index.y][attack_cursor_index.x];
	if(!can_move_attack_cursor(pre_position, new_position)): return;
	attack_cursor.position = new_position;
	if (pre_position != attack_cursor_index): play_audio(GUI_SEL_DECISION);

	if event.is_action_pressed("backMenu"):
		play_audio(GUI_SEL_DECISION);
		attack_selection.visible = false;
		current_state = States.MENU;
	elif event.is_action_pressed("space") and !attack_pressed:
		attack_pressed = true;
		play_audio(CONFIRM);
		print("ATTACK ANIMATION!");

func play_shout() -> void: enemy_anim_player.play("Shout");

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func can_move_attack_cursor(pre_position: Vector2, new_position: Vector2) -> bool:
	var attack2_position = Vector2(80, 127);
	var attack2_text = player_attacks[1].text;
	var attack3_position = Vector2(13, 145);
	var attack3_text = player_attacks[2].text;
	var attack4_position = Vector2(80, 145);
	var attack4_text = player_attacks[3].text;
	
	if(
		(new_position == attack2_position && attack2_text == "") ||
		(new_position == attack3_position && attack3_text == "") ||
		(new_position == attack4_position && attack4_text == "")
	): 
		attack_cursor_index = pre_position;
		return false;
	return true;
