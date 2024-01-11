extends Node

var current_party = [];

func _ready():
	current_party = POKEMON.pokemon_list;
	
func get_party() -> Array:
	return current_party;
