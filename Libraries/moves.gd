extends Node

const TYPES = {
	1: "Type/NORMA.",
	2: "Type/FIRE",
	3: "Type/WATER",
	4: "Type/GRASS",
	5: "Type/ELECT.",
	6: "Type/ICE",
	7: "Type/FIGHT.",
	8: "Type/POISO.",
	9: "Type/GORUN.",
	10: "Type/FLYIN.",
	11: "Type/PSYCH.",
	12: "Type/BUG",
	13: "Type/ROCK",
	14: "Type/GHOST",
	15: "Type/DRAGO.",
	16: "Type/DARK",
	17: "Type/STEEL",
	18: "Type/FAIRY"
}

var LIST: Dictionary = {
	1: {
		"id": 1,
		"name": "Tackle",
		"type": ENUMS.Types.NORMAL,
		"category": ENUMS.AttackCategory.PHYSIC,
		"power": 35.0,
		"accuracy": 100,
		"pp": 35,
		"total_pp": 35,
		"effects": [],
		"priority": 0,
		"description": "A physical attack in which the user charges, full body, into the foe."
	},
	2: {
		"id": 2,
		"name": "Growl",
		"type": ENUMS.Types.NORMAL,
		"category": ENUMS.AttackCategory.STATUS,
		"power": 0,
		"accuracy": 100,
		"pp": 40,
		"total_pp": 40,
		"priority": 0,
		"effects": [
			{
				"apply": func set(enemy: Dictionary): enemy.data.battle_stages["ATK"] -= 1; 
			}
		],
		"description": ""
	},
	3: {
		"id": 3,
		"name": "Quick Attack",
		"type": ENUMS.Types.NORMAL,
		"category": ENUMS.AttackCategory.PHYSIC,
		"power": 30,
		"accuracy": 100,
		"pp": 30,
		"total_pp": 30,
		"effects": [],
		"priority": 1,
		"description": "An almost invisibly fast attack that is certain to strike first."
	}
}

