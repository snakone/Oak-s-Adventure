extends Node2D

class_name HouseController;
# Check for Spawn on Houses only.
# Houses have fixed spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;

func _ready():
	set_camera();
	oak.set_blend_direction(MAPS.LIBRARY.OakHouse.spawn_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;

func set_camera() -> void:
	var size = tilemap.get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size);
