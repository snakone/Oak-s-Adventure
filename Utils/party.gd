extends Node

var current_party = [];
var active_pokemon: Dictionary;

func _ready(): 
	add_to_group(GLOBAL.group_name);

func get_party() -> Array: return current_party;

func get_active_pokemon():
	if(current_party): return current_party[3];

func create_party_from_json(party: Array) -> Array:
	#return [
		#Pokemon.new(POKEDEX.pokedex_list[0]),
		#Pokemon.new(POKEDEX.pokedex_list[1]),
		#Pokemon.new(POKEDEX.pokedex_list[2]),
		#Pokemon.new(POKEDEX.pokedex_list[3]),
		#Pokemon.new(POKEDEX.pokedex_list[4]),
		#Pokemon.new(POKEDEX.pokedex_list[5]),
	#]
	var created_party = [];
	for poke in party:
		created_party.push_front(Pokemon.new(poke));
	return created_party;

func get_party_as_json() -> Array:
	var array = [];
	for poke in current_party:
		array.push_front(poke.data);
	return array;

func save() -> Dictionary:
	var data := {
		"save_type": GLOBAL.SaveType.PARTY,
		"party": get_party_as_json(),
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("party" in data): 
		current_party = create_party_from_json(data["party"]);
