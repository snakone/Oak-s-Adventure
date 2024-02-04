extends Node

signal selected_pokemon_party(poke_name: String);

var current_party = [];
var active_pokemon: Dictionary;

const erase_props_on_save = [
	"front_texture", "back_texture", "party_texture", "shout", "stats", "battle_stages"
];

func _ready(): add_to_group(GLOBAL.group_name);
func get_party() -> Array: return current_party;

func get_active_pokemon(): 
	if(current_party):
		for poke in current_party:
			if(poke.data.active): 
				return poke;
		return current_party[0];

func get_next_pokemon():
	if(current_party):
		for poke in current_party:
			if(!poke.data.death): return poke;

func get_pokemon(poke_name: String):
	for poke in current_party:
		if(poke.name == poke_name): return poke;

func set_active_pokemon(poke_name: String) -> void:
	reset_all_active();
	for poke in current_party:
		if(poke.name == poke_name): 
			poke.data.active = true;
			break;

func reset_active() -> void:
	for poke in current_party:
		if("active" in poke.data && poke.data.active): poke.data.active = false;

func reset_all_active() -> void:
	for poke in current_party: poke.data.active = false;

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
		created_party.push_back(Pokemon.new(poke));
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
