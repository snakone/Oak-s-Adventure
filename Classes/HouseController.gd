extends Node2D
 # Check for Spawn on Houses only.
class_name HouseController;

@onready var oak = $Oak;
@onready var tilemap = $TileMap;
@export var song: AudioStream;

func _ready():
	set_camera();
	GLOBAL.inside_house = true;
	if(song): AUDIO.play(song);
	oak.set_blend_direction(GLOBAL.last_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;

func set_camera() -> void:
	var size: Vector2 = tilemap.get_used_rect().size;
	var diff = GLOBAL.WINDOW_SIZE - size;
	var camera_offset = Vector2.ZERO;
	if(diff > Vector2.ZERO): camera_offset = diff / 2;
	GLOBAL.emit_signal("on_tile_map_changed", size, camera_offset);
