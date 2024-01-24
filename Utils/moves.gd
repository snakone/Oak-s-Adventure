extends Node

enum AttackCategory { PHYSIC, SPECIAL, STATUS, NONE }

func get_move(index: int):
	if(index in moves_list): return moves_list[index];

enum Types {
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISION,
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

var TypesString = {
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

var moves_list: Dictionary = {
	1: {
		"name": "Tackle",
		"type": Types.NORMAL,
		"category": AttackCategory.PHYSIC,
		"power": 40,
		"accuracy": 100,
		"pp": 35,
		"total_pp": 35,
		"effects": []
	},
	2: {
		"name": "Growl",
		"type": Types.DRAGON,
		"category": AttackCategory.STATUS,
		"power": 0,
		"accuracy": 100,
		"pp": 40,
		"total_pp": 40,
		"effects": [
			{
				"apply": func reduce(data: Dictionary) -> float: return data.stats.ATK - (data.stats.ATK / 10); 
			}
		]
	}
}
