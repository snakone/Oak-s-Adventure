extends Node

const DEFAULT_CRITICAL = 0;

#STATS
func stat_formula(
	base: int,
	iv_value: int,
	nature: float,
	level: float
) -> int:
	return floor((((((2 * base) + iv_value) * level) / 100) + 5) * nature);

#HEALTH
func health_formula(base: int, iv_value: int, level: float) -> int:
	return floor(((((2 * base) + iv_value) * level) / 100) + level + 10);

#DAMAGE FORMULA
func damage_formula(enemy: Object, move: Dictionary, data: Dictionary) -> int:
	var ATK_stat: int;
	var DEF_stat: int;
	var _ATK_bonus = 0;
	var _DEF_bonus = 0;
	var CRIT_rate: float = get_critical_chance(DEFAULT_CRITICAL);
	var CRIT_stat = 1.0;
	var STAB: float = 1.0;
	var burned = 1;
	var effective_type1 = 1.0;
	var effective_type2 = 1.0;
		
		#EFFECTIVE
	effective_type1 = LIBRARIES.MOVES.type_effective(move.type, enemy.data.types[0]);
	if (enemy.data.types.size() > 1):
		effective_type2 = LIBRARIES.MOVES.type_effective(move.type, enemy.data.types[1]);
		
	#RESULT
	if(
		(effective_type1 == 2.0 && effective_type2 == 1.0) || 
		(effective_type2 == 2.0 && effective_type1 == 1.0)
	): BATTLE.attack_result.push_back(ENUMS.AttackResult.EFFECTIVE);
	elif(
		(effective_type1 == 0.5 && effective_type2 == 1.0) || 
		(effective_type2 == 0.5 && effective_type1 == 1.0)
	): BATTLE.attack_result.push_back(ENUMS.AttackResult.LOW);
	elif(effective_type1 == 2.0 && effective_type2 == 2.0):
		BATTLE.attack_result.push_back(ENUMS.AttackResult.FULMINATE);
	elif(effective_type1 == 0.5 && effective_type2 == 0.5): 
		BATTLE.attack_result.push_back(ENUMS.AttackResult.AWFULL);
	elif(effective_type1 == 0.0 || effective_type2 == 0.0):
		BATTLE.attack_result = [ENUMS.AttackResult.NONE];
		
	#MISS
	if(ENUMS.AttackResult.MISS in BATTLE.attack_result && 
		ENUMS.AttackResult.NONE not in BATTLE.attack_result):
			BATTLE.attack_result = [ENUMS.AttackResult.MISS];
			return 0;
		
	if(ENUMS.AttackResult.NONE in BATTLE.attack_result): return 0;
		
	#CRITICAL
	if(CRIT_rate > randf()):
		_DEF_bonus = 0;
		BATTLE.critical_hit = true;
		BATTLE.attack_result.push_back(ENUMS.AttackResult.CRITICAL);
		CRIT_stat = 2.0;
		
	#STAB
	if(move.type in data.types): STAB = 1.5;
		
	#STATS
	match move.category:
		ENUMS.AttackCategory.PHYSIC:
			ATK_stat = data.battle_stats["ATK"];
			DEF_stat = enemy.data.battle_stats["DEF"];
		ENUMS.AttackCategory.SPECIAL:
			ATK_stat = data.battle_stats["S.ATK"];
			DEF_stat = enemy.data.battle_stats["S.DEF"];
			
		
	var base_damage = floor(
			((2.0 * float(data.level) / 5.0 + 2.0) * 
				move.power * float(ATK_stat) / float(DEF_stat) / 50.0
		) * burned + 2.0);
		
	var random: float = get_random_float(data.level);
	var total_base = base_damage * CRIT_stat * STAB;
	var damage = (total_base * effective_type1 * effective_type2 * random);
	if(BATTLE.attack_result.size() == 0): 
		BATTLE.attack_result = [ENUMS.AttackResult.NORMAL];
	return custom_round(damage, random);

func get_critical_chance(stage: int) -> float:
	var critical_stages = [1.0/16.0, 1.0/8.0, 1.0/4.0 ,1.0/3.0 ,1.0/2.0, 1.0/1.0];
	return critical_stages[stage];

func custom_round(number, random_float) -> int:
	var integer_part = int(number);
	var decimal_part = number - integer_part;
	if 0.5 <= decimal_part and decimal_part <= 0.59 and random_float != 1.0:
		return floor(number);
	else:
		return round(number);

func get_random_float(level: int) -> float:
	var modifier = 0.99;
	if(level < 50.0): modifier = 1;
	var num_steps = int((modifier - 0.85) / 0.01)
	var random_index = randi_range(0, num_steps);
	var random_float = 0.85 + random_index * 0.01;
	return random_float;

func get_nature_multiplier(nature: ENUMS.Nature, key: String) -> float:
	if(key in nature_multiplier[nature]): 
		return nature_multiplier[nature][key];
	return 1.0;

var nature_multiplier = {
	ENUMS.Nature.ADAMANT: {
		"ATK": 1.1,
		"S.ATK": 0.9
	},
	ENUMS.Nature.BASHFUL: {
		"S.ATK": 1.0
	},
	ENUMS.Nature.BOLD: {
		"DEF": 1.1,
		"ATK": 0.9
	},
	ENUMS.Nature.BRAVE: {
		"ATK": 1.1,
		"SPD": 0.9
	},
	ENUMS.Nature.CALM: {
		"S.DEF": 1.1,
		"ATK": 0.9
	},
	ENUMS.Nature.CAREFUL: {
		"S.DEF": 1.1,
		"S.ATK": 0.9
	},
	ENUMS.Nature.DOCILE: {
		"DEF": 1.0
	},
	ENUMS.Nature.GENTLE: {
		"S.DEF": 1.1,
		"DEF": 0.9
	},
	ENUMS.Nature.HARDY: {
		"ATK": 1.0
	},
	ENUMS.Nature.HASTY: {
		"SPD": 1.1,
		"DEF": 0.9
	},
	ENUMS.Nature.IMPISH: {
		"DEF": 1.1,
		"S.ATK": 0.9
	},
	ENUMS.Nature.JOLLY: {
		"SPD": 1.1,
		"S.ATK": 0.9
	},
	ENUMS.Nature.LAX: {
		"DEF": 1.1,
		"S.DEF": 0.9
	},
	ENUMS.Nature.LONELY: {
		"ATK": 1.1,
		"DEF": 0.9
	},
	ENUMS.Nature.MILD: {
		"S.ATK": 1.1,
		"DEF": 0.9
	},
	ENUMS.Nature.MODEST: {
		"S.ATK": 1.1,
		"ATK": 0.9
	},
	ENUMS.Nature.NAIVE: {
		"SPD": 1.1,
		"S.DEF": 0.9
	},
	ENUMS.Nature.NAUGHTY: {
		"ATK": 1.1,
		"S.DEF": 0.9
	},
	ENUMS.Nature.QUIET: {
		"S.ATK": 1.1,
		"SPD": 0.9
	},
	ENUMS.Nature.QUIRKY: {
		"S.DEF": 1.0
	},
	ENUMS.Nature.RASH: {
		"S.ATK": 1.1,
		"S.DEF": 0.9
	},
	ENUMS.Nature.RELAXED: {
		"DEF": 1.1,
		"SPD": 0.9
	},
	ENUMS.Nature.SASSY: {
		"S.DEF": 1.1,
		"SPD": 0.9
	},
	ENUMS.Nature.SERIOUS: {
		"SPD": 1.0
	},
	ENUMS.Nature.TIMID: {
		"SPD": 1.1,
		"ATK": 0.9
	}
}
