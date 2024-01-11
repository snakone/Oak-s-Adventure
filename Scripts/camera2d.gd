extends Camera2D

var connected = false;

func _ready() -> void:
	if(!connected):
		GLOBAL.connect("on_tile_map_changed", change_limit);
		connected = true;

func change_limit(size: Vector2, camera_offset: Vector2) -> void:
	#@TODO Firing twice because dont know how to remove current camera before transition
	self.limit_right = int(size.x) * GLOBAL.TILE_SIZE;
	self.limit_bottom = int(size.y) * GLOBAL.TILE_SIZE;
	
	if(camera_offset != Vector2.ZERO):
		self.offset.x = camera_offset.x * GLOBAL.TILE_SIZE;
		self.offset.y = camera_offset.y * GLOBAL.TILE_SIZE * -1;
	else:
		self.offset = camera_offset;
