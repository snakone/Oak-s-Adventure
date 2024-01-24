extends Node

class_name Pokemon

var data: Dictionary;

func _init(poke: Dictionary = {}, enemy = false):
	if("name" in poke):
		name = poke.name;
		data = poke;
		get_resources();
		if(enemy): set_enemy();
		else: set_player(poke);

static func attack(enemy: Object, move: Dictionary) -> bool:
	if(move.pp <= 0): return false;
	enemy.data.health -= 10;
	move.pp -= 1;
	return true;

func set_enemy() -> void:
	data.gender = [0, 1][randi() % 2];
	data.health = 100;
	data.total_hp = 12;
	data.current_hp = 12;
	#data.level = 10;

func set_player(poke: Dictionary) -> void:
	data.gender = poke.gender;
	data.level = poke.level;
	data.health = poke.health;
	data.total_hp = poke.total_hp;
	data.current_hp = poke.current_hp;

func get_resources() -> void:
	var resources = POKEDEX.get_poke_resources(data.name);
	data.party_texture = resources.party_texture;
	data.front_texture = resources.front_texture;
	data.back_texture = resources.back_texture;
	data.shout = resources.shout;

