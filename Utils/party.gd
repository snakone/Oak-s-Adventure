extends Node

signal selected_pokemon_party(poke_name: String);

var current_party = [];
var active_pokemon: Dictionary;

const erase_props_on_save = [
	"sprites", "party_texture", "shout", "stats", "battle_stages", "battle_stats", "offset", "scale"
];

func _ready(): add_to_group(GLOBAL.group_name);
func get_party() -> Array: return current_party;

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

func swap_party_pokemon(party: Array, initial_pos: int, destiny_pos: int) -> Array:
	var copy = party.duplicate(true);
	if(
		initial_pos < 0 || 
		initial_pos >= party.size() || 
		destiny_pos < 0 ||
		destiny_pos >= party.size()
	): return party;

	var temp = copy[initial_pos];
	copy[initial_pos] = copy[destiny_pos]
	copy[destiny_pos] = temp;
	return copy;

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
		for prop in erase_props_on_save: new_data.erase(prop);
		var new_moves = [];
		for move in poke.data.battle_moves.duplicate():
			new_moves.push_back({
				"name": move.name,
				"pp": move.pp,
				"id": move.id
			})
		new_data.battle_moves = new_moves;
		array.push_back(new_data);
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
