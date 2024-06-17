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
		"direction": ENUMS.Directions.ALL,
		"marker": true
		},
	3: {
		"arr": [["There are several types of seeds inside."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.DOWN,
		"marker": true
		},
	4: {
		"arr": [
				["Oh, it looks like there's no mail today!"],
				["Maybe I should find a boy to bring me the\nmail sometimes. Yes that's it!"]
			],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
		},
	5: {
		"arr": [
				["Oak's Little Market."],
				["We have the best selection of items."],
				["Don't miss out!"]
			],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
		},
	6: {
		"arr": [["Oak's Farmer House."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
		},
	7: {
		"arr": [["Some of Oak's exclusive items."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
		},
	8: {
		"arr": [["Some Doritos from last night."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
		},
	9: {
		"arr": [
			["My old Gamecube with Twilight Princess."],
			["I love this game!"]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
		},
	10: {
		"arr": [["Do you want to save the game?"]],
		"type": Type.SYSTEM,
		"direction": ENUMS.Directions.NONE,
		"marker": false,
		"selection": {
			"category": ENUMS.SelectionCategory.BINARY,
			"sound": preload("res://Assets/Sounds/confirm.wav")
		},
	},
	11: {
		"arr": [["There is already a saved file. \nIs it okay to overwrite it?"]],
		"type": Type.SYSTEM,
		"direction": ENUMS.Directions.NONE,
		"marker": false,
		"selection": {
			"category": ENUMS.SelectionCategory.BINARY,
			"sound": preload("res://Assets/Sounds/save game.mp3")
		},
	},
	12: {
		"arr": [["Oops! It seems like this door is locked!"]],
		"type": Type.SYSTEM,
		"direction": ENUMS.Directions.NONE,
		"marker": true
	},
	13: {
		"arr": [["I'd better keep this for outside."]],
		"type": Type.SYSTEM,
		"direction": ENUMS.Directions.NONE,
		"marker": true
	},
	14: {
		"arr": [["There's still some coffee left in the cup."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	15: {
		"arr": [["My underwear is already clean."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	16: {
		"arr": [
			["A pair of Genesect Fossils."],
			["Discovered 3000 years ago."],
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	17: {
		"arr": [["South Access to Calderock Village."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	18: {
		"arr": [["Irine's Fountain."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	19: {
		"arr": [
			["Jumping over ledges is so fun!"],
			["self:Mmm I think I should try aswell!"],
			["That's the spirit!"],
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	20: {
		"arr": [
			["Hey Professor!"],
			["Take a look to our last stuff..."]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"npc_name": "Merlin",
		"marker": true
	},
	21: {
		"arr": [
			["Long time no see, Professor."],
			["self:Hey Harold, how are you?"],
			["Fine. I have some news..."],
			["I heard that a strange POKéMON\nhas been seen near the Black Mountain."],
			["self:Mm!? What it can be?"],
			["self:Maybe I should go to investigate."]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"npc_name": "Harold",
		"marker": true
	},
	22: {
		"arr": [
			["I like this fountains a lot! Hehe."],
			["self:Indeed. They are quite relaxing."],
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	23: {
		"arr": [
			["Welcome Sr. Oak"],
			["Do you want to heal your POKéMON?"]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"npc_name": "Joy",
		"marker": true,
		"selection": {
			"category": ENUMS.SelectionCategory.HEAL,
			"sound": preload("res://Assets/Sounds/confirm.wav")
		},
	},
	24: {
		"arr": [["Ok. Just one moment please."]],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
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
		"direction": ENUMS.Directions.ALL,
		"npc_name": "Joy",
		"marker": true
	},
	26: {
		"arr": [
			["Welcome Professor Oak."],
			["Take a look to our items."],
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"npc_name": "Kevin",
		"marker": true
	},
	27: {
		"arr": [["POKéMON related magazines."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	28: {
		"arr": [["I\'m hungry, but I shouldn\'t do this."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	29: {
		"arr": [
			["Calderock Village."],
			["A relaxing place to spend your time."]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	30: {
		"arr": [["Access to Route 02."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	31: {
		"arr": [["Harold\'s House."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	32: {
		"arr": [["You booted up the PC."]],
		"type": Type.PC,
		"marker": true
	},
	33: {
		"arr": [["Which PC should be accessed?"]],
		"type": Type.PC,
		"marker": false
	},
	34: {
		"arr": [["It\'s empty."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	35: {
		"arr": [["It\'s locked. The lock seems very strange."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	36: {
		"arr": [["Music Notes Playground."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	37: {
		"arr": [
			["Accessed Bill\'s PC."],
			["POKéMON Storage System opened."]
		],
		"type": Type.PC,
		"marker": true
	},
	38: {
		"arr": [["Julieta's House."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	39: {
		"arr": [["Route 02 - Calderock Garden."]],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	40: {
		"arr": [
			["There are trainers in this route."],
			["They will encourage you to do a POKéMON\nbattle! Be ready. Kiaaa!!!"]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	41: {
		"arr": [
			["For the trainers out there:"],
			["POKéMON lives in grass. Step on at your own risk."]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	42: {
		"arr": [
			["Bill created the POKéMON storage system."],
			["I just stored my extra POKÉMON on that PC."],
			["Technology is just amazing!"]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	43: {
		"arr": [
			["Hey! Do you know how to use the PC?"],
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": false,
		"selection": {
			"category": ENUMS.SelectionCategory.BINARY,
			"sound": preload("res://Assets/Sounds/confirm.wav"),
			"id": 1,
			"selected": ENUMS.BinaryOptions.NO
		},
		"response": {
			1: {
				ENUMS.BinaryOptions.YES: {"dialog_id": 45},
				ENUMS.BinaryOptions.NO: {"dialog_id": 44}
			}
		} 
	},
	44: {
		"arr": [
			["After you turn on the PC you can select\n3 different options. Let me explain them:"],
			["1. Bill\'s PC: Store and manage your POKéMON."],
			["2. Oak\'s PC: Manage and store your ITEMS."],
			["3. POKéDEX Check: It will evaluate your\nregistered POKéMON. Give it a try!"],
			["self:Alright, thanks for the explanation."]
		],
		"starter": 43,
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true,
		"end": true
	},
	45: {
		"arr": [
			["Okay, I thought older people didn\'t know how\nto use this new technology."],
		],
		"starter": 43,
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true,
		"end": true
	},
	46: {
		"arr": [
			["I could spend all day shoping!"],
			["Even though my boyfriend's wallet is fading\nfast. What can I do? Auww! Sniff.. Sniff.."],
			["self:What the..."]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	47: {
		"arr": [
			["How scary! Why is this in here?"],
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.ALL,
		"marker": true
	},
	48: {
		"arr": [
			["Here's a original copy of \"Catch a Dragon\""],
			["Mmm? A Dragon Trainer!?"]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	49: {
		"arr": [
			["I can see a huge field from here."],
			["What the hell is this place? A hidden\nunderground?"]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	50: {
		"arr": [
			["It looks like an outdoor place. Are we\nreally underground? This is so strange..."]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	51: {
		"arr": [
			["Several books about Dragon POKéMON\nand effectiveness moves. Interesting..."],
			["\"Get the most effectiveness moves\",\n\"Can your Dragon be your friend?\""],
			["Those are some of the titles I found."]
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	52: {
		"arr": [
			["Who are you? The pass is restricted."],
			["self:I\'m Professor Oak, known throughout the region. Can I investigate this place?"],
			["Guess no. You better go back the way you\ncame Professor."]
		],
		"type": Type.NPC,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
	53: {
		"arr": [
			["In honour of Geraint who defened\nCalderock Village long ago."],
		],
		"type": Type.OBJECT,
		"direction": ENUMS.Directions.UP,
		"marker": true
	},
}
