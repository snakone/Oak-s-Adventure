extends Node

var current_party = [];
var active_pokemon: Dictionary;

func _ready(): 
	add_to_group(GLOBAL.group_name);

func get_party() -> Array: return current_party;

func get_active_pokemon() -> Dictionary:
	if(current_party): return current_party[0];
	return {};

func create_party_from_json(party: Array) -> Array:
	var created_party = [];
	for poke in party:
		created_party.push_front(Pokemon.new(poke));
	return created_party;

func get_party_as_json() -> Array:
	var array = [];
	for poke in current_party:
		poke.data.erase("party_texture");
		poke.data.erase("stats");
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
	if(data["party"]): 
		current_party = create_party_from_json(data["party"]);
