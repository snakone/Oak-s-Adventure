extends Node

var position_before_changing_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;

func get_map_size(tilemap: TileMap) -> Vector2:
	var size = tilemap.get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size, Vector2.ZERO);
	return Vector2(int(size.x * GLOBAL.TILE_SIZE), int(size.y * GLOBAL.TILE_SIZE));

enum Locations {
	PRAIRE_TOWN,
	OAK_HOUSE,
	ROUTE_00,
	OAK_FARMER_HOUSE
}

const location_array = [
	"PraireTown",
	"OakHouse",
	"Route00",
	"OakFarmerHouse"
];

var dialog_count = {
	"Mom": {
		MAPS.Locations.PRAIRE_TOWN: 0
	}
}
