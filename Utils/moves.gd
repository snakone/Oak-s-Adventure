extends Node

enum AttackCategory { PHYSIC, SPECIAL, STATUS, NONE }

func get_move(index: int):
	if(index in moves_list): return moves_list[index];

var moves_list: Dictionary = {
	1: {
		"name": "Tackle",
		"type": POKEDEX.Types.NORMAL,
		"category": AttackCategory.PHYSIC,
		"power": 40,
		"accuracy": 100,
		"pp": 35,
		"effects": []
	},
	2: {
		"name": "Growl",
		"type": POKEDEX.Types.NORMAL,
		"category": AttackCategory.STATUS,
		"power": 0,
		"accuracy": 100,
		"pp": 40,
		"effects": [
			{
				"apply": func reduce(data: Dictionary) -> float: return data.stats.ATK - (data.stats.ATK / 10); 
			}
		]
	}
}
