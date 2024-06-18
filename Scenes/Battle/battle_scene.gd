extends Node

#PLAYER
@onready var player_info = $Info/PlayerInfo;
@onready var player_sprite = $UI/PlayerSprite;
@onready var audio_player = $UI/PlayerSprite/AudioPlayer;
@onready var player_ground = $Ground/PlayerGround;
@onready var player_hp_bar = $Info/PlayerInfo/PlayerHPBar;
@onready var exp_bar = $Info/PlayerInfo/ExpBar;
@onready var health_timer = $Info/PlayerInfo/HealthTimer;
@onready var info_background: Sprite2D = $Info/PlayerInfo/Background;
@onready var level_up_panel: NinePatchRect = $UI/NinePatchRect;
@onready var level_up_timer: Timer = $Dialog/LevelUpTimer;

#ENEMY
@onready var enemy_info = $Info/EnemyInfo;
@onready var enemy_sprite = $UI/EnemySprite;
@onready var enemy_hp_bar = $Info/EnemyInfo/EnemyHPBar;
@onready var enemy_ground = $Ground/EnemyGround;

#BATTLE
@onready var bag = $Bag;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioPlayer;
@onready var battle_anim_player = $BattleAnimationPlayer;
@onready var battle_background = $Background;
@onready var attack_background = $Selection/Background;
@onready var menu_selection: NinePatchRect = $MenuSelection;
@onready var menu: Node2D = $Menu
@onready var dialog: Node2D = $Dialog;
@onready var selection: Node2D = $Selection;

const MovesAnimations = preload("res://Scenes/Battle/Moves/moves_animations.gd");
const SECOND_ATTACK_DELAY = 0.2;
const TURN_FINISH_DELAY = 0.2;
var HP_ANIM_DURATION = BATTLE.MIN_HP_ANIM;
const PLAYER_DIST_MARGIN = 6;
const DIALOG_TIME_WHEN_MISSED = 1.5;
var HP_ELLAPSED = 0.0;

var pokemon: Object;
var enemy: Object;
var battle_data: Dictionary;
var exp_to_next_level = 0;
var base_exp_level = 0;
var base_exp_to_next_level = 0;
var health_before_attack = 0.0;
var diff_stats: Dictionary;
var current_damage: int;

func _ready():
	BATTLE.reset_state();
	connect_signals();
	set_battle_ui();
	BATTLE.type = battle_data.type;
	match(battle_data.type):
		ENUMS.BattleType.WILD: battle_wild();

func _unhandled_input(event: InputEvent) -> void:
	if(  
		!event is InputEventKey || 
		BATTLE.state == ENUMS.BattleStates.ATTACKING ||
		event.is_echo() ||
		!event.is_pressed() ||
		GLOBAL.menu_open ||
		dialog.pressed ||
		!GLOBAL.on_battle
	): return;
	match BATTLE.state:
		ENUMS.BattleStates.MENU: menu.input();
		ENUMS.BattleStates.FIGHT: selection.input();
		#States.BAG: #bag_input(event)
		ENUMS.BattleStates.DIALOG: dialog.input();
		ENUMS.BattleStates.LEVELLING: dialog.levelling_input();
		ENUMS.BattleStates.ESCAPING: dialog.escape_input();

func battle_wild() -> void:
	anim_player.play("Start");
	await BATTLE.dialog_finished;
	anim_player.play("Go");

func start_battle_dialog() -> void:
	dialog.start([
		"A wild " + enemy.data.name + " appeared!\n", 
		"Go " + pokemon.data.name + "!"]);

#INTRO
func check_intro_dialog() -> void:
	close_dialog_and_show_menu(.2);
	menu.set_label("Ready! What will be your next move?");
	BATTLE.intro_dialog = false;

#UI
func set_battle_ui() -> void:
	set_pokemon();
	set_player_ui();
	set_enemy_ui();
	set_battle_texture();
	set_markers();
	update_battle_ui(false, true);

