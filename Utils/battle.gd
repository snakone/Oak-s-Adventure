extends Node

signal dialog_finished()
signal attack_finished()
signal ui_updated();
signal on_move_hit(is_enemy: bool);
signal critical_landed();
signal not_effective();
signal experience_end();
signal hp_bar_anim_duration(duration: float);
signal level_up_stats_end();

signal close_level_up_panel();
signal show_total_stats_panel();
signal show_level_up_panel();
signal after_dialog_attack();

enum Type { WILD, TRAINER, ELITE, SPECIAL }
enum ExpType { ERRATIC, FAST, MEDIUM, SLOW, SLACK, FLUCTUATING }

enum States {
	MENU = 0, 
	FIGHT = 1, 
	BAG = 2, 
	PARTY = 3, 
	RUN = 4, 
	DIALOG = 5, 
	NONE = 6, 
	ATTACKING = 7,
	LEVELLING = 8
}

enum Zones {
	FIELD = 0,
	GRASS = 1,
	SNOW = 2,
}

#MARKERS
const BACKGROUND_ORANGE = preload("res://Assets/UI/Battle/attack_select_background_orange.png");
const BACKGROUND_GREEN = preload("res://Assets/UI/Battle/attack_select_background_green.png");
const BACKGROUND_BLUE = preload("res://Assets/UI/Battle/attack_select_background_blue.png");
const MAIN_MENU_ORANGE = preload("res://Assets/UI/Battle/main_menu_orange.png");
const MAIN_MENU_GREEN = preload("res://Assets/UI/Battle/main_menu_green.png");
const MAIN_MENU_BLUE = preload("res://Assets/UI/Battle/main_menu_blue.png");

#FIELD
const FIELD_BG = preload("res://Assets/UI/Battle/Backgrounds/field_bg.png");
const FIELD_BASE_0 = preload("res://Assets/UI/Battle/Backgrounds/field_base0.png");
const FIELD_BASE_1 = preload("res://Assets/UI/Battle/Backgrounds/field_base1.png");

#GRASS
const GRASS_01 = preload("res://Assets/UI/Battle/Backgrounds/grass_01.png");
const GRASS_BASE_0 = preload("res://Assets/UI/Battle/Backgrounds/grass_base0.png");
const GRASS_BASE_1 = preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png");

#SNOW
const SNOW_BG = preload("res://Assets/UI/Battle/Backgrounds/snow_bg.png");
const SNOW_BASE_0 = preload("res://Assets/UI/Battle/Backgrounds/snow_base0.png");
const SNOW_BASE_1 = preload("res://Assets/UI/Battle/Backgrounds/snow_base1.png");

#BARS
const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");

#SOUNDS
const BATTLE_SOUNDS = {
	"CONFIRM": preload("res://Assets/Sounds/confirm.wav"),
	"GUI_SEL_DECISION": preload("res://Assets/Sounds/GUI sel decision.ogg"),
	"GUI_MENU_CLOSE": preload("res://Assets/Sounds/GUI menu close.ogg"),
	"BATTLE_FLEE": preload("res://Assets/Sounds/Battle flee.ogg"),
	"EXP_GAIN_PKM": preload("res://Assets/Sounds/exp_gain_pkm.mp3"),
	"EXP_FULL": preload("res://Assets/Sounds/exp_full.mp3")
}

const tile_density = 1325.0;
const modifire = 1.0;

const min_hp_anim_duration = 0.3;
const max_hp_anim_duration = 3;

const GREEN_BAR_PERCT = 0.51;
const YELLOW_BAR_PERCT = 0.2;

var level_up_panel_visible = false;
var can_close_level_up_panel = false;

var state = States.NONE;
var pokemon_death = false;
var enemy_death = false;
var intro_dialog = true;
var can_use_menu = false;

@onready var zones_array = [
	{
		"background": FIELD_BG,
		"enemy_ground": FIELD_BASE_1,
		"player_ground": FIELD_BASE_0
	},
	{
		"background": GRASS_01,
		"enemy_ground": GRASS_BASE_1,
		"player_ground": GRASS_BASE_0
	},
	{
		"background": SNOW_BG,
		"enemy_ground": SNOW_BASE_1,
		"player_ground": SNOW_BASE_0
	},
];

func reset_state() -> void:
	BATTLE.can_use_menu = false;
	BATTLE.intro_dialog = true;
	BATTLE.state = BATTLE.States.NONE;
	BATTLE.pokemon_death = false;
	BATTLE.enemy_death = false;
	BATTLE.level_up_panel_visible = false;
	BATTLE.can_close_level_up_panel = false;

func pokemon_encounter() -> bool:
	randomize()
	var tile_barrier = randi_range(0, 2879)
	if tile_barrier <= tile_density * modifire:
		randomize()
		var rand: int = randi_range(0, 100)
		if(rand < tile_density / 10):
			return true
	return false

const menu_cursor_pos: Array = [
	[Vector2(135, 129), Vector2(194, 129)], 
	[Vector2(135, 144), Vector2(194, 144)]
];

const attack_cursor_pos: Array = [
	[Vector2(13, 127), Vector2(80, 127)],
	[Vector2(13, 145), Vector2(80, 145)]
];

func get_battle_textures(zone: BATTLE.Zones): return zones_array[zone];

func get_markers(type: SETTINGS.Markers):
	match type:
		SETTINGS.Markers.ORANGE:
			return {
				"menu": MAIN_MENU_ORANGE,
				"attack": BACKGROUND_ORANGE
			}
		SETTINGS.Markers.BLUE:
			return {
				"menu": MAIN_MENU_BLUE,
				"attack": BACKGROUND_BLUE
			}
		SETTINGS.Markers.GREEN:
			return {
				"menu": MAIN_MENU_GREEN,
				"attack": BACKGROUND_GREEN
			}

func can_move_attack_cursor(
	new_position: Vector2,
	player_attacks: Array
) -> bool:
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
	): return false;
	return true;
