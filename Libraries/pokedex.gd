extends Node

var index_options = {
	ENUMS.PokedexIndexOptions.NUMERICAL: {
		"texture": preload("res://Assets/UI/Pokedex/numerical.png"),
		"cursor": Vector2(12, 35.5)
	},
	ENUMS.PokedexIndexOptions.GRASS: {
		"texture": preload("res://Assets/UI/Pokedex/grass.png"),
		"cursor": Vector2(12, 69.5)
	},
	ENUMS.PokedexIndexOptions.WATER: {
		"texture": preload("res://Assets/UI/Pokedex/water.png"),
		"cursor": Vector2(12, 84.5)
	},
	ENUMS.PokedexIndexOptions.SEA: {
		"texture": preload("res://Assets/UI/Pokedex/sea.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.CAVE: {
		"texture": preload("res://Assets/UI/Pokedex/cave.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.MOUNTAIN: {
		"texture": preload("res://Assets/UI/Pokedex/mountain.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.ROUGH: {
		"texture": preload("res://Assets/UI/Pokedex/rough.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.URBAN: {
		"texture": preload("res://Assets/UI/Pokedex/urban.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.RARE: {
		"texture": preload("res://Assets/UI/Pokedex/rare.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.LEGENDARY: {
		"texture": preload("res://Assets/UI/Pokedex/legendary.png"),
		"cursor": Vector2(12, 93.5)
	},
	ENUMS.PokedexIndexOptions.CLOSE: {
		"texture": preload("res://Assets/UI/Pokedex/close.png"),
		"cursor": Vector2(12, 126.5)
	}
}

var pokedex_showcase = [
	{ "number": ENUMS.Pokedex.BULBASAUR, "seen": false, "owned": false, "name": "BULBASAUR" },
	{ "number": ENUMS.Pokedex.IVYSAUR, "seen": false, "owned": false, "name": "IVYSAUR" },
	{ "number": ENUMS.Pokedex.CHARMANDER, "seen": true, "owned": false, "name": "CHARMANDER" },
	{ "number": ENUMS.Pokedex.SQUIRTLE, "seen": false, "owned": false, "name": "SQUIRTLE" },
	{ "number": ENUMS.Pokedex.BEEDRILL, "seen": false, "owned": false, "name": "BEEDRILL" },
	{ "number": ENUMS.Pokedex.PIDGEY, "seen": false, "owned": false, "name": "PIDGEY" },
	{ "number": ENUMS.Pokedex.RATTATA, "seen": true, "owned": true, "name": "RATTATA" },
	{ "number": ENUMS.Pokedex.PIKACHU, "seen": false, "owned": false, "name": "PIKACHU" },
	{ "number": ENUMS.Pokedex.GEODUDE, "seen": false, "owned": false, "name": "GEODUDE" },
	{ "number": ENUMS.Pokedex.HORSEA, "seen": false, "owned": false, "name": "HORSEA" },
	{ "number": ENUMS.Pokedex.HOOH, "seen": true, "owned": true, "name": "HO-OH" },
	{ "number": ENUMS.Pokedex.RAYQUAZA, "seen": false, "owned": false, "name": "RAYQUAZA" }
];

var LIST: Array = [
	{
		"name": "BULBASAUR",
		"number": ENUMS.Pokedex.BULBASAUR,
		"types": [ENUMS.Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 64,
		"category": ENUMS.PokemonCategory.STARTER,
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
			14: 3
		}
	},
	{
		"name": "IVYSAUR",
		"number": ENUMS.Pokedex.IVYSAUR,
		"types": [ENUMS.Types.GRASS, ENUMS.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 141,
		"category": ENUMS.PokemonCategory.STARTER,
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
		"number": ENUMS.Pokedex.CHARMANDER,
		"types": [ENUMS.Types.FIRE],
		"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 65,
		"category": ENUMS.PokemonCategory.STARTER,
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
		"number": ENUMS.Pokedex.SQUIRTLE,
		"types": [ENUMS.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 66,
		"category": ENUMS.PokemonCategory.STARTER,
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
		"number": ENUMS.Pokedex.BEEDRILL,
		"types": [ENUMS.Types.BUG, ENUMS.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 159,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.PIDGEY,
		"types": [ENUMS.Types.NORMAL, ENUMS.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 2000,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.RATTATA,
		"types": [ENUMS.Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 2000,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.PIKACHU,
		"types": [ENUMS.Types.ELECTRIC],
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 82,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.GEODUDE,
		"types": [ENUMS.Types.ROCK, ENUMS.Types.GROUND],
		"party_texture": preload("res://Assets/UI/Pokemon/geodude/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/GEODUDE.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 86,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.HORSEA,
		"types": [ENUMS.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 83,
		"category": ENUMS.PokemonCategory.NORMAL,
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
		"number": ENUMS.Pokedex.HOOH,
		"types": [ENUMS.Types.FIRE, ENUMS.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/ho-oh/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HOOH.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"category": ENUMS.PokemonCategory.LEGENDARY,
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
		"number": ENUMS.Pokedex.RAYQUAZA,
		"types": [ENUMS.Types.DRAGON, ENUMS.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/rayquaza/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RAYQUAZA.ogg"),
		"moves": [1],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"category": ENUMS.PokemonCategory.LEGENDARY,
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
