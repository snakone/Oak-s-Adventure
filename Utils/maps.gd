extends Node

var position_before_changing_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;

func get_map_size_and_emit(tilemap: TileMap) -> Vector2:
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

const location_string = {
	"PraireTown": "Praire Town",
	"OakHouse": "Oak's House",
	"Route00": "Oak's Farm",
	"OakFarmerHouse": "Oak's Farmer House"
}

func get_map_name() -> String:
	var map = get_node("/root/SceneManager/CurrentScene").get_child(0).name;
	if(map in location_string):
		var string: String = location_string[map];
		return string.to_upper();
	else: return "Mysterious Place";
