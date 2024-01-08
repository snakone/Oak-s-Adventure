extends Camera2D

var connected = false;

func _ready() -> void:
	if(!connected):
		GLOBAL.connect("on_tile_map_changed", change_limit);
		connected = true;

func change_limit(size: Vector2) -> void:
	#@TODO Firing twice because dont know how to remove current camera before transition
	self.limit_right = int(size.x) * GLOBAL.TILE_SIZE;
	self.limit_bottom = int(size.y) * GLOBAL.TILE_SIZE;
