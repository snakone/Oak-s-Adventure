extends Node

var position_before_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;
var last_map;
var npc_shared_list: Array[int] = [];

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
	HOUSE_01,
	ROUTE_02
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
	"House02",
	"Route02"
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
	"House02": "Harold's House",
	"Route02": "Route 02"
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
	},
	"CalderockVillage": {
		"Route02": {
			Vector2(80, -16): Vector2(96, 640),
			Vector2(96, -16): Vector2(112, 640),
			Vector2(112, -16): Vector2(128, 640),
			Vector2(128, -16): Vector2(144, 640),
			Vector2(144, -16): Vector2(160, 640),
			Vector2(160, -16): Vector2(176, 640)
		}
	},
	"Route02": {
		"CalderockVillage": {
			Vector2(96, 656): Vector2(80, 0),
			Vector2(112, 656): Vector2(96, 0),
			Vector2(128, 656): Vector2(112, 0),
			Vector2(144, 656): Vector2(128, 0),
			Vector2(160, 656): Vector2(144, 0),
			Vector2(176, 656): Vector2(160, 0)
		}
	}
}

const ENCOUNTERS = {
	"Route01": {
		1: {
			POKEDEX.Pokedex.PIDGEY: 60.0,
			POKEDEX.Pokedex.RATTATA: 40.0
		}
	},
	"Route02": {
		1: {
			POKEDEX.Pokedex.BULBASAUR: 50.0,
			POKEDEX.Pokedex.CHARMANDER: 50.0,
		}
	}
}

func get_next_map() -> String:
	if(last_map == null): return "";
	var switch = {
		"Route00": "res://Scenes/Maps/Routes/route_00.tscn",
		"Route01": "res://Scenes/Maps/Routes/route_01.tscn",
		"Route02": "res://Scenes/Maps/Routes/route_02.tscn",
		"PraireTown": "res://Scenes/Maps/praire_town.tscn",
		"CalderockVillage": "res://Scenes/Maps/calderock_village.tscn"
	}
	
	return switch[last_map];

func reset_npc_shared_list() -> void: npc_shared_list = [];

@onready var NPC_SHARED_MAP = {
	1: {
		"dialog_id": 42,
		"texture": load("res://Sprites/NPC/green_girl.png"),
		"frames": 4,
		"state": GLOBAL.NPCStates.IDLE,
		"can_left": false,
		"can_right": false,
		"can_up": false,
		"can_down": true,
		"possitive_limits": Vector2.ZERO,
		"negative_limits": Vector2.ZERO,
		"interval": 2,
		"position": Vector2(192, 80)
	},
	2: {
		"dialog_id": 43,
		"texture": load("res://Sprites/NPC/yellow_cap_guy.png"),
		"frames": 12,
		"state": GLOBAL.NPCStates.MOVING,
		"can_left": true,
		"can_right": true,
		"can_up": true,
		"can_down": true,
		"possitive_limits": Vector2(1, 1),
		"negative_limits": Vector2.ZERO,
		"interval": 1,
		"position": Vector2(48, 80),
		"sprite_offset": Vector2(0, -3)
	},
	3: {
		"dialog_id": 46,
		"texture": load("res://Sprites/NPC/orange_girl.png"),
		"frames": 12,
		"state": GLOBAL.NPCStates.MOVING,
		"can_left": true,
		"can_right": true,
		"can_up": true,
		"can_down": true,
		"possitive_limits": Vector2(2, 3),
		"negative_limits": Vector2(0, -1),
		"interval": 5,
		"position": Vector2(112, 48)
	}
}
