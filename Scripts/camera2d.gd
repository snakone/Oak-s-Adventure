extends Camera2D

var connected = false;
var current_offset = Vector2.ZERO;

func _ready() -> void:
	if(!connected):
		GLOBAL.connect("on_tile_map_changed", change_limit);
		connected = true;

func change_limit(size: Vector2, camera_offset: Vector2) -> void:
	#@TODO Firing twice
	limit_right = int(size.x) * GLOBAL.TILE_SIZE;
	limit_bottom = int(size.y) * GLOBAL.TILE_SIZE;
	
	if(camera_offset != Vector2.ZERO):
		offset.x = camera_offset.x * GLOBAL.TILE_SIZE;
		offset.y = camera_offset.y * GLOBAL.TILE_SIZE * -1;
		current_offset = offset;
	else:
		offset = camera_offset;
		current_offset = Vector2.ZERO;