#ATTACK
func start_attack(delay = 0.0, sound = true) -> void:
	await GLOBAL.timeout(delay);
	BATTLE.attack_pressed = true;
	var priority = determine_priority();
	if((priority && !BATTLE.player_attacked) || BATTLE.enemy_attacked): 
		pokemon_attack(sound);
	else: enemy_attack(sound);
	if(any_death()): return;
	#ATTACK AGAIN
	if(!all_attacked()):
		await BATTLE.attack_finished;
		delay = HP_ANIM_DURATION + 0.3;
		#SECOND ATTACK
		if(need_to_check_attack()):
			await BATTLE.attack_check_done;
			delay = SECOND_ATTACK_DELAY;
		start_attack(delay, false);
		return;
	await GLOBAL.timeout(delay);
	
	#CHECK RESULT
	if(ENUMS.AttackResult.NORMAL not in BATTLE.attack_result):
		await BATTLE.attack_check_done;
	
	#TURN FINISHED
	await GLOBAL.timeout(0.2);
	reset_attack_state();

func determine_priority() -> bool:
	var priority = pokemon.data.battle_stats.SPD >= enemy.data.battle_stats.SPD
		
	if (!BATTLE.attacks_set):
		BATTLE.player_attack = selection.get_player_attack();
		BATTLE.enemy_attack = selection.get_enemy_random_attack();
		BATTLE.attacks_set = true;
		
	if (BATTLE.enemy_attack.priority > BATTLE.player_attack.priority):
		priority = false;
	elif (BATTLE.player_attack.priority > BATTLE.enemy_attack.priority):
		priority = true;
	return priority;

func reset_attack_state() -> void:
	BATTLE.player_attacked = false;
	BATTLE.enemy_attacked = false;
	BATTLE.attacks_set = false;
	battle_anim_player.play("Idle");

func pokemon_attack(sound = true) -> void:
	perform_attack(
		pokemon,
		enemy,
		BATTLE.player_attack,
		BATTLE.Turn.PLAYER,
		"player_attacked",
		"enemy_death",
		sound
	)

func enemy_attack(sound = true) -> void:
	perform_attack(
		enemy,
		pokemon,
		BATTLE.enemy_attack,
		BATTLE.Turn.ENEMY,
		"enemy_attacked",
		"pokemon_death",
		sound
	)

func perform_attack(
	attacker: Object, 
	defender: Object, 
	attack: Dictionary, 
	turn: BATTLE.Turn, 
	attacked_flag: String, 
	death_flag: String, 
	sound: bool
) -> void:
	BATTLE.current_turn = turn;
	BATTLE[attacked_flag] = true;
	health_before_attack = defender.data.current_hp;
	if attacker.attack(defender, attack).ok:
		if defender.data.death:
			BATTLE[death_flag] = true;
		handle_attack(attacker, attack, sound);

func handle_attack(target: Object, move: Dictionary, sound = true) -> void:
	BATTLE.state = ENUMS.BattleStates.ATTACKING;
	battle_anim_player.stop();
	if(sound): play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var target_name = target.name + " use ";
	if(BATTLE.current_turn == BATTLE.Turn.ENEMY):
		target_name = "Wild " + target_name;
	dialog.attack([target_name + move.name.to_upper() + "."]);
	await BATTLE.dialog_finished;
	add_animation_and_play(move);
	BATTLE.attack_pressed = false;
	selection.update_attack_ui();
	check_battle_state();

func fake_attack() -> void:
	BATTLE.player_attacked = true;
	BATTLE.enemy_attacked = false;
	start_attack(0.2, false);

#UPDATES
func update_battle_ui(
	animated = true,
	get_self = false,
	check_dialog = false
) -> void:
	player_info.get_node("Level").text = "Lv" + str(pokemon.data.level);
	var target = get_attack_target(get_self);
	var new_size = float(target["current_hp"]) / float(target["total_hp"]);
	
	if(animated): await animate_hp_bar(target, new_size);
	else: target.bar.scale.x = new_size;
	dialog.set_label("");
	BATTLE.ui_updated.emit();
	if(check_dialog): after_dialog_attack();

