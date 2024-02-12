extends Node

enum DialogType { NPC, OBJECT, SYSTEM, NONE }

func get_dialog(id: int) -> Dictionary:
	if(id in LIBRARY): return LIBRARY[id];
	return { "arr": [[]], "type": DialogType.NONE };

const LIBRARY: Dictionary = {
	1: {
		"arr": [
			["Hey! how are you?"],
			["self:I'm fine, thanks."]
		],
		"npc_name": "Gary",
		"type": DialogType.NPC,
		"marker": true
		},
	2: {
		"arr": [
			["Today is a great day!"],
			["self:Sure it is!"]
		],
		"npc_name": "Mom",
		"type": DialogType.NPC,
		"marker": true
		},
	3: {
		"arr": [["There are several types of seeds inside."]],
		"type": DialogType.OBJECT,
		"marker": true
		},
	4: {
		"arr": [
				["Oh, it looks like there's no mail today!"],
				["Maybe I should find a boy to bring me the mail sometimes."]
			],
		"type": DialogType.OBJECT,
		"marker": true
		},
	5: {
		"arr": [
				["Oak's Little Market."],
				["We have the best selection of items."],
				["Don't miss it!"]
			],
		"type": DialogType.OBJECT,
		"marker": true
		},
	6: {
		"arr": [["Oak's Farmer House."]],
		"type": DialogType.OBJECT,
		"marker": true
		},
	7: {
		"arr": [["Some of Oak's exclusive items."]],
		"type": DialogType.OBJECT,
		"marker": true
		},
	8: {
		"arr": [["Some Doritos from last night."]],
		"type": DialogType.OBJECT,
		"marker": true
		},
	9: {
		"arr": [
			["My old Gamecube with Twilight Princess."],
			["I love this game!"]
		],
		"type": DialogType.OBJECT,
		"marker": true
		},
	10: {
		"arr": [["Do you want to save the game?"]],
		"type": DialogType.SYSTEM,
		"marker": false
	},
	11: {
		"arr": [["There is already a saved file. \nIs it okay to overwrite it?"]],
		"type": DialogType.SYSTEM,
		"marker": false
	},
	12: {
		"arr": [["Oops! It seems like this door is locked!"]],
		"type": DialogType.SYSTEM,
		"marker": true
	},
	13: {
		"arr": [["I'd better keep this for outside."]],
		"type": DialogType.SYSTEM,
		"marker": true
	},
	14: {
		"arr": [["There's still some coffee left in the cup."]],
		"type": DialogType.OBJECT,
		"marker": true
	},
	15: {
		"arr": [["My underwear is already clean."]],
		"type": DialogType.OBJECT,
		"marker": true
	},
	16: {
		"arr": [
			["A pair of Genesect Fossils."],
			["Discovered 3000 years ago."],
		],
		"type": DialogType.OBJECT,
		"marker": true
	},
	17: {
		"arr": [["South Access to Calderock Village."]],
		"type": DialogType.OBJECT,
		"marker": true
	},
	18: {
		"arr": [["Irine's Fountain."]],
		"type": DialogType.OBJECT,
		"marker": true
	},
	19: {
		"arr": [
			["Jumping over ledges is so fun!"],
			["self: Mmm I think I should try aswell!"],
			["That's the spirit!"]
		],
		"type": DialogType.NPC,
		"npc_name": "Scott",
		"marker": true
	},
	20: {
		"arr": [
			["Hey Professor!"],
			["Take a look to our last stuff..."]
		],
		"type": DialogType.NPC,
		"npc_name": "Merlin",
		"marker": true
	},
	21: {
		"arr": [
			["Long time no see, Professor."],
			["self:Hey Harold, how are you?"],
			["I heard that a strange POKéMON have been seen near the Black Mountain."],
			["self:Mm!? What it can be?"],
		],
		"type": DialogType.NPC,
		"npc_name": "Harold",
		"marker": true
	},
	22: {
		"arr": [
			["I like this fountains a lot! Hehe."],
			["self:They are quite relaxing."],
		],
		"type": DialogType.NPC,
		"npc_name": "Daisy",
		"marker": true
	},
}
