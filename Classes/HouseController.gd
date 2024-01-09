extends Node2D

class_name HouseController;
# Check for Spawn on Houses only.
# Houses have fixed spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;

func _ready():
	set_camera();
	oak.set_blend_direction(GLOBAL.last_player_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;

func set_camera() -> void:
	var size: Vector2 = tilemap.get_used_rect().size;
	var diff = GLOBAL.WINDOW_SIZE - size;
	var camera_offset = Vector2.ZERO;
	if(diff > Vector2.ZERO): camera_offset = diff / 2;
	GLOBAL.emit_signal("on_tile_map_changed", size, camera_offset);