func type_effective(atk_type: ENUMS.Types, def_type: ENUMS.Types) -> float:
	match atk_type:
		ENUMS.Types.NORMAL:
			match def_type:
				ENUMS.Types.ROCK, ENUMS.Types.STEEL: return 0.5;
				ENUMS.Types.GHOST: return 0.0;
				_: return 1.0;
		ENUMS.Types.FIRE:
			match def_type:
				ENUMS.Types.GRASS, ENUMS.Types.ICE, ENUMS.Types.BUG, ENUMS.Types.STEEL: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.WATER, ENUMS.Types.ROCK, ENUMS.Types.DRAGON: return 0.5;
				_: return 1.0;
		ENUMS.Types.WATER:
			match def_type:
				ENUMS.Types.FIRE, ENUMS.Types.GROUND, ENUMS.Types.ROCK: return 2.0;
				ENUMS.Types.WATER, ENUMS.Types.GRASS, ENUMS.Types.DRAGON: return 0.5;
				_: return 1.0;
		ENUMS.Types.GRASS:
			match def_type:
				ENUMS.Types.WATER, ENUMS.Types.GROUND, ENUMS.Types.ROCK: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.GRASS, ENUMS.Types.POISON, ENUMS.Types.FLYING, ENUMS.Types.BUG, ENUMS.Types.DRAGON, ENUMS.Types.STEEL: return 0.5;
				_: return 1.0;
		ENUMS.Types.ELECTRIC:
			match def_type:
				ENUMS.Types.WATER, ENUMS.Types.FLYING: return 2.0;
				ENUMS.Types.GRASS, ENUMS.Types.ELECTRIC, ENUMS.Types.DRAGON: return 0.5;
				ENUMS.Types.GROUND: return 0.0;
				_: return 1.0;
		ENUMS.Types.ICE:
			match def_type:
				ENUMS.Types.GRASS, ENUMS.Types.GROUND, ENUMS.Types.FLYING, ENUMS.Types.DRAGON: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.WATER, ENUMS.Types.ICE, ENUMS.Types.STEEL: return 0.5;
				_: return 1.0;
		ENUMS.Types.FIGHTING:
			match def_type:
				ENUMS.Types.NORMAL, ENUMS.Types.ICE, ENUMS.Types.ROCK, ENUMS.Types.DARK, ENUMS.Types.STEEL : return 2.0;
				ENUMS.Types.POISON, ENUMS.Types.FLYING, ENUMS.Types.PSYCHIC, ENUMS.Types.BUG, ENUMS.Types.FAIRY : return 0.5;
				ENUMS.Types.GHOST: return 0.0;
				_: return 1.0;
		ENUMS.Types.POISON:
			match def_type:
				ENUMS.Types.GRASS, ENUMS.Types.POISON: return 2.0;
				ENUMS.Types.POISON, ENUMS.Types.GROUND, ENUMS.Types.ROCK, ENUMS.Types.GHOST: return 0.5;
				ENUMS.Types.STEEL: return 0.0;
				_: return 1.0;
		ENUMS.Types.GROUND:
			match def_type:
				ENUMS.Types.POISON, ENUMS.Types.ROCK, ENUMS.Types.STEEL, ENUMS.Types.FIRE, ENUMS.Types.ELECTRIC: return 2.0;
				ENUMS.Types.BUG, ENUMS.Types.GRASS: return 0.5;
				ENUMS.Types.FLYING: return 0.0
				_: return 1.0;
		ENUMS.Types.FLYING:
			match def_type:
				ENUMS.Types.FIGHTING, ENUMS.Types.BUG, ENUMS.Types.GRASS: return 2.0;
				ENUMS.Types.ROCK, ENUMS.Types.STEEL, ENUMS.Types.ELECTRIC: return 0.5;
				_: return 1.0;
		ENUMS.Types.PSYCHIC:
			match def_type:
				ENUMS.Types.FIGHTING, ENUMS.Types.POISON: return 2.0;
				ENUMS.Types.PSYCHIC, ENUMS.Types.STEEL: return 0.5;
				ENUMS.Types.DARK: return 0.0;
				_: return 1.0;
		ENUMS.Types.BUG:
			match def_type:
				ENUMS.Types.GRASS, ENUMS.Types.PSYCHIC, ENUMS.Types.DARK: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.FIGHTING, ENUMS.Types.POISON, ENUMS.Types.FLYING, ENUMS.Types.GHOST, ENUMS.Types.STEEL, ENUMS.Types.FAIRY: return 0.5;
				_: return 1.0;
		ENUMS.Types.ROCK:
			match def_type:
				ENUMS.Types.FIRE, ENUMS.Types.ICE, ENUMS.Types.FLYING, ENUMS.Types.BUG: return 2.0;
				ENUMS.Types.FIGHTING, ENUMS.Types.GROUND, ENUMS.Types.STEEL: return 0.5;
				_: return 1.0;
		ENUMS.Types.GHOST:
			match def_type:
				ENUMS.Types.PSYCHIC, ENUMS.Types.GHOST: return 2.0;
				ENUMS.Types.DARK: return 0.5;
				ENUMS.Types.NORMAL: return 0.0
				_: return 1.0;
		ENUMS.Types.DRAGON:
			match def_type:
				ENUMS.Types.DRAGON: return 2.0;
				ENUMS.Types.STEEL: return 0.5;
				ENUMS.Types.FAIRY: return 0.0;
				_: return 1.0;
		ENUMS.Types.DARK:
			match def_type:
				ENUMS.Types.PSYCHIC, ENUMS.Types.GHOST: return 2.0;
				ENUMS.Types.FIGHTING, ENUMS.Types.DARK, ENUMS.Types.FAIRY: return 0.5;
				_: return 1.0;
		ENUMS.Types.STEEL:
			match def_type:
				ENUMS.Types.ICE, ENUMS.Types.ROCK, ENUMS.Types.FAIRY: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.WATER, ENUMS.Types.ELECTRIC, ENUMS.Types.STEEL: return 0.5;
				_: return 1.0;
		ENUMS.Types.FAIRY:
			match def_type:
				ENUMS.Types.FIGHTING, ENUMS.Types.DRAGON, ENUMS.Types.DARK: return 2.0;
				ENUMS.Types.FIRE, ENUMS.Types.POISON, ENUMS.Types.STEEL: return 0.5;
				_: return 1.0;
	return 1.0;

