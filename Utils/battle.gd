extends Node

signal dialog_finished()
signal attack_finished()
signal ui_updated();
signal on_move_hit(is_enemy: bool);
signal critical_landed();
signal not_effective();
signal experience_end();
signal health_bar_animation_duration(duration: float);

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
	ATTACKING = 7
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

const tile_density = 1325.0;
const modifire = 1.0;

const min_hp_anim_duration = 0.3;
const max_hp_anim_duration = 3;

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
	
