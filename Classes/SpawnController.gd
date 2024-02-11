extends Node2D

class_name SpawnController;
# Check for Spawn on Areas that have more than 1 spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;
@export var song: AudioStream;

func _ready():
	if(song): AUDIO.play(song);
	GLOBAL.inside_house = false;
	MAPS.get_map_size_and_emit(tilemap);
	oak.set_blend_direction(GLOBAL.last_direction);
	
	#COMING FROM HOUSE
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;
		return;
	
	#COMING FROM SCENE
	if(MAPS.position_before_scene && MAPS.last_map != null):
		if(
			MAPS.last_map in MAPS.connections &&
			name in MAPS.connections[MAPS.last_map] &&
			MAPS.position_before_scene in MAPS.connections[MAPS.last_map][name]
		):
			oak.position = MAPS.connections[MAPS.last_map][name][MAPS.position_before_scene];