func animate_hp_bar(target: Dictionary, new_size: float) -> void:
	var tween = get_tree().create_tween();
	tween.tween_property(target.bar, "scale:x", new_size, HP_ANIM_DURATION);
	current_damage = int(max(0, int(health_before_attack) - int(target["current_hp"])));
	start_health_timer();
	await tween.finished;

#HEALTH BAR - LEFT ALIGNED
func update_player_health(value = pokemon.data.current_hp) -> void:
	var health = str(pokemon.data.battle_stats["HP"]) + " / " + str(value);
	player_info.get_node("HP").text = health;

func update_exp_bar(delay = 0.0) -> void:
	await GLOBAL.timeout(delay);
	var new_size = get_new_exp_bar_size();
	var tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_LINEAR);
	tween.tween_property(
		exp_bar, "scale:x",
		clampf(new_size, 0.0, 1.0),
		BATTLE.EXP_DURATION
	);
	play_audio(LIBRARIES.SOUNDS.EXP_GAIN_PKM);
	await tween.finished;
	while(exp_to_next_level <= 0.0): 
		level_up_animation();
		await tween.finished;
	BATTLE.experience_end.emit();

func level_up_animation() -> void:
	diff_stats = pokemon.level_up();
	play_audio(LIBRARIES.SOUNDS.EXP_FULL);
	set_exp(pokemon);
	exp_bar.scale.x = 0;
	battle_anim_player.play("LevelUp");
	await battle_anim_player.animation_finished;
	update_battle_ui(false, true);
	update_player_health();
	await create_level_up_dialog();
	await check_new_moves();
	update_exp_bar(0.5);
	level_up_timer.stop();

func create_level_up_dialog() -> void:
	var grew = pokemon.data.name + " grew to Level ";
	dialog.level_up([grew + str(pokemon.data.level) + "!"], pokemon);
	await BATTLE.level_up_stats_end;
	dialog.set_label("");

func check_new_moves() -> void:
	var new_level = int(pokemon.data.level);
	if(new_level in pokemon.data.move_set.keys()):
		check_learn_move(pokemon, new_level);
		await BATTLE.dialog_finished;

#LEVEL UP STATS
func show_level_up_panel(participant: Object) -> void:
	level_up_panel.show_panel(participant.data.battle_stats, diff_stats);
	BATTLE.level_up_panel_visible = true;
	BATTLE.can_close_level_up_panel = false;

func close_level_up_panel() -> void:
	level_up_panel.close();
	BATTLE.state = ENUMS.BattleStates.NONE;

#DEATH
func handle_death(state: Dictionary) -> void:
	BATTLE.can_use_menu = false;
	battle_anim_player.stop();
	await GLOBAL.timeout(.2);
	battle_anim_player.play(state.anim);
	await battle_anim_player.animation_finished;
	dialog.start(state.dialog);
	await BATTLE.dialog_finished;
	#ENEMY DEATH - EXP
	if("exp" in state):
		await give_exp(state);
		#PARTICIPANTS EXP
		if(BATTLE.participants.size() > 1):
			BATTLE.exp_loop = true;
			await GLOBAL.timeout(0.2);
			give_exp_to_participants(state);
			await BATTLE.participant_exp_end;
		end_battle();
	#PLAYER DEATH
	else: check_for_next_pokemon();

func give_exp(state: Dictionary) -> void:
	pokemon.data.total_exp += state.exp;
	exp_to_next_level -= state.exp;
	update_exp_bar();
	await BATTLE.experience_end;
	await GLOBAL.timeout(0.6);
	dialog.reset_text();
	enemy.free();

#MOVE ANIMATION
func add_animation_and_play(move: Dictionary) -> void:
	var move_list = MovesAnimations.new();
	var animation = move_list.get_move_animation(move.name.to_lower());
	#MISSED
	if(
		ENUMS.AttackResult.MISS in BATTLE.attack_result && 
		ENUMS.AttackResult.NONE not in BATTLE.attack_result
	): await handle_missed_attack();
	else: await handle_success_attack(animation);

func handle_success_attack(animation: Node2D) -> void:
	call_deferred("add_child", animation);
	if(BATTLE.current_turn == BATTLE.Turn.PLAYER): 
		animation.play_attack(player_sprite);
	elif(BATTLE.current_turn == BATTLE.Turn.ENEMY): 
		animation.play_attack(enemy_sprite);
	await BATTLE.attack_finished;
	animation.call_deferred("queue_free");

