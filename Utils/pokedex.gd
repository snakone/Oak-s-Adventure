extends Node

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

func get_pokemon(index):
	for poke in pokedex_list:
		if(poke.number == index):
			return poke;
	
func get_poke_texture(poke_name: String) -> Dictionary:
	for poke in pokedex_list:
		if(poke.name == poke_name):
			return {
				"party": poke.party_texture,
				"front": poke.front_texture,
				"back": poke.back_texture
				};
	return {
		"party": MISSINGNO,
		"front": MISSINGNO,
		"back": MISSINGNO
	};

var pokedex_list: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"types": [Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/bulbasaur/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/bulbasaur/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 6,
			"DEF": 6,
			"HP": 12,
			"VEL": 6
		}
	},
	{
		"name": "IVYSAUR",
		"number": Pokedex.IVYSAUR,
		"types": [Types.GRASS, Types.POISION],
		"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/ivysaur/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/ivysaur/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 22,
			"DEF": 6,
			"HP": 12,
			"VEL": 6
		}
	},
	{
		"name": "CHARMANDER",
		"number": Pokedex.CHARMANDER,
		"types": [Types.FIRE],
		"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/charmander/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/charmander/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 10,
			"DEF": 4,
			"HP": 8,
			"VEL": 7
		}
	}, 
	{
		"name": "SQUIRTLE",
		"number": Pokedex.SQUIRTLE,
		"types": [Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/squirtle/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/squirtle/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 8,
			"DEF": 6,
			"HP": 9,
			"VEL": 5
		}
	},
	{
		"name": "BEEDRILL",
		"number": Pokedex.BEEDRILL,
		"types": [Types.BUG, Types.POISION],
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/beedrill/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/beedrill/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 15,
			"DEF": 7,
			"HP": 7,
			"VEL": 9
		}
	},
	{
		"name": "PIDGEY",
		"number": Pokedex.PIDGEY,
		"types": [Types.NORMAL, Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/pidgey/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/pidgey/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 15,
			"DEF": 7,
			"HP": 7,
			"VEL": 9
		}
	},
	{
		"name": "RATTATA",
		"number": Pokedex.RATTATA,
		"types": [Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/rattata/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/rattata/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 15,
			"DEF": 7,
			"HP": 7,
			"VEL": 9
		}
	},
	{
		"name": "PIKACHU",
		"number": Pokedex.PIKACHU,
		"types": [Types.ELECTRIC],
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/pikachu/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/pikachu/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 4,
			"DEF": 6,
			"HP": 10,
			"VEL": 11
		}
	},
	{
		"name": "HORSEA",
		"number": Pokedex.HORSEA,
		"types": [Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/horsea/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/horsea/back.png"),
		"moves": [1, 2],
		"stats": {
			"ATK": 6,
			"DEF": 8,
			"HP": 8,
			"VEL": 6
		}
	},
];

enum Pokedex {
	BULBASAUR = 1,
	IVYSAUR = 2,
	CHARMANDER = 4,
	SQUIRTLE = 7,
	BEEDRILL = 15,
	PIDGEY = 16,
	RATTATA = 19,
	PIKACHU = 25,
	HORSEA = 116
}

enum Types {
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISION,
	GROUND,
	FLYING,
	PSYCHIC,
	BUG,
	ROCK,
	GHOST,
	DRAGON,
	DARK,
	STEEL,
	FAIRY
}
