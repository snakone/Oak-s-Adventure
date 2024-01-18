extends Node2D

class_name SpawnController;
# Check for Spawn on Areas that have more than 1 spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;
@export var song: AudioStream;

var map_size: Vector2;

func _ready():
	if(song): AUDIO.play(song);
	GLOBAL.inside_house = false;
	map_size = MAPS.get_map_size(tilemap);
	oak.set_blend_direction(GLOBAL.last_player_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;
	elif(MAPS.position_before_changing_scene):
		set_character_position_after_scene_change();
	MAPS.position_before_changing_scene = null;

func set_character_position_after_scene_change() -> void:
	if GLOBAL.last_player_direction == Vector2.UP:
		oak.position.y = map_size.y - GLOBAL.TILE_SIZE;
		oak.position.x = MAPS.position_before_changing_scene.x;
	elif GLOBAL.last_player_direction == Vector2.DOWN:
		oak.position.y = 0;
		oak.position.x = MAPS.position_before_changing_scene.x;
	elif GLOBAL.last_player_direction == Vector2.LEFT:
		oak.position.y = MAPS.position_before_changing_scene.y;
		oak.position.x = map_size.x - GLOBAL.TILE_SIZE;
	elif GLOBAL.last_player_direction == Vector2.RIGHT: 
		oak.position.y = MAPS.position_before_changing_scene.y;
		oak.position.x = 0;