func handle_missed_attack() -> void:
	var target = pokemon;
	if(BATTLE.current_turn == BATTLE.Turn.ENEMY): target = enemy;
	dialog.show_missed(target.name, DIALOG_TIME_WHEN_MISSED);
	await BATTLE.quick_dialog_end;
	BATTLE.attack_finished.emit();
	update_battle_ui(false, false, true);

#LISTENERS
func _on_move_hit() -> void:
	if(ENUMS.AttackResult.NONE not in BATTLE.attack_result):
		if(BATTLE.current_turn == BATTLE.Turn.PLAYER): 
			battle_anim_player.play("DamageEnemy");
		else: battle_anim_player.play("DamagePlayer")
		await battle_anim_player.animation_finished;
	update_battle_ui(true, false, true);

func after_dialog_attack() -> void:
	await GLOBAL.timeout(.2);
	if(need_to_check_attack()):
		await BATTLE.attack_check_done;
		await GLOBAL.timeout(0.2);
	if(any_death() || any_attacked()): return;
	dialog.visible = false;
	await GLOBAL.timeout(.2);
	BATTLE.state = ENUMS.BattleStates.MENU;

#MENU SELECTION
func _on_selection_value_select(
	value: int,
	id: ENUMS.SelectionCategory
) -> void:
	if(id != ENUMS.SelectionCategory.BINARY): return;
	dialog.set_current_text("");
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	match value:
		int(ENUMS.BinaryOptions.YES): 
			menu.open_party();
			await GLOBAL.timeout(1);
			player_info.visible = false;
		int(ENUMS.BinaryOptions.NO): _on_check_can_escape();

#CHECKERS
func check_battle_state() -> void:
	await BATTLE.ui_updated;
	#NON EFFECTIVE
	if(ENUMS.AttackResult.NONE in BATTLE.attack_result):
		dialog.show_non_effective(DIALOG_TIME_WHEN_MISSED);
		await BATTLE.quick_dialog_end;
		BATTLE.attack_check_done.emit();
		return;
	#MISS
	if(ENUMS.AttackResult.MISS in BATTLE.attack_result):
		BATTLE.attack_check_done.emit();
		return;
	#CRITICAL HIT
	if(ENUMS.AttackResult.CRITICAL in BATTLE.attack_result):
		dialog.show_critical();
		await BATTLE.quick_dialog_end;
	#EFFECTIVENESS
	dialog.check_effective_dialog();
	await BATTLE.quick_dialog_end;
	await GLOBAL.timeout(0.1);
	BATTLE.attack_check_done.emit();
	if(any_death()): check_death_after_attack();

#CHECK DEATH
func check_death_after_attack() -> void:
	var state: Dictionary;
	if(enemy.data.death):
		var poke_exp = EXP.get_exp_given_by_pokemon(
			enemy, battle_data.type, BATTLE.participants.size());
		state = {
			"anim": "EnemyFaint",
			"dialog": [
				enemy.data.name + " fainted!\n", 
				pokemon.data.name + " gained " + str(poke_exp) + " EXP."
			],
			"exp": poke_exp
		}
	elif(BATTLE.pokemon_death):
		state = {
			"anim": "PlayerFaint",
			"dialog": [pokemon.data.name + " fainted!"]
		}
	handle_death(state);

func check_learn_move(poke: Object, new_level: int) -> void:
	var new_move_index = float(poke.data.move_set[new_level]);
	if(new_move_index in poke.data.moves):
		await GLOBAL.timeout(0.2);
		BATTLE.dialog_finished.emit();
		return;
	var new_move = MOVES.get_move(new_move_index);
	poke.learn_move(new_move.id);
	await GLOBAL.timeout(0.1);
	dialog.set_current_text("");
	play_audio(LIBRARIES.SOUNDS.MOVE_LEARN);
	dialog.start([poke.name + " learned " + new_move.name.to_upper() + "!"]);

