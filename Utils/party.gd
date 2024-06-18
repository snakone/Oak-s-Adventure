extends Node

signal selected_pokemon_party(poke_name: String);

var current_party = [];
var active_pokemon: Dictionary;

const ERASE_PROPS = [
	"sprites", "party_texture", "shout", "stats", "battle_stages", 
	"battle_stats", "battle_moves", "offset", "scale", "move_set", 
	"box_offset", "box_scale"
];

func _ready(): add_to_group(GLOBAL.group_name);
func get_party() -> Array: return current_party;

func set_party(party: Array) -> void: 
	current_party = party;
	reset_all_active(true);

func get_active_pokemon() -> Object:
	if(current_party):
		for poke in current_party:
			if(poke.data.active): return poke;
	return null;

func get_next_pokemon() -> Object:
	if(current_party):
		for poke in current_party:
			if(!poke.data.death): return poke;
	return null;

func get_pokemon(poke_name: String):
	for poke in current_party:
		if(poke.name == poke_name): return poke;

func set_active_pokemon(poke_name: String) -> void:
	for poke in current_party:
		if(poke.name == poke_name && !poke.data.death):
			poke.data.active = true;
			break;

func reset_all_active(set_active = false) -> void:
	for poke in current_party: poke.data.active = false;
	
	if(set_active):
		for poke in current_party:
			if(!poke.data.death):
				poke.data.active = true;
				break;

func swap_party_pokemon(initial_pos: int, destiny_pos: int) -> void:
	var copy = current_party.duplicate(true);
	if(
		initial_pos < 0 || 
		initial_pos >= current_party.size() || 
		destiny_pos < 0 ||
		destiny_pos >= current_party.size()
	): return;

	var temp = copy[initial_pos];
	copy[initial_pos] = copy[destiny_pos]
	copy[destiny_pos] = temp;
	current_party = copy;

func healh_party_pokemon() -> void:
	for poke in current_party:
		poke.data.death = false;
		poke.data.current_hp = poke.data.battle_stats["HP"];

func create_party_from_json(party: Array) -> Array:
	#return [
		#Pokemon.new(POKEDEX.LIBRARY[0]),
		#Pokemon.new(POKEDEX.LIBRARY[1]),
		#Pokemon.new(POKEDEX.LIBRARY[2]),
		#Pokemon.new(POKEDEX.LIBRARY[3]),
		#Pokemon.new(POKEDEX.LIBRARY[4]),
		#Pokemon.new(POKEDEX.LIBRARY[5]),
	#]
	var created_party = [];
	var already_active = false;
	for index in range(party.size()):
		var poke = Pokemon.new(party[index]);
		if(!poke.data.death && !already_active): 
			poke.data.active = true;
			already_active = true;
		created_party.push_back(poke);
	return created_party;

#SAVE
func get_party_as_json() -> Array:
	var array = [];
	for poke in current_party:
		var new_data = poke.data.duplicate();
		for prop in ERASE_PROPS: new_data.erase(prop);
		new_data.battle_moves = poke.create_moves();
		array.push_back(new_data);
	return array;

func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.PARTY,
		"party": get_party_as_json(),
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("party" in data): 
		current_party = create_party_from_json(data["party"]);
