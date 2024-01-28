extends Node

enum Moves { FIRST, SECOND, THIRD, FOURTH }

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const BATTLE_FLEE = preload("res://Assets/Sounds/Battle flee.ogg");
const MovesAnimations = preload("res://Scenes/Battle/Moves/moves_animations.gd");

#PLAYER
@onready var player_info = $Info/PlayerInfo;
@onready var attack_cursor = $Selection/AttackCursor;
@onready var player_sprite = $UI/PlayerSprite;
@onready var audio_player = $UI/PlayerSprite/AudioStreamPlayer;
@onready var player_ground = $Ground/PlayerGround;
@onready var player_hp_bar = $Info/PlayerInfo/PlayerHPBar;
@onready var exp_bar = $Info/PlayerInfo/ExpBar;

#ENEMY
@onready var enemy_info = $Info/EnemyInfo;
@onready var enemy_anim_player = $UI/EnemySprite/EnemyAnimationPlayer;
@onready var enemy_sprite = $UI/EnemySprite;
@onready var enemy_hp_bar = $Info/EnemyInfo/EnemyHPBar;
@onready var enemy_ground = $Ground/EnemyGround;

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
@onready var battle_background = $Background;
@onready var attack_background = $Selection/Background;
@onready var menu_background = $Menu/Background;

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

var menu_cursor_index = Vector2.ZERO;
var attack_cursor_index = Vector2.ZERO;
var player_moves = [];
var enemy_moves = [];

var enemy_attacked = false;
var player_attacked = false;
var pokemon_death = false;
var enemy_death = false;

var exp_to_next_level = 0;
var base_exp_level = 0;

func _ready():
	connect_signals();
	set_battle_ui();
	match(battle_data.type):
		BATTLE.Type.WILD: battle_wild();

func set_battle_data(data: Dictionary): battle_data = data;

func _unhandled_key_input(event) -> void:
	if(
		!event is InputEventKey || 
		current_state == BATTLE.States.ATTACKING ||
		event.is_echo() ||
		!event.is_pressed() ||
		GLOBAL.menu_open
	): return;
	if(event.is_action_pressed("escape")): 
		end_battle(false);
		return;
		
	match current_state:
		BATTLE.States.MENU: menu_input(event);
		BATTLE.States.FIGHT: attack_input(event)
		#States.BAG:
			#bag_input(event)
		#States.PARTY:
			#party_input(event)
		#states.RUN:
			#action(3, "Flee")
		BATTLE.States.DIALOG: dialog_input(event);

func battle_wild() -> void:
	anim_player.play("Start");
	await BATTLE.dialog_finished;
	anim_player.play("Go");

func start_battle_dialog() -> void:
	start_dialog([
		"A wild " + enemy.data.name + " appeared!\n", 
		"Go " + pokemon.data.name + "!"
	]);

#INTRO
func check_intro_dialog() -> void:
	close_dialog_and_show_menu(.3);
	menu_label.text = "Ready! What will be your next move?"
	intro_dialog = false;

#UI
func set_battle_ui() -> void:
	set_player_ui();
	set_enemy_ui();
	set_battle_texture();
	set_markers();
	update_battle_ui(true);

#PLAYER UI
func set_player_ui() -> void:
	pokemon = PARTY.get_active_pokemon();
	var name_node = player_info.get_node("Name");
	name_node.text = pokemon.data.name;
	var player_dist = name_node.get_content_width() + name_node.position.x + 6;
	
	#INFO
	player_sprite.texture = pokemon.data.back_texture;
	player_info.get_node("Gender").frame = pokemon.data.gender;
	player_info.get_node("Level").text = "Lv" + str(pokemon.data.level);
	player_info.get_node("Gender").position.x = player_dist;
	
	#MOVES
	player_moves = pokemon.data.battle_moves;
	
	for i in range(len(player_moves)):
		var move = player_moves[i];
		player_attacks[i].visible = true;
		player_attacks[i].text = move.name.to_upper();
	
	#EXP
	exp_to_next_level = pokemon.get_exp_to_next_level();
	base_exp_level = pokemon.get_exp_by_level();
	update_exp_bar();