# CHECK NEXT
func check_for_next_pokemon() -> void:
	BATTLE.remove_participant(pokemon);
	var next = PARTY.get_next_pokemon();
	if(next != null): await handle_can_use_pokemon()
	else: await handle_no_pokemon_left()

func handle_can_use_pokemon() -> void:
	BATTLE.can_use_next_pokemon = true;
	await GLOBAL.timeout(0.2);
	dialog.next_pokemon(["Use next POKéMON?"]);
	await BATTLE.dialog_finished;
	await GLOBAL.timeout(0.1);
	menu_selection.set_visibility(true);
	
func handle_no_pokemon_left() -> void:
	await GLOBAL.timeout(0.8);
	dialog.start(["No POKéMON left!\n", "You returned to the last safe spot..."]);
	await BATTLE.dialog_finished;
	end_battle();

#PARTY
func _on_party_pokemon_select(_poke_name: String) -> void:
	selection.reset();
	if(BATTLE.can_use_next_pokemon): reset_state_and_get_next_pokemon();
	else: switch_pokemon();

func reset_state_and_get_next_pokemon() -> void:
	player_info.visible = false;
	BATTLE.reset_state(false);
	await GLOBAL.timeout(0.2);
	set_pokemon();
	set_player_ui();
	update_battle_ui(false, true);
	anim_player.play("In");
	dialog.start(["It's your turn now!\n", "Go " + pokemon.data.name + "!"]);
	await BATTLE.dialog_finished;
	await start_switch_animation();

func start_switch_animation() -> void:
	anim_player.play("Go");
	await anim_player.animation_finished;
	battle_anim_player.play("Idle");
	BATTLE.state = ENUMS.BattleStates.MENU;
	dialog.set_current_text("");

func switch_pokemon() -> void:
	battle_anim_player.stop();
	dialog.visible = true;
	await GLOBAL.timeout(.2);
	dialog.switch([pokemon.name + " that's enough!"]);
	await BATTLE.dialog_finished;
	selection.reset();
	anim_player.play("Switch");
	await anim_player.animation_finished;
	fake_attack();
	await BATTLE.attack_finished;
	battle_anim_player.play("Idle");
	BATTLE.can_use_menu = true;

#ESCAPE
func _on_check_can_escape() -> void:
	if(!BATTLE.can_use_next_pokemon): battle_anim_player.stop();
	if(BATTLE.can_pokemon_scape(pokemon, enemy)): handle_scape();
	else:
		dialog.escape(["Can't escape!"]);
		await BATTLE.dialog_finished;
		if(BATTLE.can_use_next_pokemon):
			menu.open_party();
			return;
		fake_attack();
		await BATTLE.attack_finished;
		await GLOBAL.timeout(0.4);
		BATTLE.can_use_menu = true;
		battle_anim_player.play("Idle");

func handle_scape() -> void:
	dialog.escape(["Got away safely!"]);
	await GLOBAL.timeout(0.2);
	play_audio(LIBRARIES.SOUNDS.BATTLE_FLEE);
	await BATTLE.dialog_finished;
	await GLOBAL.timeout(.4);
	end_battle();

#CLOSE BATTLE
func end_battle() -> void:
	BATTLE.can_use_menu = false;
	battle_anim_player.play("FadetoBlack");
	PARTY.reset_all_active(true);

func close_battle() -> void:
	GLOBAL.emit_signal("close_battle");
	AUDIO.stop_battle_and_play_last_song();
	BATTLE.reset_state();

func close_dialog_and_show_menu(time: float) -> void:
	dialog.close(time);
	menu.visible = true;

#TIMER
func start_health_timer() -> void:
	health_timer.wait_time = max((HP_ANIM_DURATION / current_damage) * 0.8, 0.05);
	health_timer.start();

func stop_health_timer() -> void:
	health_timer.stop();
	HP_ELLAPSED = 0.0;
	if(BATTLE.current_turn == BATTLE.Turn.ENEMY):
		update_player_health(pokemon.data.current_hp);

