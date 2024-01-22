extends Node

class_name Pokemon

var data: Dictionary;

func _init(poke: Dictionary = {}, enemy = false):
	if("name" in poke):
		name = poke.name;
		data = poke;
		data.moves = poke.moves;
		var textures = POKEDEX.get_poke_texture(data.name);
		data.party_texture = textures.party;
		data.front_texture = textures.front;
		data.back_texture = textures.back;
		
		if(enemy):
			data.gender = [0, 1][randi() % 2];
			data.health = 100;
			data.total_hp = 12;
			data.current_hp = 12;
			#data.level = 10;
		else:
			data.gender = poke.gender;
			data.level = poke.level;
			data.health = poke.health;
			data.total_hp = poke.total_hp;
			data.current_hp = poke.current_hp;