var MOVE_ANIMATION = {
	ENUMS.MoveNames.TACKLE: {
		"property": "position",
		"values": {
			"player": [
				{ "value": Vector2(-5, 0), "duration": 0.15 },
				{ "value": Vector2.ZERO, "duration": 0.11 },
				{ "value": Vector2(12, 0), "duration": 0.1 },
				{ "value": Vector2(18, 0), "duration": 0.1 },
				{ "value": Vector2(15, 0), "duration": 0.1 },
				{ "value": Vector2.ZERO, "duration": 0.2 }
			],
			"enemy": [
				{ "value": Vector2(5, 0), "duration": 0.15 },
				{ "value": Vector2.ZERO, "duration": 0.11 },
				{ "value": Vector2(-12, 0), "duration": 0.1 },
				{ "value": Vector2(-18, 0), "duration": 0.1 },
				{ "value": Vector2(-15, 0), "duration": 0.1 },
				{ "value": Vector2.ZERO, "duration": 0.2 }
			]
		}
	},
	ENUMS.MoveNames.QUICK_ATTACK: {
		"property": "position",
		"values": {
			"player": [
				{ "value": Vector2(-5, 0), "duration": 0.15 },
				{ "value": Vector2(-20, 0), "duration": 0.11 },
				{ "value": Vector2(-120, 0), "duration": 0.2 },
				{ "value": Vector2(-150, 0), "duration": 0.1 },
				{ "value": Vector2.ZERO, "duration": 0.2 },
			],
			"enemy": [
				{ "value": Vector2(5, 0), "duration": 0.15 },
				{ "value": Vector2(20, 0), "duration": 0.11 },
				{ "value": Vector2(120, 0), "duration": 0.2 },
				{ "value": Vector2(150, 0), "duration": 0.1 },
				{ "value": Vector2.ZERO, "duration": 0.2 },
			]
		}
	}
}

var sprites_types = {
	ENUMS.Types.NORMAL: preload("res://Assets/UI/Types/normal.png"),
	ENUMS.Types.FIRE: preload("res://Assets/UI/Types/fire.png"),
	ENUMS.Types.WATER: preload("res://Assets/UI/Types/water.png"),
	ENUMS.Types.GRASS: preload("res://Assets/UI/Types/grass.png"),
	ENUMS.Types.ELECTRIC: preload("res://Assets/UI/Types/electric.png"),
	ENUMS.Types.ICE: preload("res://Assets/UI/Types/ice.png"),
	ENUMS.Types.FIGHTING: preload("res://Assets/UI/Types/fight.png"),
	ENUMS.Types.POISON: preload("res://Assets/UI/Types/poison.png"),
	ENUMS.Types.GROUND: preload("res://Assets/UI/Types/ground.png"),
	ENUMS.Types.FLYING: preload("res://Assets/UI/Types/flying.png"),
	ENUMS.Types.PSYCHIC: preload("res://Assets/UI/Types/psychic.png"),
	ENUMS.Types.BUG: preload("res://Assets/UI/Types/bug.png"),
	ENUMS.Types.ROCK: preload("res://Assets/UI/Types/rock.png"),
	ENUMS.Types.GHOST: preload("res://Assets/UI/Types/ghost.png"),
	ENUMS.Types.DRAGON: preload("res://Assets/UI/Types/dragon.png"),
	ENUMS.Types.DARK: preload("res://Assets/UI/Types/dark.png"),
	ENUMS.Types.STEEL: preload("res://Assets/UI/Types/steel.png"),
}
