extends Node

class_name Pokemon

var data: Dictionary;
var uuid = preload("res://uuid.gd").new();

#CONSTRUCTOR
func _init(poke: Dictionary = {}, enemy = false, levels = [1, 100], for_battle = true):
	if("name" in poke):
		name = poke.name;
		data = poke;
		#EXTRA PROPS
		get_extra_props();
		#ASSETS
		get_resources();
		#CHECK IF POKEMON IS DISPLAY ONLY OR BATTLE
		if(!for_battle): return;
		#GENERAL
		get_base_stats();
		data.active = false;
		if("death" not in data): data.death = false;
		if("IV" not in data): data.IV = set_random_IV();
		if("uuid" not in data): data.uuid = uuid.v4();
		#ENEMY
		if(enemy):
			if(levels.size() == 1): levels.push_front(levels[0]);
			data.level = randi_range(levels[0], levels[1]);
		#BATTLE
		if("battle_stats" not in data): set_battle_stats();
		if("status" not in data): set_battle_status();
		data.battle_stages = set_battle_stages();
		if("battle_moves" not in data): set_battle_moves();
		else: convert_battle_moves();
		if(enemy): set_enemy();
		#EXP
		if("total_exp" not in data): set_exp_by_level();
		if(data.current_hp == 0): data.death = true;
		data.current_hp = min(data.current_hp, data.battle_stats["HP"]);

#ATTACK
func attack(enemy: Object, move: Dictionary) -> Dictionary:
	BATTLE.attack_result = [];
	if(move.pp <= 0): return {
		"ok": false,
		"reason": "Not enough PP",
		"damage": 0
	};
	
	move.pp -= 1;
	if(float(move.accuracy) / 100 < randf()):
		BATTLE.attack_result.push_back(ENUMS.AttackResult.MISS);
		
	match move.category:
		ENUMS.AttackCategory.PHYSIC, ENUMS.AttackCategory.SPECIAL:
			var amount = LIBRARIES.FORMULAS.damage_formula(enemy, move, data);
			var damage = min(amount, enemy.data.current_hp);
			set_hp_anim_duration(damage, enemy);
			enemy.data.current_hp = max(0, enemy.data.current_hp - damage);
			if(enemy.data.current_hp <= 0): enemy.bye();
			return {
				"ok": true,
				"reason": "Attack Success",
				"damage": damage
			};
	return {
		"ok": false,
		"reason": "Unknown",
		"damage": 0
	}

#ACTIONS
func level_up() -> Dictionary:
	data.level = min(data.level + 1, 100);
	var old_battle_stats = data.battle_stats;
	set_battle_stats();
	var hp_difference = data.battle_stats["HP"] - old_battle_stats["HP"];
	data.current_hp += hp_difference;
	
	return {
		"HP": hp_difference,
		"ATK": data.battle_stats["ATK"] - old_battle_stats["ATK"],
		"DEF": data.battle_stats["DEF"] - old_battle_stats["DEF"],
		"S.ATK": data.battle_stats["S.ATK"] - old_battle_stats["S.ATK"],
		"S.DEF": data.battle_stats["S.DEF"] - old_battle_stats["S.DEF"],
		"SPD": data.battle_stats["SPD"] - old_battle_stats["SPD"],
	}

func learn_move(id: int) -> void:
	data.moves.push_back(id);
	var new_move = MOVES.get_move(id).duplicate();
	new_move.pp = new_move.total_pp;
	data.battle_moves.push_back(new_move);

func create_moves() -> Array:
	var new_moves = [];
	for move in data.battle_moves.duplicate():
		new_moves.push_back({
			"name": move.name,
			"pp": move.pp,
			"id": move.id
		})
	return new_moves;

#DIE
func bye() -> void:
	data.death = true;
	data.current_hp = 0;
	data.active = false;

#ENEMY
func set_enemy() -> void:
	match data.category:
		ENUMS.PokemonCategory.NORMAL, ENUMS.PokemonCategory.STARTER:
			data.gender = [0, 1][randi() % 2];
	data.current_hp = data.battle_stats["HP"];

#BATTLE STATS
func set_battle_stats() -> void:
	data.battle_stats = {};
	for key in data.IV.keys():
		var value = data.IV[key];
		var stat_base = data.stats[key];
		var nature = LIBRARIES.FORMULAS.get_nature_multiplier(data.nature, key);
		if(key != "HP"):
			var stat = LIBRARIES.FORMULAS.stat_formula(stat_base, value, nature, data.level);
			data.battle_stats[key] = stat;
		elif(key == "HP"):
			var stat = LIBRARIES.FORMULAS.health_formula(stat_base, value, data.level);
			data.battle_stats[key] = stat;

