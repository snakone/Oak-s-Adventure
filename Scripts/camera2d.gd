extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GLOBAL.can_change_camera):
		GLOBAL.connect("on_tile_map_changed", change_limit)
	
func change_limit(size: Vector2):
	#@TODO Firing twice because dont know how to remove current camera before transition
	self.limit_right = int(size.x) * GLOBAL.TILE_SIZE;
	self.limit_bottom = int(size.y) * GLOBAL.TILE_SIZE;
	GLOBAL.can_change_camera = false;
	
