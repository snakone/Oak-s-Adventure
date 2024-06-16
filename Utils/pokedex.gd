extends Node

enum Category { NORMAL, LEGENDARY, SINGULAR, SPECIAL, NONE, STARTER }
const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

enum PokedexEnum {
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

var pokedex_showcase = [
	{ "number": PokedexEnum.BULBASAUR, "seen": false, "owned": false, "name": "BULBASAUR" },
	{ "number": PokedexEnum.IVYSAUR, "seen": false, "owned": false, "name": "IVYSAUR" },
	{ "number": PokedexEnum.CHARMANDER, "seen": true, "owned": false, "name": "CHARMANDER" },
	{ "number": PokedexEnum.SQUIRTLE, "seen": false, "owned": false, "name": "SQUIRTLE" },
	{ "number": PokedexEnum.BEEDRILL, "seen": false, "owned": false, "name": "BEEDRILL" },
	{ "number": PokedexEnum.PIDGEY, "seen": false, "owned": false, "name": "PIDGEY" },
	{ "number": PokedexEnum.RATTATA, "seen": true, "owned": true, "name": "RATTATA" },
	{ "number": PokedexEnum.PIKACHU, "seen": false, "owned": false, "name": "PIKACHU" },
	{ "number": PokedexEnum.GEODUDE, "seen": false, "owned": false, "name": "GEODUDE" },
	{ "number": PokedexEnum.HORSEA, "seen": true, "owned": false, "name": "HORSEA" },
	{ "number": PokedexEnum.HOOH, "seen": true, "owned": true, "name": "HO-OH" },
	{ "number": PokedexEnum.RAYQUAZA, "seen": false, "owned": false, "name": "RAYQUAZA" }
];

func _ready(): add_to_group(GLOBAL.group_name);

func get_showcase() -> Array:
	showcase_check();
	var index = get_showcase_last_index();
	var copy = pokedex_showcase.duplicate(true);
	copy.resize(index + 1);
	return copy;

func get_pokemon(index) -> Variant:
	for poke in LIBRARY:
		if(poke.number == index): return poke.duplicate();
	return null;

func get_pokemon_showcase(index) -> Variant:
	for poke in pokedex_showcase:
		if(poke.number == index): return poke.duplicate();
	return null;

func showcase_check() -> void:
	for i in range(0, pokedex_showcase.size()):
		var poke = pokedex_showcase[i];
		if(poke): 
			if(!poke.seen && !poke.owned): pokedex_showcase[i] = null;
			elif(poke.owned && !poke.seen): pokedex_showcase[i].seen = true;

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

func get_pokemon_prop(index: int, key: String):
	for poke in LIBRARY:
		if(poke.number == index): return poke[key];

func get_showcase_last_index() -> int:
	if(pokedex_showcase.size() == 0): return -1;
	for i in range(pokedex_showcase.size() - 1, -1, -1):
		if(pokedex_showcase[i] != null): return i;
	return -1;

func add_pokemon_to_showcase(pokemon = null) -> void:
	if(pokemon != null):
		var last_index = get_showcase_last_index();
		if(last_index == pokemon.number || last_index == -1): return;
		
		for i in range(last_index + 1, pokemon.number): 
			pokedex_showcase.append(null);
		pokedex_showcase.append(pokemon);

#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": GLOBAL.SaveType.POKEDEX,
		"pokedex_showcase": pokedex_showcase,
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("pokedex_showcase" in data): 
		pokedex_showcase = data["pokedex_showcase"];

var LIBRARY: Array = [
	{
		"name": "BULBASAUR",
		"number": PokedexEnum.BULBASAUR,
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
			14: 3
		}
	},
	{
		"name": "IVYSAUR",
		"number": PokedexEnum.IVYSAUR,
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
		"number": PokedexEnum.CHARMANDER,
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
		"number": PokedexEnum.SQUIRTLE,
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
		"number": PokedexEnum.BEEDRILL,
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
		"number": PokedexEnum.PIDGEY,
		"types": [MOVES.Types.NORMAL, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.SLACK,
		"base_exp": 2000,
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
		"number": PokedexEnum.RATTATA,
		"types": [MOVES.Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
		"moves": [3],
		"exp_type": BATTLE.ExpType.MEDIUM,
		"base_exp": 2000,
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
		"number": PokedexEnum.PIKACHU,
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
		"number": PokedexEnum.GEODUDE,
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
		"number": PokedexEnum.HORSEA,
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
		"number": PokedexEnum.HOOH,
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
		"number": PokedexEnum.RAYQUAZA,
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
