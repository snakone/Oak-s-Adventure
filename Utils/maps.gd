extends Node

var position_before_changing_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;

const LIBRARY = {
	"OakHouse": {
		"start_position": Vector2(80, 128),
		"spawn_direction": GLOBAL.directions_array[GLOBAL.DIRECTIONS.UP]
	}
}

func get_map_size(tilemap: TileMap) -> Vector2:
	var size = tilemap.get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size);
	return Vector2(int(size.x * GLOBAL.TILE_SIZE), int(size.y * GLOBAL.TILE_SIZE));
