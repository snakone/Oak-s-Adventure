extends Node

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

func get_pokemon(index) -> Dictionary:
	return pokedex_list[index];
	
func get_poke_texture(poke_name: String) -> Resource:
	for poke in pokedex_list:
		if(poke.name == poke_name):
			return poke.party_texture;
	return MISSINGNO;

var pokedex_list: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"types": [Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
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
