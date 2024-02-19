extends Node

enum Type { NPC, OBJECT, SYSTEM, PC, NONE }

func get_dialog(id: int) -> Dictionary:
	if(id in LIBRARY): return LIBRARY[id];
	return { "arr": [[]], "type": Type.NONE };

const LIBRARY: Dictionary = {
	1: {
		"arr": [
			["Hey! how are you?"],
			["self:I'm fine, thanks."]
		],
		"npc_name": "Gary",
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
		},
	2: {
		"arr": [
			["Today is a great day!"],
			["self:Sure it is!"]
		],
		"npc_name": "Mom",
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
		},
	3: {
		"arr": [["There are several types of seeds inside."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.DOWN,
		"marker": true
		},
	4: {
		"arr": [
				["Oh, it looks like there's no mail today!"],
				["Maybe I should find a boy to bring me the mail sometimes."]
			],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
		},
	5: {
		"arr": [
				["Oak's Little Market."],
				["We have the best selection of items."],
				["Don't miss it!"]
			],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
		},
	6: {
		"arr": [["Oak's Farmer House."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
		},
	7: {
		"arr": [["Some of Oak's exclusive items."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
		},
	8: {
		"arr": [["Some Doritos from last night."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
		},
	9: {
		"arr": [
			["My old Gamecube with Twilight Princess."],
			["I love this game!"]
		],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
		},
	10: {
		"arr": [["Do you want to save the game?"]],
		"type": Type.SYSTEM,
		"direction": GLOBAL.Directions.NONE,
		"marker": false,
		"selection": {
			"category": GLOBAL.SelectionCategory.BINARY,
			"sound": preload("res://Assets/Sounds/confirm.wav")
		},
	},
	11: {
		"arr": [["There is already a saved file. \nIs it okay to overwrite it?"]],
		"type": Type.SYSTEM,
		"direction": GLOBAL.Directions.NONE,
		"marker": false,
		"selection": {
			"category": GLOBAL.SelectionCategory.BINARY,
			"sound": preload("res://Assets/Sounds/save game.mp3")
		},
	},
	12: {
		"arr": [["Oops! It seems like this door is locked!"]],
		"type": Type.SYSTEM,
		"direction": GLOBAL.Directions.NONE,
		"marker": true
	},
	13: {
		"arr": [["I'd better keep this for outside."]],
		"type": Type.SYSTEM,
		"direction": GLOBAL.Directions.NONE,
		"marker": true
	},
	14: {
		"arr": [["There's still some coffee left in the cup."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
	},
	15: {
		"arr": [["My underwear is already clean."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	16: {
		"arr": [
			["A pair of Genesect Fossils."],
			["Discovered 3000 years ago."],
		],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	17: {
		"arr": [["South Access to Calderock Village."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	18: {
		"arr": [["Irine's Fountain."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	19: {
		"arr": [
			["Jumping over ledges is so fun!"],
			["self: Mmm I think I should try aswell!"],
			["That's the spirit!"]
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Scott",
		"marker": true
	},
	20: {
		"arr": [
			["Hey Professor!"],
			["Take a look to our last stuff..."]
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Merlin",
		"marker": true
	},
	21: {
		"arr": [
			["Long time no see, Professor."],
			["self:Hey Harold, how are you?"],
			["A strange POKéMON have been seen near the Black Mountain."],
			["self:Mm!? What it can be?"],
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Harold",
		"marker": true
	},
	22: {
		"arr": [
			["I like this fountains a lot! Hehe."],
			["self:They are quite relaxing."],
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Daisy",
		"marker": true
	},
	23: {
		"arr": [
			["Welcome Sr. Oak"],
			["Do you want to heal your POKéMON?"]
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Joy",
		"marker": true,
		"selection": {
			"category": GLOBAL.SelectionCategory.HEAL,
			"sound": preload("res://Assets/Sounds/confirm.wav")
		},
	},
	24: {
		"arr": [
			["Ok. Just one moment please."]
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Joy",
		"marker": false
	},
	25: {
		"arr": [
			["Thanks for your patience."],
			["Your POKéMON have fully health now."],
			["Hope to see you again soon."]
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Joy",
		"marker": true
	},
	26: {
		"arr": [
			["Welcome Professor Oak."],
			["Take a look to our items."],
		],
		"type": Type.NPC,
		"direction": GLOBAL.Directions.ALL,
		"npc_name": "Kevin",
		"marker": true
	},
	27: {
		"arr": [["POKéMON related magazines."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	28: {
		"arr": [["I\'m hungry, but I shouldn\'t do this."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	29: {
		"arr": [
			["Calderock Village."],
			["A relaxing place to spend your time."]
		],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	30: {
		"arr": [["Access to Route 02."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	31: {
		"arr": [["Harold\'s House."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	32: {
		"arr": [
			["You booted up the PC."]
		],
		"type": Type.PC,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	33: {
		"arr": [
			["Which PC should be accessed?"]
		],
		"type": Type.PC,
		"direction": GLOBAL.Directions.UP,
		"marker": false
	},
	34: {
		"arr": [["It\'s empty."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.ALL,
		"marker": true
	},
	35: {
		"arr": [["It\'s locked. The lock seems very strange."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	36: {
		"arr": [["Music Notes Playground."]],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
	37: {
		"arr": [
			["Accessed Bill\'s PC."],
			["POKéMON Storage System opened."]
			],
		"type": Type.OBJECT,
		"direction": GLOBAL.Directions.UP,
		"marker": true
	},
}
