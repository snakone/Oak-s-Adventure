extends Node

var position_before_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;
var last_map;

func get_map_size_and_emit(tilemap: TileMap) -> Vector2:
	var size = tilemap.get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size, Vector2.ZERO);
	return Vector2(int(size.x * GLOBAL.TILE_SIZE), int(size.y * GLOBAL.TILE_SIZE));

enum Locations {
	PRAIRE_TOWN,
	OAK_HOUSE,
	ROUTE_00,
	OAK_FARMER_HOUSE,
	ROUTE_01,
	CALDEROCK_VILLAGE,
	POKE_CENTER,
	POKE_SHOP,
	HOUSE_01
}

const location_array = [
	"PraireTown",
	"OakHouse",
	"Route00",
	"OakFarmerHouse",
	"Route01",
	"CalderockVillage",
	"PokeCenter",
	"PokeShop",
	"House01",
	"House02"
];

const location_string = {
	"PraireTown": "Praire Town",
	"OakHouse": "Oak's House",
	"Route00": "Oak's Farm",
	"OakFarmerHouse": "Oak's Farmer House",
	"Route01": "Route 01",
	"CalderockVillage": "Calderock Village",
	"PokeCenter": "POKéMON Center",
	"PokeShop": "POKéMON Shop",
	"House01": "House of ????",
	"House02": "Harold's House"
}

func get_map_name(get_string = false) -> String:
	var map = get_node("/root/SceneManager/CurrentScene").get_child(0).name;
	if(map in location_string):
		if(get_string): return map;
		var string: String = location_string[map];
		return string.to_upper();
	else: return "Mysterious Place";

const CONNECTIONS = {
	"PraireTown": {
		"Route00": {
			Vector2(16, 256): Vector2(16, 0),
			Vector2(32, 256): Vector2(32, 0),
			Vector2(48, 256): Vector2(48, 0),
			Vector2(64, 256): Vector2(64, 0),
			Vector2(80, 256): Vector2(80, 0),
		},
		"Route01": {
			Vector2(272, -16): Vector2(112, 464),
			Vector2(288, -16): Vector2(128, 464)
		}
	},
	"Route00": {
		"PraireTown": {
			Vector2(16, -16): Vector2(16, 240),
			Vector2(32, -16): Vector2(32, 240),
			Vector2(48, -16): Vector2(48, 240),
			Vector2(64, -16): Vector2(64, 240),
			Vector2(80, -16): Vector2(80, 240)
		}
	},
	"Route01": {
		"PraireTown": {
			Vector2(112, 480): Vector2(272, 0),
			Vector2(128, 480): Vector2(288, 0),
		}
	},
	"PokeCenter": {
		"CalderockVillage": Vector2(368, 256)
	},
	"PokeShop": {
		"CalderockVillage": Vector2(464, 256)
	}
}

const ENCOUNTERS = {
	"Route01": {
		1: {
			POKEDEX.Pokedex.PIDGEY: 60.0,
			POKEDEX.Pokedex.RATTATA: 40.0
		}
	}
}

func get_next_map() -> String:
	if(last_map == null): return "";
	var switch = {
		"Route00": "res://Scenes/Maps/Routes/route_00.tscn",
		"Route01": "res://Scenes/Maps/Routes/route_01.tscn",
		"PraireTown": "res://Scenes/Maps/praire_town.tscn",
		"CalderockVillage": "res://Scenes/Maps/calderock_village.tscn"
	}
	
	return switch[last_map];
