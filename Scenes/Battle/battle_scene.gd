extends Node

enum Moves { FIRST, SECOND, THIRD, FOURTH }

enum Turn { PLAYER, ENEMY, NONE }

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const BATTLE_FLEE = preload("res://Assets/Sounds/Battle flee.ogg");
const MovesAnimations = preload("res://Scenes/Battle/Moves/moves_animations.gd");
const EXP_GAIN_PKM = preload("res://Assets/Sounds/exp_gain_pkm.mp3");
const EXP_FULL = preload("res://Assets/Sounds/exp_full.mp3");

#PLAYER
@onready var player_info = $Info/PlayerInfo;
@onready var attack_cursor = $Selection/AttackCursor;
@onready var player_sprite = $UI/PlayerSprite;
@onready var audio_player = $UI/PlayerSprite/AudioStreamPlayer;
@onready var player_ground = $Ground/PlayerGround;
@onready var player_hp_bar = $Info/PlayerInfo/PlayerHPBar;
@onready var exp_bar = $Info/PlayerInfo/ExpBar;
@onready var health_timer = $Info/PlayerInfo/HealthTimer;
@onready var info_background: Sprite2D = $Info/PlayerInfo/Background
@onready var level_up_panel: NinePatchRect = $UI/NinePatchRect;
@onready var level_up_timer: Timer = $Dialog/LevelUpTimer

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

var dialog_pressed = false;
var dialog_array: Array
var dialog_line: int
var current_dialog_text: String = "";
var intro_dialog = true;

var menu_cursor_index = Vector2.ZERO;
var attack_cursor_index = Vector2.ZERO;
var player_moves = [];
var enemy_moves = [];

var pokemon_death = false;
var enemy_death = false;

var exp_to_next_level = 0;
var base_exp_level = 0;
var base_exp_to_next_level = 0;
var health_bar_anim_duration = BATTLE.min_hp_anim_duration;

var current_turn = Turn.NONE;
var player_attacked = false;
var enemy_attacked = false;

var health_bar_ellapsed_time = 0.0;
var health_before_attack = 0.0;
var diff_stats: Dictionary;

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
		GLOBAL.menu_open ||
		dialog_pressed
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
		BATTLE.States.LEVELLING: levelling_input(event);

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
	update_battle_ui(false, true);

#PLAYER UI
func set_player_ui() -> void:
	pokemon = PARTY.get_active_pokemon();
	var name_node = player_info.get_node("Name");
	name_node.text = pokemon.data.name;
	var player_dist = name_node.get_content_width() + name_node.position.x + 6;
	
	player_sprite.texture = pokemon.data.back_texture;
	player_info.get_node("Gender").frame = pokemon.data.gender;
	player_info.get_node("Level").text = "Lv" + str(pokemon.data.level);
	player_info.get_node("Gender").position.x = player_dist;
	player_moves = pokemon.data.battle_moves;
	
	set_pokemon_exp();
	var size = get_new_exp_bar_size();;
	exp_bar.scale.x = size;
	update_player_health();
	
	for i in range(len(player_moves)):
		var move = player_moves[i];
		player_attacks[i].visible = true;
		player_attacks[i].text = move.name.to_upper();

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
		elif(current_state != BATTLE.States.LEVELLING): end_dialog();

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
	dialog_pressed = (enemy_death || pokemon_death);
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
		current_turn = Turn.PLAYER;
		player_attacked = true;
		var move = player_moves[selected_attack];
		health_before_attack = enemy.data.current_hp;
		if(pokemon.attack(enemy, move).ok):
			if(enemy.data.current_hp <= 0): enemy_death = true;
			handle_attack(pokemon, move, sound);
	elif(!enemy_attacked || player_attacked):
		#ENEMY ATTACKING
		current_turn = Turn.ENEMY;
		enemy_attacked = true;
		var move = enemy_moves[0];
		health_before_attack = pokemon.data.current_hp;
		if(enemy.attack(pokemon, move).ok): 
			if(pokemon.data.current_hp <= 0): pokemon_death = true;
			handle_attack(enemy, move, sound);
	#CHECK IF DEATH
	if(pokemon_death || enemy_death): return;
	#ATTACK AGAIN
	if((!enemy_attacked || !player_attacked)):
		await BATTLE.attack_finished;
		start_attack(health_bar_anim_duration + 0.2, false);
		return;
	player_attacked = false;
	enemy_attacked = false;

func handle_attack(target: Object, move: Dictionary, sound = true) -> void:
	current_state = BATTLE.States.ATTACKING;
	battle_anim_player.stop();
	if(sound): play_audio(CONFIRM);
	start_attack_dialog([target.name + " use " + move.name.to_upper() + "."]);
	await BATTLE.dialog_finished;
	add_animation_and_play(move);
	attack_pressed = false;
	update_attack_ui();
	check_battle_state();

