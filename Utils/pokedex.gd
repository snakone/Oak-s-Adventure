extends Node

const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

var pokedex_showcase: Array;

func _ready(): 
	add_to_group(GLOBAL.group_name);
	pokedex_showcase = LIBRARIES.POKEDEX.pokedex_showcase.duplicate(true);

func get_showcase() -> Array:
	showcase_check();
	var index = get_showcase_last_index();
	var copy = pokedex_showcase.duplicate(true);
	copy.resize(index + 1);
	return copy;

func get_pokemon(index) -> Variant:
	for poke in LIBRARIES.POKEDEX.LIST:
		if(poke.number == index): return poke.duplicate();
	return null;

func get_pokemon_showcase(index) -> Variant:
	for poke in pokedex_showcase:
		if(poke.number == index): return poke.duplicate();
	return null;

func showcase_check() -> void:
	for i in range(0, pokedex_showcase.size()):
		var poke = pokedex_showcase[i];
		if(poke): 
			if(!poke.seen && !poke.owned): pokedex_showcase[i] = null;
			elif(poke.owned && !poke.seen): pokedex_showcase[i].seen = true;

func get_poke_resources(poke_name: String):
	for poke in LIBRARIES.POKEDEX.LIST:
		if(poke.name == poke_name):
			return {
				"party_texture": poke.party_texture,
				"shout": poke.shout,
				"sprites": str(poke.sprites),
				"offset": poke.offset,
				"scale": poke.scale,
				"move_set": poke.move_set,
				"box_scale": poke.box_scale,
				"box_offset": poke.box_offset
			};

func get_pokemon_prop(index: int, key: String):
	for poke in LIBRARIES.POKEDEX.LIST:
		if(poke.number == index): return poke[key];

func get_showcase_last_index() -> int:
	if(pokedex_showcase.size() == 0): return -1;
	for i in range(pokedex_showcase.size() - 1, -1, -1):
		if(pokedex_showcase[i] != null): return i;
	return -1;

func add_pokemon_to_showcase(pokemon = null) -> void:
	if(pokemon != null):
		var last_index = get_showcase_last_index();
		if(last_index == pokemon.number || last_index == -1): return;
		
		for i in range(last_index + 1, pokemon.number): 
			pokedex_showcase.append(null);
		pokedex_showcase.append(pokemon);

#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.POKEDEX,
		"pokedex_showcase": pokedex_showcase,
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("pokedex_showcase" in data): 
		pokedex_showcase = data["pokedex_showcase"];
