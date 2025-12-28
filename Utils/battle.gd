extends Node

@onready var pokeball_textures = {
	ENUMS.Item.POKEBALL: preload("res://Assets/UI/Battle/Catch/pokeball_catch.png"),
	ENUMS.Item.GREATBALL: preload("res://Assets/UI/Battle/Catch/greatball_catch.png"),
	ENUMS.Item.MASTERBALL: preload("res://Assets/UI/Battle/Catch/masterball_catch.png"),
}

#ATTACK
signal attack_finished();
signal on_move_hit(is_enemy: bool);
signal not_effective();
signal start_attack();
signal attack_check_done();
signal attack_effect_finished(status: ENUMS.PokemonStatus);

#UI
signal ui_updated();
signal update_attack_ui();
signal experience_end();
signal hp_bar_anim_duration(duration: float);
signal trainer_intro_end();

#DIALOG
signal dialog_finished();
signal close_level_up_panel();
signal show_total_stats_panel();
signal show_level_up_panel(participant: Object);
signal level_up_stats_end();
signal check_can_escape();
signal quick_dialog_end();
signal participant_exp_end();

#MENU
signal end_battle();

enum Moves { FIRST, SECOND, THIRD, FOURTH }
enum Turn { PLAYER, ENEMY, NONE }
enum Weather { RAINING, DROUGH, SANDSTORM, NONE }

const tile_density = 325.0;
var modifire = 2;

const MIN_HP_ANIM = 1.2;
const MAX_HP_ANIM = 3;
const GREEN_BAR_PERCT = 0.51;
const YELLOW_BAR_PERCT = 0.2;
const EXP_DURATION = 1.2;

var level_up_panel_visible = false;
var can_close_level_up_panel = false;
var type = ENUMS.BattleType.NONE;
var state = ENUMS.BattleStates.NONE;
var pokemon_death = false;
var enemy_death = false;
var wild_intro = true;
var trainer_intro = true;
var can_use_menu = false;
var escape_attempts = 0;
var on_victory = false;
var attack_pressed = false;
var player_attacked = false;
var enemy_attacked = false;
var current_turn = Turn.NONE;
var can_use_next_pokemon = false;
var coming_from_battle = false;
var participants: Array = [];
var exp_loop = false;
var attack_missed = false;
var attack_result = [];
var player_attack = 0;
var enemy_attack = 0;
var attacks_set = false;
var current_weather = int(Weather.NONE);
var on_action = false;
var trainer_team = [];
var trainer_must_switch = false;
var party_pokemon_selected = false;
var must_show_status_dialog = false;

@onready var pokemon_status = {
	ENUMS.PokemonStatus.BURN: {
		"badge": preload("res://Assets/UI/brn.png"),
		"animation": "Burn"
	}
}

func reset_state(reset_type = true) -> void:
	can_use_menu = false;
	wild_intro = true;
	trainer_intro = true;
	state = ENUMS.BattleStates.NONE;
	pokemon_death = false;
	enemy_death = false;
	level_up_panel_visible = false;
	can_close_level_up_panel = false;
	escape_attempts = 0;
	on_victory = false;
	player_attacked = false;
	enemy_attacked = false;
	current_turn = Turn.NONE;
	attack_pressed = false;
	if(reset_type): type = ENUMS.BattleType.NONE;
	can_use_next_pokemon = false;
	participants = [];
	exp_loop = false;
	attack_missed = false;
	attack_result = [];
	player_attack = 0;
	enemy_attack = 0;
	attacks_set = false;
	current_weather = int(Weather.NONE);
	on_action = false;
	trainer_team = [];
	trainer_must_switch = false;
	must_show_status_dialog = false;

func reset_on_switch() -> void:
	if(BATTLE.type == ENUMS.BattleType.TRAINER):
		trainer_intro = true;
	elif(BATTLE.type == ENUMS.BattleType.WILD):
		wild_intro = true;
	can_use_menu = false;
	state = ENUMS.BattleStates.NONE;
	pokemon_death = false;
	enemy_death = false;
	level_up_panel_visible = false;
	can_close_level_up_panel = false;
	escape_attempts = 0;
	on_victory = false;
	player_attacked = false;
	enemy_attacked = false;
	current_turn = Turn.NONE;
	attack_pressed = false;
	can_use_next_pokemon = false;
	exp_loop = false;
	attack_missed = false;
	attack_result = [];
	player_attack = 0;
	enemy_attack = 0;
	on_action = false;
	attacks_set = false;
	trainer_must_switch = false;

