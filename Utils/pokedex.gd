extends Node

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
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
	HORSEA = 116,
	HOOH = 250,
	RAYQUAZA = 384
}

func get_pokemon(index):
	for poke in pokedex_list:
		if(poke.number == index): return poke.duplicate();

func get_poke_resources(poke_name: String):
	for poke in pokedex_list:
		if(poke.name == poke_name):
			return {
				"party_texture": poke.party_texture,
				"shout": poke.shout,
				"sprites": str(poke.sprites),
				"offset": poke.offset,
				"scale": poke.scale
			};

func get_pokemon_prop(poke_name: String, key: String):
	for poke in pokedex_list:
		if(poke.name == poke_name): return poke[key];

var pokedex_list: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"types": [MOVES.Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 64,
		"sprites": "res://Sprites/Animated/Bulbasaur/bulbasaur.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 45,
			"ATK": 49,
			"DEF": 49,
			"S.ATK": 65,
			"S.DEF": 65,
			"SPD": 45,
			"TOTAL": 318
		}
	},
	{
		"name": "IVYSAUR",
		"number": Pokedex.IVYSAUR,
		"types": [MOVES.Types.GRASS, MOVES.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 141,
		"sprites": "res://Sprites/Animated/Ivysaur/ivysaur.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 60,
			"ATK": 62,
			"DEF": 63,
			"S.ATK": 80,
			"S.DEF": 80,
			"SPD": 60,
			"TOTAL": 405
		}
	},
	{
		"name": "CHARMANDER",
		"number": Pokedex.CHARMANDER,
		"types": [MOVES.Types.FIRE],
		"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 65,
		"sprites": "res://Sprites/Animated/Charmander/charmander.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 39,
			"ATK": 52,
			"DEF": 43,
			"S.ATK": 60,
			"S.DEF": 50,
			"SPD": 65,
			"TOTAL": 309
		}
	}, 
	{
		"name": "SQUIRTLE",
		"number": Pokedex.SQUIRTLE,
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 66,
		"sprites": "res://Sprites/Animated/Squirtle/squirtle.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 44,
			"ATK": 48,
			"DEF": 65,
			"S.ATK": 50,
			"S.DEF": 64,
			"SPD": 43,
			"TOTAL": 314
		}
	},
	{
		"name": "BEEDRILL",
		"number": Pokedex.BEEDRILL,
		"types": [MOVES.Types.BUG, MOVES.Types.POISON],
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 159,
		"sprites": "res://Sprites/Animated/Beedrill/beedrill.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 65,
			"ATK": 90,
			"DEF": 40,
			"S.ATK": 45,
			"S.DEF": 80,
			"SPD": 75,
			"TOTAL": 395
		}
	},
	{
		"name": "PIDGEY",
		"number": Pokedex.PIDGEY,
		"types": [MOVES.Types.NORMAL, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 40,
		"sprites": "res://Sprites/Animated/Pidgey/pidgey.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 40,
			"ATK": 45,
			"DEF": 40,
			"S.ATK": 35,
			"S.DEF": 35,
			"SPD": 6,
			"TOTAL": 251
		}
	},
	{
		"name": "RATTATA",
		"number": Pokedex.RATTATA,
		"types": [MOVES.Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 4000,
		"sprites": "res://Sprites/Animated/Rattata/rattata.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 30,
			"ATK": 56,
			"DEF": 35,
			"S.ATK": 25,
			"S.DEF": 35,
			"SPD": 4000,
			"TOTAL": 253
		}
	},
	{
		"name": "PIKACHU",
		"number": Pokedex.PIKACHU,
		"types": [MOVES.Types.ELECTRIC],
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 82,
		"sprites": "res://Sprites/Animated/Pikachu/pikachu.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 35,
			"ATK": 55,
			"DEF": 40,
			"S.ATK": 50,
			"S.DEF": 50,
			"SPD": 90,
			"TOTAL": 320
		}
	},
	{
		"name": "HORSEA",
		"number": Pokedex.HORSEA,
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 83,
		"sprites": "res://Sprites/Animated/Horsea/horsea.tscn",
		"offset": Vector2.ZERO,
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 30,
			"ATK": 40,
			"DEF": 70,
			"S.ATK": 70,
			"S.DEF": 25,
			"SPD": 60,
			"TOTAL": 295
		}
	},
	{
		"name": "HO-OH",
		"number": Pokedex.HOOH,
		"types": [MOVES.Types.FIRE, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/ho-oh/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HOOH.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"sprites": "res://Sprites/Animated/Ho-oh/ho-oh.tscn",
		"offset": Vector2(0, -16),
		"scale": Vector2(0.7, 0.7),
		"stats": {
			"HP": 106,
			"ATK": 130,
			"DEF": 90,
			"S.ATK": 110,
			"S.DEF": 154,
			"SPD": 90,
			"TOTAL": 680
		}
	},
	{
		"name": "RAYQUAZA",
		"number": Pokedex.RAYQUAZA,
		"types": [MOVES.Types.DRAGON, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/rayquaza/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RAYQUAZA.ogg"),
		"moves": [1, 2],
		"exp_type": BATTLE.ExpType.SLOW,
		"base_exp": 220,
		"sprites": "res://Sprites/Animated/Rayquaza/rayquaza.tscn",
		"offset": Vector2(0, -10),
		"scale": Vector2(0.8, 0.8),
		"stats": {
			"HP": 105,
			"ATK": 150,
			"DEF": 90,
			"S.ATK": 150,
			"S.DEF": 90,
			"SPD": 95,
			"TOTAL": 680
		}
	},
];
