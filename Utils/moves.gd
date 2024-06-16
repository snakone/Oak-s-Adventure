extends Node

enum AttackCategory { PHYSIC, SPECIAL, STATUS, NONE }

func get_move(index: int):
	if(index in LIBRARY): return LIBRARY[index];

func load_move_with_pp(move: Dictionary):
	var move_data = get_move(move.id).duplicate();
	move_data.pp = move.pp;
	return move_data;

func get_type_sprite(type: Types) -> Variant:
	if(type in sprites_types):
		return sprites_types[type];
	return null;

enum Types {
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISON,
	GROUND,
	FLYING,
	PSYCHIC,
	BUG,
	ROCK,
	GHOST,
	DRAGON,
	DARK,
	STEEL,
	FAIRY
}

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

var LIBRARY: Dictionary = {
	1: {
		"id": 1,
		"name": "Tackle",
		"type": Types.NORMAL,
		"category": AttackCategory.PHYSIC,
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
		"type": Types.NORMAL,
		"category": AttackCategory.STATUS,
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
		"type": Types.NORMAL,
		"category": AttackCategory.PHYSIC,
		"power": 30,
		"accuracy": 100,
		"pp": 30,
		"total_pp": 30,
		"effects": [],
		"priority": 1,
		"description": "An almost invisibly fast attack that is certain to strike first."
	}
}

func type_effective(atk_type: Types, def_type: Types) -> float:
	match atk_type:
		Types.NORMAL:
			match def_type:
				Types.ROCK, Types.STEEL: return 0.5;
				Types.GHOST: return 0.0;
				_: return 1.0;
		Types.FIRE:
			match def_type:
				Types.GRASS, Types.ICE, Types.BUG, Types.STEEL: return 2.0;
				Types.FIRE, Types.WATER, Types.ROCK, Types.DRAGON: return 0.5;
				_: return 1.0;
		Types.WATER:
			match def_type:
				Types.FIRE, Types.GROUND, Types.ROCK: return 2.0;
				Types.WATER, Types.GRASS, Types.DRAGON: return 0.5;
				_: return 1.0;
		Types.GRASS:
			match def_type:
				Types.WATER, Types.GROUND, Types.ROCK: return 2.0;
				Types.FIRE, Types.GRASS, Types.POISON, Types.FLYING, Types.BUG, Types.DRAGON, Types.STEEL: return 0.5;
				_: return 1.0;
		Types.ELECTRIC:
			match def_type:
				Types.WATER, Types.FLYING: return 2.0;
				Types.GRASS, Types.ELECTRIC, Types.DRAGON: return 0.5;
				Types.GROUND: return 0.0;
				_: return 1.0;
		Types.ICE:
			match def_type:
				Types.GRASS, Types.GROUND, Types.FLYING, Types.DRAGON: return 2.0;
				Types.FIRE, Types.WATER, Types.ICE, Types.STEEL: return 0.5;
				_: return 1.0;
		Types.FIGHTING:
			match def_type:
				Types.NORMAL, Types.ICE, Types.ROCK, Types.DARK, Types.STEEL : return 2.0;
				Types.POISON, Types.FLYING, Types.PSYCHIC, Types.BUG, Types.FAIRY : return 0.5;
				Types.GHOST: return 0.0;
				_: return 1.0;
		Types.POISON:
			match def_type:
				Types.GRASS, Types.POISON: return 2.0;
				Types.POISON, Types.GROUND, Types.ROCK, Types.GHOST: return 0.5;
				Types.STEEL: return 0.0;
				_: return 1.0;
		Types.GROUND:
			match def_type:
				Types.POISON, Types.ROCK, Types.STEEL, Types.FIRE, Types.ELECTRIC: return 2.0;
				Types.BUG, Types.GRASS: return 0.5;
				Types.FLYING: return 0.0
				_: return 1.0;
		Types.FLYING:
			match def_type:
				Types.FIGHTING, Types.BUG, Types.GRASS: return 2.0;
				Types.ROCK, Types.STEEL, Types.ELECTRIC: return 0.5;
				_: return 1.0;
		Types.PSYCHIC:
			match def_type:
				Types.FIGHTING, Types.POISON: return 2.0;
				Types.PSYCHIC, Types.STEEL: return 0.5;
				Types.DARK: return 0.0;
				_: return 1.0;
		Types.BUG:
			match def_type:
				Types.GRASS, Types.PSYCHIC, Types.DARK: return 2.0;
				Types.FIRE, Types.FIGHTING, Types.POISON, Types.FLYING, Types.GHOST, Types.STEEL, Types.FAIRY: return 0.5;
				_: return 1.0;
		Types.ROCK:
			match def_type:
				Types.FIRE, Types.ICE, Types.FLYING, Types.BUG: return 2.0;
				Types.FIGHTING, Types.GROUND, Types.STEEL: return 0.5;
				_: return 1.0;
		Types.GHOST:
			match def_type:
				Types.PSYCHIC, Types.GHOST: return 2.0;
				Types.DARK: return 0.5;
				Types.NORMAL: return 0.0
				_: return 1.0;
		Types.DRAGON:
			match def_type:
				Types.DRAGON: return 2.0;
				Types.STEEL: return 0.5;
				Types.FAIRY: return 0.0;
				_: return 1.0;
		Types.DARK:
			match def_type:
				Types.PSYCHIC, Types.GHOST: return 2.0;
				Types.FIGHTING, Types.DARK, Types.FAIRY: return 0.5;
				_: return 1.0;
		Types.STEEL:
			match def_type:
				Types.ICE, Types.ROCK, Types.FAIRY: return 2.0;
				Types.FIRE, Types.WATER, Types.ELECTRIC, Types.STEEL: return 0.5;
				_: return 1.0;
		Types.FAIRY:
			match def_type:
				Types.FIGHTING, Types.DRAGON, Types.DARK: return 2.0;
				Types.FIRE, Types.POISON, Types.STEEL: return 0.5;
				_: return 1.0;
	return 1.0;

enum MoveNames {
	TACKLE,
	QUICK_ATTACK
}

const MOVE_ANIMATION = {
	MoveNames.TACKLE: {
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
	MoveNames.QUICK_ATTACK: {
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

@onready var sprites_types = {
	Types.NORMAL: load("res://Assets/UI/Types/normal.png"),
	Types.FIRE: load("res://Assets/UI/Types/fire.png"),
	Types.WATER: load("res://Assets/UI/Types/water.png"),
	Types.GRASS: load("res://Assets/UI/Types/grass.png"),
	Types.ELECTRIC: load("res://Assets/UI/Types/electric.png"),
	Types.ICE: load("res://Assets/UI/Types/ice.png"),
	Types.FIGHTING: load("res://Assets/UI/Types/fight.png"),
	Types.POISON: load("res://Assets/UI/Types/poison.png"),
	Types.GROUND: load("res://Assets/UI/Types/ground.png"),
	Types.FLYING: load("res://Assets/UI/Types/flying.png"),
	Types.PSYCHIC: load("res://Assets/UI/Types/psychic.png"),
	Types.BUG: load("res://Assets/UI/Types/bug.png"),
	Types.ROCK: load("res://Assets/UI/Types/rock.png"),
	Types.GHOST: load("res://Assets/UI/Types/ghost.png"),
	Types.DRAGON: load("res://Assets/UI/Types/dragon.png"),
	Types.DARK: load("res://Assets/UI/Types/dark.png"),
	Types.STEEL: load("res://Assets/UI/Types/steel.png"),
}
