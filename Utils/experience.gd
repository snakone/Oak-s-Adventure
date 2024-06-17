extends Node

func get_exp_by_level(exp_type: ENUMS.ExpType, level: float) -> float:
	if(level == 1): return 0.0;
	match exp_type:
		ENUMS.ExpType.ERRATIC: return floor(get_erratic_exp(level));
		ENUMS.ExpType.FAST: return floor(get_fast_exp(level));
		ENUMS.ExpType.MEDIUM: return floor(get_medium_exp(level));
		ENUMS.ExpType.SLOW: return floor(get_slow_exp(level));
		ENUMS.ExpType.SLACK: return floor(get_slack_exp(level));
		ENUMS.ExpType.FLUCTUATING: return floor(get_fluctuating_exp(level));
	return 0.0;

#ERRATIC
func get_erratic_exp(level: float) -> float:
	if(level <= 50.0):
		return float((cubed(level) * (100.0 - level)) / 50.0);
	elif(51.0 <= level && level <= 68.0):
		return float((cubed(level) * (150 - level)) / 100.0);
	elif(69.0 <= level && level <= 98.0):
		return float(cubed(level) * (1.274 - (0.02 * level / 3) - rest(int(level) % 3)));
	elif(99.0 <= level && level <= 100.0):
		return float((cubed(level) * (160.0 - level)) / 100.0);
	return 0.0;

#FAST
func get_fast_exp(level: float) -> float: return cubed(level) * 0.8;

#MEDIUM
func get_medium_exp(level: float) -> float: return cubed(level);

#SLOW
func get_slow_exp(level: float) -> float: return cubed(level) * 1.25;

#SLACK
func get_slack_exp(level: float) -> float:
	return cubed(level) * 1.2 - ((level * level) * 15.0) + (level * 100) - 140;

#FLUCTUATING
func get_fluctuating_exp(level: float) -> float:
	if(level <= 15):
		return (cubed(level) * (24.0 + floor((level + 1.0) / 3.0)) / 50.0);
	elif(16 <= level && level <= 35):
		return (cubed(level) * (14.0 + level) / 50.0);
	elif(36 <= level && level <= 100.0):
		return (cubed(level) * (32.0 + floor(level / 2.0)) / 50.0);
	return 0.0;

func cubed(n) -> float: return n * n * n;

func rest(num) -> float:
	if(num == 0): return num;
	elif(num == 1): return 0.008;
	elif(num == 2): return 0.014;
	return num

func get_exp_for_next_level(
	type: ENUMS.ExpType,
	current_exp: int,
	level: int
) -> int:
	var new_level = level + 1;
	var exp_next_level = floor(get_exp_by_level(type, new_level));
	return floor(exp_next_level - current_exp);

func get_exp_given_by_pokemon(
	enemy: Object,
	battle_type: ENUMS.BattleType,
	participants: int = 1
) -> int:
	var base_exp = POKEDEX.get_pokemon_prop(enemy.data.number, "base_exp");
	var type = 1.0;
	var lucky_egg = 1.0;
	
	match battle_type:
		ENUMS.BattleType.TRAINER, ENUMS.BattleType.SPECIAL, ENUMS.BattleType.ELITE: type = 1.5;
	
	var base = ((base_exp * enemy.data.level) / 7.0);
	return floor(base * (1.0 / float(participants)) * lucky_egg * type);
	
