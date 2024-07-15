extends Node

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
	"Route02": "Route 02",
	"JulietaHouse": "Julieta's House",
	"JulietaUnderground": "Julieta's Undergr.",
	"JulietaUndergroundRight": "Julieta's Undergr."
}

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
	},
	"JulietaUnderground": {
		"JulietaUndergroundRight": {
			Vector2(208, 48): Vector2(0, 48),
			Vector2(208, 64): Vector2(0, 64),
			Vector2(208, 80): Vector2(0, 80),
			Vector2(208, 128): Vector2(0, 128),
		}
	}
}

var ENCOUNTERS = {
	"Route01": {
		1: {
			ENUMS.Pokedex.RATTATA: 40.0,
			ENUMS.Pokedex.PIDGEY: 60.0,
			ENUMS.Pokedex.CHARMELEON: 100.0,
			ENUMS.Pokedex.BEEDRILL: 50.0,
			ENUMS.Pokedex.HOOH: 50.0,
			ENUMS.Pokedex.RAYQUAZA: 100.0
		}
	},
	"Route02": {
		1: {
			ENUMS.Pokedex.BULBASAUR: 50.0,
			ENUMS.Pokedex.CHARMANDER: 50.0,
		}
	}
}

var NPC_SHARED_MAP = {
	1: {
		"dialog_id": 42,
		"texture": preload("res://Sprites/NPC/green_girl.png"),
		"frames": 4,
		"state": ENUMS.NPCStates.IDLE,
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
		"texture": preload("res://Sprites/NPC/yellow_cap_guy.png"),
		"frames": 12,
		"state": ENUMS.NPCStates.MOVING,
		"can_left": true,
		"can_right": true,
		"can_up": true,
		"can_down": true,
		"possitive_limits": Vector2(1, 1),
		"negative_limits": Vector2.ZERO,
		"interval": 5,
		"position": Vector2(48, 80),
		"sprite_offset": Vector2(0, -3)
	},
	3: {
		"dialog_id": 46,
		"texture": preload("res://Sprites/NPC/orange_girl.png"),
		"frames": 12,
		"state": ENUMS.NPCStates.MOVING,
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