#HEALTH TIMEOUT
func _on_health_timer_timeout() -> void:
	var progress = HP_ELLAPSED / HP_ANIM_DURATION;
	if (HP_ELLAPSED < HP_ANIM_DURATION):
		var target_hp = int(pokemon.data.current_hp);
		if(BATTLE.current_turn == BATTLE.Turn.PLAYER): 
			target_hp = int(enemy.data.current_hp);
		var current_hp = lerp(int(health_before_attack), target_hp, progress);
		set_health_color(floor(current_hp));
		HP_ELLAPSED += health_timer.wait_time;
	else: stop_health_timer();

#GETTERS
func get_new_exp_bar_size() -> float:
	return float(
		pokemon.data.total_exp - base_exp_level
	) / float(base_exp_to_next_level - base_exp_level)

func get_attack_target(get_self = false) -> Dictionary:
	var target: Dictionary;
	if(BATTLE.current_turn == BATTLE.Turn.ENEMY || get_self): 
		target = {
			"current_hp": pokemon.data.current_hp,
			"total_hp": pokemon.data.battle_stats["HP"],
			"bar": player_hp_bar
			}
	else: target = {
		"current_hp": enemy.data.current_hp,
		"total_hp": enemy.data.battle_stats["HP"],
		"bar": enemy_hp_bar}
	return target;

#SETTERS
func set_pokemon() -> void: 
	pokemon = PARTY.get_active_pokemon();
	set_pokemon_health_color(floor(pokemon.data.current_hp));
	BATTLE.add_participant(pokemon);

#PLAYER UI
func set_player_ui() -> void:
	var name_node = player_info.get_node("Name");
	var gender_node = player_info.get_node("Gender");
	var level_node = player_info.get_node("Level");
	set_name_and_gender(name_node, gender_node, pokemon.data);
	set_sprites(player_sprite, pokemon.data);
	set_level(level_node, pokemon.data);
	selection.set_pokemon_moves(pokemon.data.battle_moves);
	set_exp(pokemon);
	exp_bar.scale.x = get_new_exp_bar_size();
	player_sprite.play("Back");

#ENEMY UI
func set_enemy_ui() -> void:
	var new_enemy = POKEDEX.get_pokemon(battle_data["enemy"]);
	enemy = Pokemon.new(new_enemy, true, battle_data.levels);
	var enemy_name = enemy_info.get_node("Name");
	var gender_node = enemy_info.get_node("Gender");
	var level_node = enemy_info.get_node("Level");
	set_name_and_gender(enemy_name, gender_node, enemy.data);
	set_sprites(enemy_sprite, enemy.data);
	set_level(level_node, enemy.data);
	selection.set_enemy_moves(enemy.data.moves);
	enemy_sprite.play("Front");

#TEXTURES
func set_battle_texture() -> void:
	var battle_textures = BATTLE.get_battle_textures(battle_data.zone);
	battle_background.texture = battle_textures.background;
	player_ground.texture = battle_textures.player_ground;
	enemy_ground.texture = battle_textures.enemy_ground;

#MARKERS
func set_markers() -> void:
	var markers = LIBRARIES.BATTLE.get_markers(SETTINGS.selected_type);
	attack_background.texture = markers.attack;

func set_name_and_gender(
	name_node: RichTextLabel, 
	gender_node: Sprite2D,
	data: Dictionary
) -> void:
	name_node.text = data.name;
	var width = name_node.get_content_width();
		
	if "gender" in data:
		gender_node.frame = data.gender;
		gender_node.position.x = width + name_node.position.x + PLAYER_DIST_MARGIN;
		gender_node.visible = true;

func set_sprites(sprite: AnimatedSprite2D, data: Dictionary) -> void:
	sprite.sprite_frames = data.sprites.sprite_frames;
	sprite.offset = data.offset;
	sprite.scale = data.scale;

func set_level(info: RichTextLabel, data: Dictionary) -> void:
	info.text = "Lv" + str(data.level);

func set_exp(poke: Object) -> void:
	base_exp_level = poke.get_exp_by_level();
	base_exp_to_next_level = EXP.get_exp_by_level(poke.data.exp_type, poke.data.level + 1);
	exp_to_next_level = base_exp_to_next_level - poke.data.total_exp;

