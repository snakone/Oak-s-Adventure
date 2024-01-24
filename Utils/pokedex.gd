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
	HORSEA = 116
}

func get_pokemon(index):
	for poke in pokedex_list:
		if(poke.number == index):
			return poke;
	
func get_poke_resources(poke_name: String) -> Dictionary:
	for poke in pokedex_list:
		if(poke.name == poke_name):
			return {
				"party_texture": poke.party_texture,
				"front_texture": poke.front_texture,
				"back_texture": poke.back_texture,
				"shout": poke.shout
				};
	return {
		"party": MISSINGNO,
		"front": MISSINGNO,
		"back": MISSINGNO,
		"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg")
	};

var pokedex_list: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"types": [MOVES.Types.GRASS],
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/bulbasaur/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/bulbasaur/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
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
		"types": [MOVES.Types.GRASS, MOVES.Types.POISION],
		"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/ivysaur/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/ivysaur/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
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
		"types": [MOVES.Types.FIRE],
		"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/charmander/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/charmander/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
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
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/squirtle/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/squirtle/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
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
		"types": [MOVES.Types.BUG, MOVES.Types.POISION],
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/beedrill/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/beedrill/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
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
		"types": [MOVES.Types.NORMAL, MOVES.Types.FLYING],
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/pidgey/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/pidgey/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
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
		"types": [MOVES.Types.NORMAL],
		"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/rattata/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/rattata/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
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
		"types": [MOVES.Types.ELECTRIC],
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/pikachu/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/pikachu/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
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
		"types": [MOVES.Types.WATER],
		"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
		"front_texture": preload("res://Assets/UI/Pokemon/horsea/anim_front.png"),
		"back_texture": preload("res://Assets/UI/Pokemon/horsea/back.png"),
		"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
		"moves": [1, 2],
		"stats": {
			"ATK": 6,
			"DEF": 8,
			"HP": 8,
			"VEL": 6
		}
	},
];
