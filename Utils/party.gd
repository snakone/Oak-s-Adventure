extends Node

var current_party = [];
var active_pokemon: Dictionary;

func _ready(): current_party = POKEMON.pokemon_list;
func get_party() -> Array: return current_party;

func get_active_pokemon() -> Dictionary:
	if(current_party):
		for poke in current_party:
			if("slot" in poke && poke.slot == POKEMON.Slots.FIRST):
				return poke;
	return {};

func save() -> Dictionary:
	var data := {
		"save_type": GLOBAL.SaveType.PARTY,
		"party": get_party(),
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if(data["party"]):
		current_party = data["party"];
