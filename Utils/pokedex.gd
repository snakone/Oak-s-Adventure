extends Node

const MISSINGNO = preload("res://Assets/UI/Pokemon/missingno.png");

var pokedex_showcase: Array = [];

func _ready(): add_to_group(GLOBAL.group_name);

func get_showcase() -> Array:
	showcase_check();
	var index = get_showcase_last_index();
	var copy = pokedex_showcase.duplicate(true);
	copy.resize(index);
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
				"sprites": str(poke.sprites),
				"move_set": poke.move_set,
				"display": poke.display,
				"specie": poke.specie
			};

func get_pokemon_prop(index: int, key: String):
	for poke in LIBRARIES.POKEDEX.LIST:
		if(poke.number == index): return poke[key];

func get_showcase_last_index() -> int:
	if(pokedex_showcase.size() == 0): return 0;
	for i in range(pokedex_showcase.size() - 1, -1, -1):
		if(pokedex_showcase[i] != null): return pokedex_showcase[i].number;
	return -1;

func add_pokemon_to_showcase(pokemon = null) -> void:
	if(pokemon != null):
		var last_index = get_showcase_last_index();
		if(last_index == -1): return;
		if(
			int(pokemon.number - 1) in pokedex_showcase && 
			pokedex_showcase[pokemon.number - 1].owned == true
		): return;
		#LOWER - ASSIGN TO CURRENT LIST
		if(last_index >= pokemon.number):
			pokedex_showcase[pokemon.number - 1] = pokemon;
			return;
		#GREATER - CREATE NULLS TILL NEW POKEMON
		for i in range(last_index, pokemon.number - 1): 
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
