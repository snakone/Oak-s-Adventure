extends Node

signal dialog_finished()
signal attack_finished()
signal on_move_hit();

const FIELD_BG = preload("res://Assets/UI/Battle/field_bg.png");
const SNOW_BG = preload("res://Assets/UI/Battle/snow_bg.png");

enum Type { WILD, TRAINER, ELITE, SPECIAL }

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
	EARTH = 1,
	SNOW = 2,
	CITY = 3,
	ROCK = 4,
	SPECIAL = 5
}

const tile_density = 1325.0;
const modifire = 1.0;

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
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