func pokemon_encounter() -> bool:
	randomize();
	var tile_barrier = randi_range(0, 2879);
	if(GLOBAL.on_bike): modifire = modifire * 1.2;
	if tile_barrier <= tile_density * modifire:
		randomize();
		var rand: int = randi_range(0, 100)
		if(rand < tile_density / 10):
			return true
	return false

const MENU_CURSOR: Array = [
	[Vector2(135, 129), Vector2(194, 129)], 
	[Vector2(135, 144), Vector2(194, 144)]
];

const ATTACK_CURSOR: Array = [
	[Vector2(11, 127.5), Vector2(84, 127.5)],
	[Vector2(11, 144.5), Vector2(84, 144.5)]
];

func get_battle_textures(zone: ENUMS.BattleZones): 
	return LIBRARIES.BATTLE.ZONES_LIST[zone];

func can_move_attack_cursor(
	new_position: Vector2,
	attacks: Array
) -> bool:
	const index = [
		{ "pos": ATTACK_CURSOR[0][1], "i": 1 },
		{ "pos": ATTACK_CURSOR[1][0], "i": 2 },
		{ "pos": ATTACK_CURSOR[1][1], "i": 3 }
	];
	
	for attack in index:
		if (
			new_position == attack["pos"] && 
			attacks[attack["i"]].text == ""
		): return false
	return true

func can_pokemon_scape(pokemon: Object, enemy: Object) -> bool:
	var poke_speed = pokemon.data.battle_stats["SPD"];
	var enemy_speed = enemy.data.battle_stats["SPD"];
	var random = randi() % 256;
	escape_attempts += 1;
	
	if(poke_speed >= enemy_speed): return true;
	else: return random < get_odd_number(poke_speed, enemy_speed, escape_attempts);

func get_odd_number(spd: int, enemy_spd: int, attemps: int) -> int:
	return floor(int(floor(
		((spd * 128.0) / enemy_spd) + (30.0 * attemps))) % 256
	);

func add_participant(poke: Object) -> void:
	for participant in participants:
		if(participant.name == poke.name): return;
	participants.push_front(poke);

func remove_participant(poke: Object) -> void: participants.erase(poke);

func get_pokeball_texture(id: ENUMS.Item):
	if(id in pokeball_textures):
		return pokeball_textures[id];
	else: return pokeball_textures[ENUMS.Item.POKEBALL];

func get_trainer_by_id(id: ENUMS.Trainer) -> Variant:
	if(id in LIBRARIES.TRAINERS.trainer_list):
		return LIBRARIES.TRAINERS.trainer_list[id];
	return null;

func are_all_enemies_defeated() -> bool:
	return trainer_team.all(func(enemy): return enemy == -1);

func get_next_trainer_pokemon() -> Variant:
	for id in trainer_team:
		if(id != -1): return id;
	return null;

func remove_trainer_pokemon(id: int) -> void:
	for index in range(0, trainer_team.size()):
		if(trainer_team[index] == id): 
			trainer_team[index] = -1;

func reset_participants(poke: Object) -> void:
	participants = participants.filter(func(p): return p.name == poke.name);

func process_catch(values: Array) -> String:
	var result = "";
	for value in values:
		if(value): result += "Shake_";
		else:
			result += "Break";
			return result.rstrip("_");
	return "Catch";

func get_shadow_texture(data: Dictionary) -> Texture2D:
	match data.specie.shadow:
		ENUMS.ShadowSize.SMALL: return LIBRARIES.IMAGES.SHADOW_SMALL;
		ENUMS.ShadowSize.MEDIUM: return LIBRARIES.IMAGES.SHADOW_MEDIUM;
		ENUMS.ShadowSize.LARGE: return LIBRARIES.IMAGES.SHADOW_LARGE;
	return LIBRARIES.IMAGES.SHADOW_MEDIUM;

func is_wild_and_enemy() -> bool: return(
		BATTLE.type == ENUMS.BattleType.WILD && 
		BATTLE.current_turn == BATTLE.Turn.ENEMY);

func get_fail_catch_message(rates: Array) -> String:
	var index = rates.find(false);
	var messages = {
		0: "Oh no! The POKéMON broke free!",
		1: "Aww! It appeared to be caught!",
		2: "Aargh! Almost had it!",
		3: "Shoot! It was so close, too!"
	};
	return messages[index];

func attack_miss() -> bool: return(
		ENUMS.AttackResult.MISS in BATTLE.attack_result && 
		ENUMS.AttackResult.NONE not in BATTLE.attack_result);

func need_to_check_attack() -> bool:
	var not_normal = ENUMS.AttackResult.NORMAL not in BATTLE.attack_result;
	var not_miss = ENUMS.AttackResult.MISS not in BATTLE.attack_result;
	return (not_normal && not_miss);
