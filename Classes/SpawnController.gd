extends Node2D

class_name SpawnController;
# Check for Spawn on Areas that have more than 1 spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;

var map_size: Vector2;

func _ready():
	GLOBAL.inside_house = false;
	map_size = MAPS.get_map_size(tilemap);
	oak.set_blend_direction(GLOBAL.last_player_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;
	elif(MAPS.position_before_changing_scene):
		set_character_position_after_scene_change();
	MAPS.position_before_changing_scene = null;

func set_character_position_after_scene_change():
	if GLOBAL.last_player_direction == Vector2(0, -1):  #UP
		oak.position.y = map_size.y - GLOBAL.TILE_SIZE;
		oak.position.x = MAPS.position_before_changing_scene.x;
	elif GLOBAL.last_player_direction == Vector2(0, 1):  #DOWN
		oak.position.y = 0;
		oak.position.x = MAPS.position_before_changing_scene.x;
	elif GLOBAL.last_player_direction == Vector2(-1, 0):  #LEFT
		oak.position.y = MAPS.position_before_changing_scene.y;
		oak.position.x = map_size.x - GLOBAL.TILE_SIZE;
	elif GLOBAL.last_player_direction == Vector2(1, 0):  #RIGHT
		oak.position.y = MAPS.position_before_changing_scene.y;
		oak.position.x = 0;