func update_player_health() -> void: #LEFT ALIGNED
	var health = str(pokemon.data.battle_stats["HP"]) + " / " + str(pokemon.data.current_hp);
	player_info.get_node("HP").text = health;

#ENEMY UI
func set_enemy_ui() -> void:
	enemy = Pokemon.new(POKEDEX.get_pokemon(battle_data["enemy"]), true, battle_data.levels);
	var enemy_node_name = enemy_info.get_node("Name");
	enemy_node_name.text = enemy.data.name;
	var enemy_dist = enemy_node_name.get_content_width() + enemy_node_name.position.x + 5;
	
	enemy_sprite.texture = enemy.data.front_texture;
	enemy_info.get_node("Gender").frame = enemy.data.gender;
	enemy_info.get_node("Level").text = "Lv" + str(enemy.data.level);
	enemy_info.get_node("Gender").position.x = enemy_dist;
	
	#MOVES
	for move in enemy.data.moves:
		enemy_moves.push_back(MOVES.get_move(move));

#TEXTURES
func set_battle_texture() -> void:
	var battle_textures = BATTLE.get_battle_textures(battle_data.zone);
	battle_background.texture = battle_textures.background;
	player_ground.texture = battle_textures.player_ground;
	enemy_ground.texture = battle_textures.enemy_ground;

#MARKERS
func set_markers() -> void:
	var markers = BATTLE.get_markers(SETTINGS.selected_type);
	attack_background.texture = markers.attack;
	menu_background.texture = markers.menu;

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
		await GLOBAL.timeout(.8);
	battle_anim_player.play("FadetoBlack");

func close_battle() -> void:
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
		else: end_dialog();

func next_dialog() -> void:
	if(enemy_death): AUDIO.play_battle_win(battle_data.type);
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
	if(!intro_dialog && !pokemon_death && !enemy_death): close_dialog_and_show_menu(0);
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

func start_attack(delay = 0.0, sound = true) -> void:
	await GLOBAL.timeout(delay);
	attack_pressed = true;
	var priority = pokemon.data.battle_stats.SPD >= enemy.data.battle_stats.SPD;
	if((priority && !player_attacked) || enemy_attacked):
		#PLAYER ATTACKING
		player_attacked = true;
		var move = player_moves[selected_attack];
		if(pokemon.attack(enemy, move)):
			if(enemy.data.current_hp <= 0): enemy_death = true;
			handle_attack(pokemon, move, false, sound);
	elif(!enemy_attacked || player_attacked):
		#ENEMY ATTACKING
		enemy_attacked = true;
		var move = enemy_moves[0];
		if(enemy.attack(pokemon, move)): 
			if(pokemon.data.current_hp <= 0): pokemon_death = true;
			handle_attack(enemy, move, true, sound);
	#CHECK IF DEATH
	if(pokemon_death || enemy_death): return;
	#ATTACK AGAIN
	if((!enemy_attacked || !player_attacked)):
		await BATTLE.attack_finished;
		start_attack(0.8, false);
		return;
	enemy_attacked = false;
	player_attacked = false;
	
func handle_attack(
	target: Object, 
	move: Dictionary,
	is_enemy: bool,
	sound = true
) -> void:
	current_state = BATTLE.States.ATTACKING;
	battle_anim_player.stop();
	if(sound): play_audio(CONFIRM);
	start_attack_dialog([target.name + " use " + move.name.to_upper() + "."]);
	await BATTLE.dialog_finished;
	add_animation_and_play(move, is_enemy);
	attack_pressed = false;
	update_attack_ui();
	await BATTLE.ui_updated;
	check_battle_state();

#UPDATES
func update_battle_ui(is_enemy) -> void:
	var tween = get_tree().create_tween();
	var target = get_attack_target(is_enemy);
	var new_size = max(0, float(target["current_hp"]) / float(target["total_hp"]));
	tween.tween_property(target.bar, "scale:x", new_size, .3);
	if(new_size <= 0.74 && new_size > 0.28): 
		target.bar.texture = YELLOW_BAR;
	elif(new_size <= 0.28): target.bar.texture = RED_BAR;
	if(is_enemy): update_player_health();
	BATTLE.ui_updated.emit();

