extends Node

enum Category { NORMAL, LEGENDARY, SINGULAR, SPECIAL, NONE, STARTER }
const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

enum Pokedex {
	BULBASAUR = 1,
	IVYSAUR = 2,
	CHARMANDER = 4,
	SQUIRTLE = 7,
	BEEDRILL = 15,
	PIDGEY = 16,
	RATTATA = 19,
	PIKACHU = 25,
	GEODUDE = 74,
	HORSEA = 116,
	HOOH = 250,
	RAYQUAZA = 384
}

func get_pokemon(index):
	for poke in LIBRARY:
		if(poke.number == index): return poke.duplicate();

func get_poke_resources(poke_name: String):
	for poke in LIBRARY:
		if(poke.name == poke_name):
			return {
				"party_texture": poke.party_texture,
				"shout": poke.shout,
				"sprites": str(poke.sprites),
				"offset": poke.offset,
				"scale": poke.scale,
				"move_set": poke.move_set,
				"box_scale": poke.box_scale,
				"box_offset": poke.box_offset
			};

func get_pokemon_prop(poke_name: String, key: String):
	for poke in LIBRARY:
		if(poke.name == poke_name): return poke[key];

var LIBRARY: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"types": [MOVES.Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 64,
		"category": Category.STARTER,
		"sprites": "res://Sprites/Animated/Bulbasaur/bulbasaur.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 45,
			"ATK": 49,
			"DEF": 49,
			"S.ATK": 65,
			"S.DEF": 65,
			"SPD": 45,
			"TOTAL": 318
		},
		"move_set": {
			51: 3
		}
	},
	{
		"name": "IVYSAUR",
		"number": Pokedex.IVYSAUR,
		"types": [MOVES.Types.GRASS, MOVES.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 141,
		"category": Category.STARTER,
		"sprites": "res://Sprites/Animated/Ivysaur/ivysaur.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2(-7, -7),
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 60,
			"ATK": 62,
			"DEF": 63,
			"S.ATK": 80,
			"S.DEF": 80,
			"SPD": 60,
			"TOTAL": 405
		},
		"move_set": {}
	},
	{
		"name": "CHARMANDER",
		"number": Pokedex.CHARMANDER,
		"types": [MOVES.Types.FIRE],
		"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 65,
		"category": Category.STARTER,
		"sprites": "res://Sprites/Animated/Charmander/charmander.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 39,
			"ATK": 52,
			"DEF": 43,
			"S.ATK": 60,
			"S.DEF": 50,
			"SPD": 65,
			"TOTAL": 309
		},
		"move_set": {}
	}, 
	{
		"name": "SQUIRTLE",
		"number": Pokedex.SQUIRTLE,
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 66,
		"category": Category.STARTER,
		"sprites": "res://Sprites/Animated/Squirtle/squirtle.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 44,
			"ATK": 48,
			"DEF": 65,
			"S.ATK": 50,
			"S.DEF": 64,
			"SPD": 43,
			"TOTAL": 314
		},
		"move_set": {
			4: 3
		}
	},
	{
		"name": "BEEDRILL",
		"number": Pokedex.BEEDRILL,
		"types": [MOVES.Types.BUG, MOVES.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 159,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Beedrill/beedrill.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2(-22, -18),
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 65,
			"ATK": 90,
			"DEF": 40,
			"S.ATK": 45,
			"S.DEF": 80,
			"SPD": 75,
			"TOTAL": 395
		},
		"move_set": {}
	},
	{
		"name": "PIDGEY",
		"number": Pokedex.PIDGEY,
		"types": [MOVES.Types.NORMAL, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 40,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Pidgey/pidgey.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 40,
			"ATK": 45,
			"DEF": 40,
			"S.ATK": 35,
			"S.DEF": 35,
			"SPD": 56,
			"TOTAL": 251
		},
		"move_set": {}
	},
	{
		"name": "RATTATA",
		"number": Pokedex.RATTATA,
		"types": [MOVES.Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 4000,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Rattata/rattata.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 30,
			"ATK": 56,
			"DEF": 35,
			"S.ATK": 25,
			"S.DEF": 35,
			"SPD": 72,
			"TOTAL": 253
		},
		"move_set": {}
	},
	{
		"name": "PIKACHU",
		"number": Pokedex.PIKACHU,
		"types": [MOVES.Types.ELECTRIC],
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 82,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Pikachu/pikachu.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 35,
			"ATK": 55,
			"DEF": 40,
			"S.ATK": 50,
			"S.DEF": 50,
			"SPD": 90,
			"TOTAL": 320
		},
		"move_set": {}
	},
	{
		"name": "GEODUDE",
		"number": Pokedex.GEODUDE,
		"types": [MOVES.Types.ROCK, MOVES.Types.GROUND],
		"party_texture": preload("res://Assets/UI/Pokemon/geodude/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/GEODUDE.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 86,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Geodude/geodude.tscn",
		"offset": Vector2(-1, -3),
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 40,
			"ATK": 80,
			"DEF": 100,
			"S.ATK": 30,
			"S.DEF": 30,
			"SPD": 20,
			"TOTAL": 300
		},
		"move_set": {}
	},
	{
		"name": "HORSEA",
		"number": Pokedex.HORSEA,
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 83,
		"category": Category.NORMAL,
		"sprites": "res://Sprites/Animated/Horsea/horsea.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2.ZERO,
		"box_scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 30,
			"ATK": 40,
			"DEF": 70,
			"S.ATK": 70,
			"S.DEF": 25,
			"SPD": 60,
			"TOTAL": 295
		},
		"move_set": {}
	},
	{
		"name": "HO-OH",
		"number": Pokedex.HOOH,
		"types": [MOVES.Types.FIRE, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/ho-oh/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HOOH.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"category": Category.LEGENDARY,
		"sprites": "res://Sprites/Animated/Ho-oh/ho-oh.tscn",
		"offset": Vector2(0, -16),
		"scale": Vector2(0.7, 0.7),
		"box_offset": Vector2(-28, -28),
		"box_scale": Vector2(0.6, 0.6),
		"stats": {
			"HP": 106,
			"ATK": 130,
			"DEF": 90,
			"S.ATK": 110,
			"S.DEF": 154,
			"SPD": 90,
			"TOTAL": 680
		},
		"move_set": {}
	},
	{
		"name": "RAYQUAZA",
		"number": Pokedex.RAYQUAZA,
		"types": [MOVES.Types.DRAGON, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/rayquaza/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RAYQUAZA.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"category": Category.LEGENDARY,
		"sprites": "res://Sprites/Animated/Rayquaza/rayquaza.tscn",
		"offset": Vector2(0, -10),
		"scale": Vector2(0.8, 0.8),
		"box_offset": Vector2(-30, -30),
		"box_scale": Vector2(0.6, 0.6),
		"stats": {
			"HP": 105,
			"ATK": 150,
			"DEF": 90,
			"S.ATK": 150,
			"S.DEF": 90,
			"SPD": 95,
			"TOTAL": 680
		},
		"move_set": {}
	},
];
