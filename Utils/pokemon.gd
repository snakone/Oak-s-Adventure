extends Node

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }

func get_pokemon(index) -> Dictionary:
	return pokemon_list[index];

var pokemon_list: Array = [
	{
		"name": "CHARMANDER",
		"gender": GLOBAL.Genders.MALE,
		"level": 10,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/charmander_menu.png"),
		"current_hp": 14,
		"total_hp": 14,
		"slot": Slots.FIRST,
		"stats": {
			"ATK": 10,
			"DEF": 4,
			"HP": 8,
			"VEL": 7
		}
	}, 
	{
		"name": "SQUIRTLE",
		"gender": GLOBAL.Genders.FEMALE,
		"level": 8,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/squirtle_menu.png"),
		"current_hp": 12,
		"total_hp": 12,
		"slot": Slots.SECOND,
		"stats": {
			"ATK": 8,
			"DEF": 6,
			"HP": 9,
			"VEL": 5
		}
	},
	{
		"name": "BULBASAUR",
		"gender": GLOBAL.Genders.FEMALE,
		"level": 6,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur_menu.png"),
		"current_hp": 11,
		"total_hp": 11,
		"slot": Slots.THRID,
		"stats": {
			"ATK": 6,
			"DEF": 6,
			"HP": 12,
			"VEL": 6
		}
	},
	{
		"name": "HORSEA",
		"gender": GLOBAL.Genders.FEMALE,
		"level": 14,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/horsea_menu.png"),
		"current_hp": 28,
		"total_hp": 28,
		"slot": Slots.FOURTH,
		"stats": {
			"ATK": 6,
			"DEF": 8,
			"HP": 8,
			"VEL": 6
		}
	},
	{
		"name": "PIKACHU",
		"gender": GLOBAL.Genders.MALE,
		"level": 5,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/pikachu_menu.png"),
		"current_hp": 16,
		"total_hp": 16,
		"slot": Slots.FIFTH,
		"stats": {
			"ATK": 4,
			"DEF": 6,
			"HP": 10,
			"VEL": 11
		}
	},
	{
		"name": "BEEDRILL",
		"gender": GLOBAL.Genders.MALE,
		"level": 12,
		"health": 100,
		"party_texture": preload("res://Assets/UI/Pokemon/beedrill_menu.png"),
		"current_hp": 32,
		"total_hp": 32,
		"slot": Slots.SIXTH,
		"stats": {
			"ATK": 15,
			"DEF": 7,
			"HP": 7,
			"VEL": 9
		}
	}
];
