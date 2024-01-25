extends Node

enum Moves { FIRST, SECOND, THIRD, FOURTH }

const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const BATTLE_FLEE = preload("res://Assets/Sounds/Battle flee.ogg");
const MovesAnimations = preload("res://Scenes/Battle/Moves/moves_animations.gd");
const default_hp_bar_size = 48.0;

#PLAYER
@onready var player_info = $Info/PlayerInfo;
@onready var attack_cursor = $Selection/AttackCursor;
@onready var player_sprite = $UI/PlayerSprite;
@onready var audio_player = $UI/PlayerSprite/AudioStreamPlayer;
#ENEMY
@onready var enemy_info = $Info/EnemyInfo;
@onready var enemy_anim_player = $UI/EnemySprite/EnemyAnimationPlayer;
@onready var enemy_sprite = $UI/EnemySprite;
@onready var enemy_hp_bar = $Info/EnemyHPBar;

#BATTLE
@onready var menu = $Menu;
@onready var bag = $Bag;
@onready var dialog = $Dialog;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var dialog_timer = $Dialog/Timer;
@onready var menu_cursor = $Menu/MenuCursor;
@onready var dialog_label = $Dialog/Label;
@onready var dialog_marker = $Dialog/Marker;
@onready var menu_label = $Menu/Label;

#ATTACKS
@onready var attack_selection_info = $Selection/SelectionInfo
@onready var attack_01 = $Selection/Attack01;
@onready var attack_02 = $Selection/Attack02;
@onready var attack_03 = $Selection/Attack03;
@onready var attack_04 = $Selection/Attack04;
@onready var attack_selection = $Selection;
@onready var player_attacks = [attack_01, attack_02, attack_03, attack_04];

var pokemon: Object;
var enemy: Object;
var battle_data: Dictionary;
var current_state = BATTLE.States.NONE;
var can_use_menu = false;
var attack_pressed = false;
var selected_attack = Moves.FIRST;
var attacking = false;

var dialog_pressed = false;
var dialog_array: Array
var dialog_line: int
var current_dialog_text: String = "";
var intro_dialog = true;

var green_bar = Color(0.56, 0.97, 0.65);
var yellow_bar = Color(0.97, 0.87, 0.22);
var red_bar = Color(0.81, 0.15, 0.15);

var menu_cursor_index = Vector2.ZERO;
var attack_cursor_index = Vector2.ZERO;
var player_moves = [];
var enemy_moves = [];

var enemy_dead = false;
var pokemon_dead = false;

func _ready():
	connect_signals();
	set_battle_ui();
	match(battle_data.type):
		BATTLE.Type.WILD: battle_wild();

func set_battle_data(data: Dictionary): battle_data = data;

func _unhandled_key_input(event) -> void:
	if(
	false
	): return;
	if(event.is_action_pressed("escape")): 
		GLOBAL.emit_signal("close_battle");
		return;
		
	match current_state:
		BATTLE.States.MENU: menu_input(event);
		BATTLE.States.FIGHT: attack_input(event)
		#States.BAG:
			#bag_input(event)
		#States.PARTY:
			#party_input(event)
#		states.RUN:
#			action(3, "Flee")
		BATTLE.States.DIALOG: dialog_input(event);

func battle_wild() -> void:
	anim_player.play("Start");
	await BATTLE.dialog_finished;
	anim_player.play("Go");

func start_battle_dialog() -> void:
	start_dialog(["A wild " + enemy.data.name + " appeared!\n", "Go " + pokemon.data.name + "!" ]);

func check_intro_dialog() -> void:
	close_dialog_and_show_menu(.3);
	menu_label.text = "Ready! What will be your next move?"
	intro_dialog = false;

func set_battle_ui() -> void:
	set_player_ui();
	set_enemy_ui();
	pass
	#var background = zones_array[data.zone];
	#texture_rect.texture = background;

#UI
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
	
	menu_cursor.position = BATTLE.menu_cursor_pos[menu_cursor_index.y][menu_cursor_index.x];
	
	#SELECTION
	if event.is_action_pressed("space"):
		play_audio(CONFIRM);
		await audio.finished;
		match_menu_input();

func match_menu_input() -> void:
	if menu_cursor_index == Vector2.ZERO:
		attack_selection.visible = true;
		current_state = BATTLE.States.FIGHT;
		update_attack_ui();
	elif menu_cursor_index == Vector2.RIGHT: pass
		#bag.visible = true;
		#current_state = States.BAG;
	elif menu_cursor_index == Vector2.DOWN: pass
		#pokemon.visible = true
		#current_state = States.PARTY;
	elif menu_cursor_index == Vector2(1, 1): end_battle();

#CLOSE BATTLE
func end_battle(sound = true) -> void:
	can_use_menu = false;
	if(sound): 
		play_audio(BATTLE_FLEE);
		await audio.finished;
	battle_anim_player.play("FadetoBlack");

func close_battle() -> void:
	print("hey")
	GLOBAL.emit_signal("close_battle");
	AUDIO.stop_battle_and_play_last_song();

#DIALOG STATE
func start_dialog(input_arr: Array) -> void:
	current_state = BATTLE.States.DIALOG;
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

func dialog_input(event: InputEvent) -> void:
	if(dialog_pressed): return;
	if event.is_action_pressed("space"):
		dialog_marker.visible = false;
		dialog_pressed = true;
		play_audio(CONFIRM);
		await audio.finished;
		if dialog_line < len(dialog_array): next_dialog();
		elif(enemy_dead): end_battle(false)
		else: end_dialog();

func next_dialog() -> void:
	if(enemy_dead): AUDIO.play_battle_win(battle_data.type);
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
	if(!intro_dialog): close_dialog_and_show_menu(0);
	await GLOBAL.timeout(.2);
	current_state = BATTLE.States.MENU;
	BATTLE.dialog_finished.emit();

