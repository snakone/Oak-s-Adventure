extends Node

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png")


func get_pokemon(index) -> Dictionary:
	return pokemon_list[index];
	
func get_poke_texture(poke_name: String) -> Resource:
	for poke in pokemon_list:
		if(poke.name == poke_name):
			return poke.party_texture;
	return MISSINGNO;

var pokemon_list: Array = [
	{
		"name": "BULBASAUR",
		"number": Pokedex.BULBASAUR,
		"gender": GLOBAL.Genders.FEMALE,
		"types": [Types.GRASS],
		"level": 6,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur_menu.png"),
		"current_hp": 435,
		"total_hp": 435,
		"stats": {
			"ATK": 6,
			"DEF": 6,
			"HP": 12,
			"VEL": 6
		}
	},
	{
		"name": "CHARMANDER",
		"number": Pokedex.CHARMANDER,
		"gender": GLOBAL.Genders.MALE,
		"types": [Types.FIRE],
		"level": 10,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/charmander_menu.png"),
		"current_hp": 392,
		"total_hp": 392,
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
		"gender": GLOBAL.Genders.FEMALE,
		"types": [Types.WATER],
		"level": 8,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle_menu.png"),
		"current_hp": 12,
		"total_hp": 12,
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
		"gender": GLOBAL.Genders.MALE,
		"types": [Types.BUG, Types.POISION],
		"level": 12,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill_menu.png"),
		"current_hp": 32,
		"total_hp": 32,
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
		"gender": GLOBAL.Genders.MALE,
		"types": [Types.NORMAL, Types.FLYING],
		"level": 12,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/pidgey_menu.png"),
		"current_hp": 32,
		"total_hp": 32,
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
		"gender": GLOBAL.Genders.MALE,
		"types": [Types.ELECTRIC],
		"level": 5,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu_menu.png"),
		"current_hp": 16,
		"total_hp": 16,
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
		"gender": GLOBAL.Genders.FEMALE,
		"types": [Types.WATER],
		"level": 14,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/horsea_menu.png"),
		"current_hp": 28,
		"total_hp": 28,
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