func set_battle_status() -> void:
	data.status = {};
	data.status["current"] = ENUMS.PokemonStatus.NONE;
	data.status["can_scape"] = true;
	data.status["protect_critical"] = false;
	data.status["in_pinch"] = false;
	data.status["can_lower_stats"] = {
		"all": true,
		"ATK": true,
		"accuracy": true
	};
	data.status["charmed"] = false;
	data.status["self_destruction"] = true;
	data.status["awake_fast"] = false;
	data.status["contact"] = {
		"burn": false,
		"paralysis": false,
		"sleep": false,
		"poison": false
	};
	data.status["on_status"] = false;
	data.status["inmune"] = {
		"poison": false,
		"sleep": false,
		"ground": false,
		"paralysis": false,
		"frozen": false,
		"confused": false,
		"charm": false,
		"recoil": false,
		"sound": false,
		"ko": false
	}
	data.status["add_effect"] = false;
	data.status["block_effect"] = false;
	data.status["can_switch"] = true;
	data.status["wonder"] = false;

#IV
func set_random_IV() -> Dictionary:
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

#MOVES
func set_battle_moves() -> void:
	var array = [];
	for move in data.moves:
		array.push_back(MOVES.get_move(move).duplicate());
	data.battle_moves = array;

#HP ANIM
func set_hp_anim_duration(damage: int, enemy: Object) -> void:
	var total = BATTLE.MIN_HP_ANIM;
	if(damage < 2): total = 0.3;
	elif(damage < 20 && damage != 1 && enemy.data.level > 50): total = 0.5;
	elif(
		(damage < 10 && damage != 1 && enemy.data.level < 30) || 
		(damage < 10 && damage >= 3)): total = 0.6; 

	elif(damage >= 30 && enemy.data.battle_stats["HP"] <= 30): total = 1.0;
	print("HP BAR DURATION: ", total * 1.1);
	BATTLE.emit_signal("hp_bar_anim_duration", total * 1.1);

func get_extra_props() -> void:
	if("exp_type" not in data): 
		data.exp_type = POKEDEX.get_pokemon_prop(data.number, 'exp_type');
	if("types" not in data):
		data.types = POKEDEX.get_pokemon_prop(data.number, 'types');
	if("nature" not in data): data.nature = get_random_nature();
	if("held_item" not in data): data.held_item = null;
	if("ability" not in data):
		data.ability = POKEDEX.get_pokemon_prop(data.number, 'ability').default;
	elif(data.ability is Dictionary && "default" in data.ability):
		data.ability = data.ability.default;

#BASE STATS
func get_base_stats() -> void:
	data.stats = POKEDEX.get_pokemon_prop(data.number, "stats");

func get_random_nature() -> ENUMS.Nature:
	var keys = ENUMS.Nature.keys();
	var index = randi() % keys.size();
	return ENUMS.Nature[keys[index]];

#RESOURCES
func get_resources() -> void:
	var resources = POKEDEX.get_poke_resources(data.name);
	data.move_set = resources.move_set;
	data.display = resources.display;
	data.specie = resources.specie;
	data.search = resources.search;
	
	if("sprites" in resources && resources.sprites.begins_with("res://")):
		var animated_sprite = load(resources.sprites);
		if(animated_sprite != null):
			data.sprites = animated_sprite.instantiate();

func convert_battle_moves() -> void:
	var array = [];
	for move in data.battle_moves:
		array.push_back(MOVES.load_move_with_pp(move).duplicate());
	data.battle_moves = array;

#EXP
func set_exp_by_level() -> void:
	var total_exp = EXP.get_exp_by_level(data.exp_type, data.level);
	data.total_exp = floor(total_exp);

func get_exp_to_next_level() -> int:
	var exp_till_next = EXP.get_exp_for_next_level(data);
	return exp_till_next;

func get_exp_by_level() -> int:
	var exp_by_level = EXP.get_exp_by_level(data.exp_type, data.level);
	return exp_by_level;

func set_battle_stages() -> Dictionary:
	return {
		"ATK": 0,
		"DEF": 0,
		"S.ATK": 0,
		"S.DEF": 0,
		"SPD": 0,
		"EVASION": 0,
		"ACCURACY": 0
	}