func close_dialog_and_show_menu(time: float) -> void:
	dialog.visible = false;
	menu.visible = true;
	await GLOBAL.timeout(time);
	can_use_menu = true;

#ATTACKS
func attack_input(event: InputEvent) -> void:
	attack_pressed = false;
	var pre_position = attack_cursor_index;
	if event.is_action_pressed("moveLeft") and attack_cursor_index.x > 0:
		attack_cursor_index.x -= 1;
	elif event.is_action_pressed("moveRight") and attack_cursor_index.x < 1:
		attack_cursor_index.x += 1;
	elif event.is_action_pressed("moveUp") and attack_cursor_index.y > 0:
		attack_cursor_index.y -= 1;
	elif event.is_action_pressed("moveDown") and attack_cursor_index.y < 1:
		attack_cursor_index.y += 1;
	elif event.is_action_pressed("backMenu"):
		play_audio(GUI_SEL_DECISION);
		attack_selection.visible = false;
		current_state = BATTLE.States.MENU;
	elif event.is_action_pressed("space") and !attack_pressed: 
		start_attack();
		return;
		
	var new_position = BATTLE.attack_cursor_pos[attack_cursor_index.y][attack_cursor_index.x];
	if(!can_move_attack_cursor(pre_position, new_position)): return;
	attack_cursor.position = new_position;
	if (pre_position != attack_cursor_index): play_audio(GUI_SEL_DECISION);
	set_attack_slot();
	update_attack_ui();

func start_attack() -> void:
	attack_pressed = true;
	var move = player_moves[selected_attack];
	var attack_success = pokemon.attack(enemy, move);
	if(attack_success && current_state != BATTLE.States.ATTACKING):
		battle_anim_player.stop();
		play_audio(CONFIRM);
		start_attack_dialog([pokemon.name + " use " + move.name.to_upper() + "."]);
		await BATTLE.dialog_finished;
		current_state = BATTLE.States.ATTACKING;
		add_animation_and_play(move);
		attack_pressed = false;
		update_attack_ui();
		check_battle_state();

#UPDATES
func update_battle_ui() -> void:
	var tween = get_tree().create_tween();
	var new_size = round((default_hp_bar_size * enemy.data.health) / 100);
	var hp_size = enemy_hp_bar.size.x;
	tween.tween_property(enemy_hp_bar, "size:x", new_size, .3);
	#69%
	if(
		hp_size <= (69.0 * default_hp_bar_size) / 100 &&
		hp_size > (28.0 * default_hp_bar_size) / 100
	): enemy_hp_bar.color = yellow_bar;
	#28%
	elif(hp_size <= (28.0 * default_hp_bar_size) / 100):
		enemy_hp_bar.color = red_bar;

func update_attack_ui() -> void:
	var current_attack = player_moves[selected_attack];
	var type_node = attack_selection_info.get_node("Type");
	var pp_node = attack_selection_info.get_node("PP/Value");
	
	type_node.text = MOVES.TypesString[current_attack.type + 1];
	pp_node.text = str(current_attack.pp) + "/" + str(current_attack.total_pp);

func check_battle_state() -> void:
	await BATTLE.attack_finished;
	if(enemy.data.health <= 0):
		enemy_dead = true;
		can_use_menu = false;
		battle_anim_player.stop();
		start_dialog([enemy.data.name + " fainted!\n", pokemon.data.name + " gained " + str(50) + " EXP"]);
		await BATTLE.dialog_finished;
		end_battle(false);

#ANIMATION
func add_animation_and_play(move: Dictionary) -> void:
	var list = MovesAnimations.new();
	var animation = list.get_move_animation(move.name.to_lower());
	call_deferred("add_child", animation);
	animation.set_data_and_attack(player_sprite);
	await BATTLE.attack_finished;
	player_sprite.visible = true;
	animation.call_deferred("queue_free");

#ATTACK DIALOG
func start_attack_dialog(input_arr: Array) -> void:
	current_state = BATTLE.States.NONE;
	attack_selection.visible = false;
	dialog.visible = true
	dialog_array = input_arr.duplicate()
	dialog_timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await dialog_timer.timeout;
			current_dialog_text += input_arr[i][j];
			dialog_label.text = current_dialog_text;
	
	await get_tree().create_timer(.6).timeout;
	current_dialog_text = "";
	dialog_label.text = "";
	BATTLE.dialog_finished.emit();
	after_attacking();

func after_attacking() -> void:
	await BATTLE.attack_finished;
	await GLOBAL.timeout(.1);
	if(enemy_dead): return;
	dialog.visible = false;
	current_state = BATTLE.States.MENU;

func _on_move_hit() -> void:
	update_battle_ui();
	battle_anim_player.play("DamageEnemy");
	await battle_anim_player.animation_finished;
	battle_anim_player.play("Idle")

func set_attack_slot() -> void:
	if(attack_cursor_index == Vector2.ZERO): selected_attack = Moves.FIRST;
	elif(attack_cursor_index == Vector2.RIGHT): selected_attack = Moves.SECOND;
	elif(attack_cursor_index == Vector2.DOWN): selected_attack = Moves.THIRD;
	elif(attack_cursor_index == Vector2(1, 1)): selected_attack = Moves.FOURTH;

func play_shout_pokemon() -> void:
	audio_player.stream = pokemon.data.shout;
	audio_player.play();

func play_move_and_shout_enemy() -> void:
	enemy_anim_player.play("Move");
	await GLOBAL.timeout(.2);
	play_audio(enemy.data.shout);

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

func connect_signals() -> void:
	BATTLE.connect("on_move_hit", _on_move_hit);
