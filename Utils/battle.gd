extends Node

@onready var pokeball_textures = {
	ENUMS.Item.POKEBALL: preload("res://Assets/UI/Battle/pokeball_catch.png"),
	ENUMS.Item.GREATBALL: preload("res://Assets/UI/Battle/greatball_catch.png")
}

#ATTACK
signal attack_finished();
signal on_move_hit(is_enemy: bool);
signal not_effective();
signal start_attack();
signal attack_check_done();

#UI
signal ui_updated();
signal update_attack_ui();
signal experience_end();
signal hp_bar_anim_duration(duration: float);

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
var modifire = 1.1;

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
var intro_dialog = true;
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
var critical_hit = false;
var attack_missed = false;
var attack_result = [];
var player_attack = 0;
var enemy_attack = 0;
var attacks_set = false;
var current_weather = int(Weather.NONE);
var on_action = false;

func reset_state(reset_type = true) -> void:
	can_use_menu = false;
	intro_dialog = true;
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
	critical_hit = false;
	attack_missed = false;
	attack_result = [];
	player_attack = 0;
	enemy_attack = 0;
	attacks_set = false;
	current_weather = int(Weather.NONE);
	on_action = false;

func pokemon_encounter() -> bool:
	randomize();
	var tile_barrier = randi_range(0, 2879)
	if(GLOBAL.on_bike): modifire = modifire * 1.5;
	else: modifire = 1.0;
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
	return LIBRARIES.BATTLE.ZONES_ARRAY[zone];

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
	return pokeball_textures[id];

func get_trainer_by_id(id: ENUMS.Trainer) -> Variant:
	if(id in LIBRARIES.TRAINERS.LIST):
		return LIBRARIES.TRAINERS.LIST[id];
	return null;