func set_pokemon_health_color(value: float) -> void:
	update_player_health(int(value));
	var perct = value / float(pokemon.data.battle_stats["HP"]);
	check_health_bar_color(perct, player_hp_bar);

func set_health_color(value: float) -> void:
	var target = get_attack_target();
	if(BATTLE.current_turn == BATTLE.Turn.ENEMY): update_player_health(int(value));
	var perct = value / float(target.total_hp);
	check_health_bar_color(perct, target.bar);

func check_health_bar_color(perct: float, health_bar: Sprite2D) -> void:
	if(perct >= BATTLE.GREEN_BAR_PERCT): 
		health_bar.texture = LIBRARIES.IMAGES.GREEN_BAR;
	elif(perct < BATTLE.GREEN_BAR_PERCT && perct > BATTLE.YELLOW_BAR_PERCT): 
		health_bar.texture = LIBRARIES.IMAGES.YELLOW_BAR;
	elif(perct < BATTLE.YELLOW_BAR_PERCT): health_bar.texture = LIBRARIES.IMAGES.RED_BAR;

#PARTICIPANT EXP
func give_exp_to_participants(state: Dictionary) -> void:
	for participant in BATTLE.participants:
		if(participant.name != pokemon.name):
			participant.data.total_exp += state.exp;
			set_exp(participant);
			dialog.start([participant.name + " gained " + str(state.exp) + " EXP."]);
			await BATTLE.dialog_finished;
			await GLOBAL.timeout(0.2);
			while(exp_to_next_level <= 0.0): await level_up_participant(participant)
	BATTLE.participant_exp_end.emit();

func level_up_participant(participant: Object) -> void:
	diff_stats = participant.level_up();
	play_audio(LIBRARIES.SOUNDS.EXP_FULL);
	set_exp(participant);
	await GLOBAL.timeout(0.2);
	var grew = participant.data.name + " grew to Level ";
	dialog.level_up([grew + str(participant.data.level) + "!"], participant);
	await BATTLE.level_up_stats_end;
	dialog.reset_text();
	var new_level = int(participant.data.level);
	if(new_level in participant.data.move_set.keys()):
		check_learn_move(participant, new_level);
		await BATTLE.dialog_finished;

func need_to_check_attack() -> bool:
	var not_normal = ENUMS.AttackResult.NORMAL not in BATTLE.attack_result;
	var not_miss = ENUMS.AttackResult.MISS not in BATTLE.attack_result;
	return not_normal && not_miss;

#AUDIO
func play_shout_pokemon() -> void:
	audio_player.stream = pokemon.data.shout;
	audio_player.play();

func play_shout_enemy() -> void:
	await GLOBAL.timeout(0.2);
	play_audio(enemy.data.shout);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

#UTILS
func show_total_stats_panel() -> void: level_up_panel.show_total_stats();
func go_switch_dialog() -> void: dialog.switch(["Let's go " + pokemon.name + "!"]);
func set_battle_data(data: Dictionary) -> void: battle_data = data;
func _set_anim_hp_bar_duration(duration: float) -> void: HP_ANIM_DURATION = duration;
func any_death() -> bool: return pokemon.data.death || enemy.data.death;
func all_attacked() -> bool: return BATTLE.enemy_attacked && BATTLE.player_attacked;
func any_attacked() -> bool: return BATTLE.enemy_attacked || BATTLE.player_attacked;

#SIGNALS
func connect_signals() -> void:
	BATTLE.connect("on_move_hit", _on_move_hit);
	BATTLE.connect("hp_bar_anim_duration", _set_anim_hp_bar_duration);
	BATTLE.connect("close_level_up_panel", close_level_up_panel);
	BATTLE.connect("show_total_stats_panel", show_total_stats_panel);
	BATTLE.connect("show_level_up_panel", show_level_up_panel);
	BATTLE.connect("check_can_escape", _on_check_can_escape);
	BATTLE.connect("start_attack", start_attack);
	PARTY.connect("selected_pokemon_party", _on_party_pokemon_select);
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
	health_timer.connect("timeout", _on_health_timer_timeout);
