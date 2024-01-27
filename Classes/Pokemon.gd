extends Node

class_name Pokemon

var data: Dictionary;

func _init(poke: Dictionary = {}, enemy = false, levels = [1, 100]):
	if("name" in poke):
		name = poke.name;
		data = poke;
		data.death = false;
		get_stats();
		get_resources();
		if("IV" not in data): data.IV = get_random_IV();
		if(enemy): data.level = randi_range(levels[0], levels[1]);
		if("battle_stats" not in data): calculate_stats();
		if(enemy): set_enemy();
		data.battle_stages = create_battle_stages();
		if("battle_moves" not in data): create_battle_moves();
		else: convert_battle_moves();

#ATTACK
func attack(enemy: Object, move: Dictionary) -> bool:
	if(move.pp <= 0): return false;
	if(enemy.data.current_hp <= 0): enemy.data.death = true;
	move.pp -= 1;

	match move.category:
		MOVES.AttackCategory.PHYSIC, MOVES.AttackCategory.SPECIAL:
			var damage = damage_formula(enemy, move);
			print("DMG: ", damage)
			enemy.data.current_hp = max(0, enemy.data.current_hp - damage);
	return true;

func set_enemy() -> void:
	data.gender = [0, 1][randi() % 2];
	data.current_hp = data.battle_stats["HP"];

func get_random_IV() -> Dictionary:
	randomize();
	var iv_list = {
		"HP": randi() % 32,
		"ATK": randi() % 32,
		"DEF": randi() % 32,
		"S.ATK": randi() % 32,
		"S.DEF": randi() % 32,
		"SPD": randi() % 32,
	}	
	return iv_list;

func get_stats() -> void: data.stats = POKEDEX.get_pokemon_stats(name);

func get_resources() -> void:
	var resources = POKEDEX.get_poke_resources(data.name);
	data.party_texture = resources.party_texture;
	data.front_texture = resources.front_texture;
	data.back_texture = resources.back_texture;
	data.shout = resources.shout;

func create_battle_moves() -> void:
	var array = [];
	for move in data.moves:
		array.push_back(MOVES.get_move(move).duplicate());
	data.battle_moves = array;

func convert_battle_moves() -> void:
	var array = [];
	for move in data.battle_moves:
		array.push_back(MOVES.load_move_with_pp(move).duplicate());
	data.battle_moves = array;

func calculate_stats() -> void:
	data.battle_stats = {};
	for key in data.IV.keys():
		var value = data.IV[key];
		var stat_base = data.stats[key];
		var nature = 1.0;
		if(key != "HP"): data.battle_stats[key] = stat_formula(stat_base, value, nature);
		elif(key == "HP"): data.battle_stats[key] = health_formula(stat_base, value);

func stat_formula(
	base: int,
	iv_value: int,
	nature: float
) -> int:
	return floor((((((2 * base) + iv_value) * data.level) / 100) + 5) * nature);

func health_formula(base: int, iv_value: int) -> int:
	return floor(((((2 * base) + iv_value) * data.level) / 100) + data.level + 10);

func damage_formula(
	enemy: Object,
	move: Dictionary,
) -> int:
	var ATK_stat: int;
	var DEF_stat: int;
	#var ATK_bonus = 0;
	#var DEF_bonus = 0;
	var CRIT_rate: float = get_critical_chance(0);
	var CRIT_stat = 1.0;
	var STAB: float = 1.0;
	var burned = 1;
	var effective_type1 = 1.0;
	var effective_type2 = 1.0;
	var not_effective = false;
	if(CRIT_rate > randf()):
		#DEF_bonus = 0;
		print("CRIT!!")
		CRIT_stat = 2.0;
		

	if(move.type in data.types): STAB = 1.5;
	match move.category:
		MOVES.AttackCategory.PHYSIC:
			ATK_stat = data.battle_stats["ATK"];
			DEF_stat = enemy.data.battle_stats["DEF"];
		MOVES.AttackCategory.SPECIAL:
			ATK_stat = data.battle_stats["S.ATK"];
			DEF_stat = enemy.data.battle_stats["S.DEF"];
			
	effective_type1 = MOVES.type_effective(move.type, enemy.data.types[0]);
	if (enemy.data.types.size() > 1):
		effective_type2 = MOVES.type_effective(move.type, enemy.data.types[1]);
	
	if(effective_type1 == 0.0 || effective_type2 == 0.0): not_effective = true;
	
	var base_damage = floor(
			((2.0 * float(data.level) / 5.0 + 2.0) * 
				move.power * float(ATK_stat) / float(DEF_stat) / 50.0
		) * burned + 2.0);
		
	var random: float = get_random_float();
	var damage = (base_damage * CRIT_stat * STAB * effective_type1 * effective_type2 * random);
	return custom_round(damage, random);
	
func get_random_float() -> float:
	var modifier = 0.99;
	if(data.level < 50.0): modifier = 1;
	var num_steps = int((modifier - 0.85) / 0.01) + 1.0
	var random_index = randi_range(0, num_steps - 1.0)
	var random_float = 0.85 + random_index * 0.01;
	return random_float;

func custom_round(number, random_float):
	var integer_part = int(number)
	var decimal_part = number - integer_part
	if 0.5 <= decimal_part and decimal_part <= 0.59 and random_float != 1:
		return floor(number)
	else:
		return round(number)

func get_critical_chance(stage: int) -> float:
	var critical_stages = [1.0/16.0, 1.0/8.0, 1.0/4.0 ,1.0/3.0 ,1.0/2.0];
	return critical_stages[stage];

func create_battle_stages() -> Dictionary:
	return {
		"ATK": 0,
		"DEF": 0,
		"S.ATK": 0,
		"S.DEF": 0,
		"SPD": 0,
		"EVASION": 0,
		"ACCURACY": 0
	}