#LEVELLING INPUT
func levelling_input(event: InputEvent) -> void:
	if(dialog_pressed): return;
	if event.is_action_pressed("space"):
		dialog_pressed = true;
		play_audio(CONFIRM);
		await audio.finished;
		if(BATTLE.level_up_panel_visible):
			if(BATTLE.can_close_level_up_panel): close_level_up_panel();
			else: show_total_stats_panel();
			return;
		show_level_up_panel();

#UPDATES
func update_battle_ui(animated = true, get_self = false) -> void:
	player_info.get_node("Level").text = "Lv" + str(pokemon.data.level);
	var target = get_attack_target(get_self);
	var new_size = max(0, float(target["current_hp"]) / float(target["total_hp"]));
	
	if(animated):
		var tween = get_tree().create_tween();
		tween.tween_property(target.bar, "scale:x", new_size, health_bar_anim_duration);
		start_health_timer();
		var await_time = 0;
		if(health_bar_anim_duration > 1.0): await_time = 0.2;
		await tween.finished;
		await GLOBAL.timeout(await_time);
		stop_health_timer();
	else: target.bar.scale.x = new_size;
		
	BATTLE.ui_updated.emit();

func update_attack_ui() -> void:
	var current_attack = player_moves[selected_attack];
	var type_node = attack_selection_info.get_node("Type");
	var pp_node = attack_selection_info.get_node("PP/Value");
	type_node.text = MOVES.TypesString[int(current_attack.type + 1)];
	pp_node.text = str(current_attack.pp) + "/" + str(current_attack.total_pp);

#HEALTH BAR
func update_player_health(value = pokemon.data.current_hp) -> void: #LEFT ALIGNED
	var health = str(pokemon.data.battle_stats["HP"]) + " / " + str(value);
	player_info.get_node("HP").text = health;

func update_exp_bar(delay = 0.0) -> void:
	await GLOBAL.timeout(delay);
	var new_size = get_new_exp_bar_size();
	var tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_SINE);
	tween.tween_property(exp_bar, "scale:x", clampf(new_size, 0.0, 1.0), 1.3);
	play_audio(EXP_GAIN_PKM);
	await tween.finished;
	while(exp_to_next_level <= 0.0): 
		level_up_animation();
		await tween.finished;
	BATTLE.experience_end.emit();

func level_up_animation() -> void:
	diff_stats = pokemon.level_up();
	play_audio(EXP_FULL);
	set_pokemon_exp();
	exp_bar.scale.x = 0;
	battle_anim_player.play("LevelUp");
	await battle_anim_player.animation_finished;
	update_battle_ui(false, true);
	update_player_health();
	start_level_up_dialog([pokemon.data.name + " grew to Level " + str(pokemon.data.level) + "!"]);
	await BATTLE.level_up_stats_end;
	dialog_label.text = "";
	update_exp_bar(0.5);
	level_up_timer.stop();

#LEVEL UP STATS
func show_level_up_panel() -> void:
	level_up_panel.show_panel(pokemon.data.battle_stats, diff_stats);
	dialog_marker.visible = true;
	BATTLE.level_up_panel_visible = true;
	BATTLE.can_close_level_up_panel = false;
	dialog_pressed = false;

func show_total_stats_panel() -> void:
	level_up_panel.show_total_stats();
	dialog_pressed = false;

func close_level_up_panel() -> void:
	level_up_panel.close();
	dialog_marker.visible = false;
	current_state = BATTLE.States.NONE;

#DEATH
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
		exp_to_next_level -= state.exp;
		update_exp_bar();
		await BATTLE.experience_end;
	
	await GLOBAL.timeout(.9);
	end_battle(false);

#MOVE ANIMATION
func add_animation_and_play(move: Dictionary) -> void:
	var move_list = MovesAnimations.new();
	var animation = move_list.get_move_animation(move.name.to_lower());
	call_deferred("add_child", animation);
	if(current_turn == Turn.PLAYER): animation.play_attack(player_sprite, current_turn);
	elif(current_turn == Turn.ENEMY): animation.play_attack(enemy_sprite, current_turn);
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
	after_dialog_attack();
	
#LEVEL UP DIALOG
func start_level_up_dialog(input_arr: Array) -> void:
	current_state = BATTLE.States.LEVELLING;
	current_dialog_text = "";
	level_up_timer.start();
	
	for i in range(1):
		for j in range(len(input_arr[i])):
			await level_up_timer.timeout;
			current_dialog_text += input_arr[i][j];
			dialog_label.text = current_dialog_text;
	
	dialog_marker.visible = true;
	await GLOBAL.timeout(0.2);
	dialog_pressed = false;