func update_attack_ui() -> void:
	var current_attack = player_moves[selected_attack];
	var type_node = attack_selection_info.get_node("Type");
	var pp_node = attack_selection_info.get_node("PP/Value");
	type_node.text = MOVES.TypesString[int(current_attack.type + 1)];
	pp_node.text = str(current_attack.pp) + "/" + str(current_attack.total_pp);

func handle_death(state: Dictionary) -> void:
	can_use_menu = false;
	battle_anim_player.stop();
	await GLOBAL.timeout(.3);
	battle_anim_player.play(state.anim);
	await GLOBAL.timeout(0.9);
	start_dialog(state.dialog);
	await BATTLE.dialog_finished;
	
	if("exp" in state):
		pokemon.data.total_exp += state.exp;
		update_exp_bar();

	await GLOBAL.timeout(1);
	end_battle(false);
	
func update_exp_bar():
	var new_size = int(base_exp_level != pokemon.data.total_exp);
	var diff = pokemon.data.total_exp - base_exp_level;
	if(new_size != 0): new_size = 1 / (exp_to_next_level / diff);
	var tween = get_tree().create_tween();
	tween.tween_property(exp_bar, "scale:x", clampf(new_size, 0.0, 1.0), 0.8);
	await tween.finished;

#MOVE ANIMATION
func add_animation_and_play(move: Dictionary, is_enemy: bool) -> void:
	var list = MovesAnimations.new();
	var animation = list.get_move_animation(move.name.to_lower());
	call_deferred("add_child", animation);
	if(!is_enemy): animation.set_data_and_attack(player_sprite, false);
	else: animation.set_data_and_attack(enemy_sprite, true);
	await BATTLE.attack_finished;
	animation.call_deferred("queue_free");

#ATTACK DIALOG
func start_attack_dialog(input_arr: Array) -> void:
	current_state = BATTLE.States.NONE;
	attack_selection.visible = false;
	dialog.visible = true;
	dialog_array = input_arr.duplicate();
	dialog_timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await dialog_timer.timeout;
			current_dialog_text += input_arr[i][j];
			dialog_label.text = current_dialog_text;
	
	await GLOBAL.timeout(.7);
	current_dialog_text = "";
	dialog_label.text = "";
	BATTLE.dialog_finished.emit();
	after_attacking();

func after_attacking() -> void:
	await BATTLE.attack_finished;
	await GLOBAL.timeout(.2);
	if(enemy_death || player_attacked || enemy_attacked || pokemon_death): return;
	dialog.visible = false;
	current_state = BATTLE.States.MENU;

func _on_move_hit(is_enemy: bool) -> void:
	update_battle_ui(is_enemy);
	if(!is_enemy): battle_anim_player.play("DamageEnemy");
	else: battle_anim_player.play("DamagePlayer")
	await battle_anim_player.animation_finished;
	battle_anim_player.play("Idle");

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

func check_battle_state() -> void:
	await BATTLE.attack_finished;
	var state: Dictionary;
	if(enemy_death):
		var exp = EXP.get_exp_given_by_pokemon(enemy, battle_data.type);
		state = {
			"anim": "EnemyFaint",
			"dialog": [
				enemy.data.name + " fainted!\n", 
				pokemon.data.name + " gained " + str(exp) + " EXP."
			],
			"exp": exp
		}
		handle_death(state);
	elif(pokemon_death):
		state = {
			"anim": "PlayerFaint",
			"dialog": [pokemon.data.name + " fainted!"]
		}
		handle_death(state);

func get_attack_target(is_enemy: bool) -> Dictionary:
	var target: Dictionary;
	if(is_enemy): target = {
		"current_hp": pokemon.data.current_hp,
		"total_hp": pokemon.data.battle_stats["HP"],
		"bar": player_hp_bar
	}
	else: target = {
		"current_hp": enemy.data.current_hp,
		"total_hp": enemy.data.battle_stats["HP"],
		"bar": enemy_hp_bar
	}
	return target;

func connect_signals() -> void: BATTLE.connect("on_move_hit", _on_move_hit);
