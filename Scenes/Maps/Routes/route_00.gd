extends Node2D

@onready var oak = $Oak;
@onready var tilemap = $TileMap;

var map_size: Vector2;

func _ready():
	oak.set_blend_direction(GLOBAL.last_player_direction);
	map_size = MAPS.get_map_size(tilemap);
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;
	elif(MAPS.position_before_changing_scene):
		#UP
		if(GLOBAL.last_player_direction == Vector2(0, -1)):
			oak.position.y = map_size.y - GLOBAL.TILE_SIZE;
			oak.position.x = MAPS.position_before_changing_scene.x;
		#DOWN
		elif(GLOBAL.last_player_direction == Vector2(0, 1)):
			oak.position.y = 0;
			oak.position.x = MAPS.position_before_changing_scene.x;
	MAPS.position_before_changing_scene = null;