#LISTENERS
func _on_move_hit() -> void:
	update_battle_ui();
	if(current_turn == Turn.PLAYER): battle_anim_player.play("DamageEnemy");
	else: battle_anim_player.play("DamagePlayer")
	await battle_anim_player.animation_finished;
	battle_anim_player.play("Idle");

func after_dialog_attack() -> void:
	await BATTLE.ui_updated;
	await GLOBAL.timeout(.2);
	if(enemy_death || pokemon_death || player_attacked || enemy_attacked): return;
	dialog.visible = false;
	current_state = BATTLE.States.MENU;

func _on_health_timer_timeout() -> void:
	var progress = health_bar_ellapsed_time / health_bar_anim_duration;
	if (health_bar_ellapsed_time < health_bar_anim_duration):
		var target_hp = int(pokemon.data.current_hp);
		if(current_turn == Turn.PLAYER): target_hp = int(enemy.data.current_hp);
		var current_hp = lerp(int(health_before_attack), target_hp, progress);
		set_health_color_while_timer(floor(current_hp));
		health_bar_ellapsed_time += health_timer.wait_time;
	else: stop_health_timer();

#CHECKERS
func check_battle_state() -> void:
	await BATTLE.ui_updated;
	var state: Dictionary;
	if(enemy_death):
		var poke_exp = EXP.get_exp_given_by_pokemon(enemy, battle_data.type);
		state = {
			"anim": "EnemyFaint",
			"dialog": [
				enemy.data.name + " fainted!\n", 
				pokemon.data.name + " gained " + str(poke_exp) + " EXP."
			],
			"exp": poke_exp
		}
		handle_death(state);
	elif(pokemon_death):
		state = {
			"anim": "PlayerFaint",
			"dialog": [pokemon.data.name + " fainted!"]
		}
		handle_death(state);

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

#TIMER
func start_health_timer() -> void:
	health_timer.wait_time = health_bar_anim_duration / health_before_attack;
	health_timer.start();

func stop_health_timer() -> void:
	health_timer.stop();
	health_bar_ellapsed_time = 0.0;

#GETTERS
func get_new_exp_bar_size() -> float:
	return float(
		pokemon.data.total_exp - base_exp_level
	) / float(
		base_exp_to_next_level - base_exp_level
	)

func get_attack_target(get_self = false) -> Dictionary:
	var target: Dictionary;
	if(current_turn == Turn.ENEMY || get_self): target = {
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

#SETTERS
func set_pokemon_exp() -> void:
	base_exp_level = pokemon.get_exp_by_level();
	base_exp_to_next_level = EXP.get_exp_by_level(pokemon.data.exp_type, pokemon.data.level + 1);
	exp_to_next_level = base_exp_to_next_level - pokemon.data.total_exp;

func _set_animation_health_bar_duration(duration: float) -> void:
	health_bar_anim_duration = duration;

func set_health_color_while_timer(value: float) -> void:
	var target = get_attack_target();
	if(current_turn == Turn.ENEMY): update_player_health(int(value));
	var perct = value / float(target.total_hp);
	if(perct < BATTLE.GREEN_BAR_PERCT && perct > BATTLE.YELLOW_BAR_PERCT): 
		target.bar.texture = YELLOW_BAR;
	elif(perct < BATTLE.YELLOW_BAR_PERCT): target.bar.texture = RED_BAR;

func set_attack_slot() -> void:
	if(attack_cursor_index == Vector2.ZERO): selected_attack = Moves.FIRST;
	elif(attack_cursor_index == Vector2.RIGHT): selected_attack = Moves.SECOND;
	elif(attack_cursor_index == Vector2.DOWN): selected_attack = Moves.THIRD;
	elif(attack_cursor_index == Vector2(1, 1)): selected_attack = Moves.FOURTH;

#AUDIO
func play_shout_pokemon() -> void:
	audio_player.stream = pokemon.data.shout;
	audio_player.play();

func play_move_and_shout_enemy() -> void:
	enemy_anim_player.play("Move");
	await GLOBAL.timeout(.2);
	play_enemy_shout();

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func play_enemy_shout() -> void: play_audio(enemy.data.shout);

#SIGNALS
func connect_signals() -> void: 
	BATTLE.connect("on_move_hit", _on_move_hit);
	BATTLE.connect("health_bar_animation_duration", _set_animation_health_bar_duration);
	health_timer.connect("timeout", _on_health_timer_timeout);
