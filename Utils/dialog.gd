extends Node

enum DialogType { NPC, OBJECT, SYSTEM }

func get_dialog(id: int) -> Dictionary:
	if(id in dialog_library): return dialog_library[id];
	return {"arr": [[]]};

var dialog_library: Dictionary = {
	1: {
		"arr": [["Hey! how are you?"],["self:I'm fine, thanks."]],
		"npc_name": "Gary",
		"type": DialogType.NPC
		},
	2: {
		"arr": [["Today is a great day!"],["self:Sure it is!"]],
		"npc_name": "Mom",
		"type": DialogType.NPC
		},
	3: {
		"arr": [["There are several types of seeds inside."]],
		"type": DialogType.OBJECT
		},
	4: {
		"arr": [
				["Oh, it looks like there's no mail today!"],
				["Maybe I should find a boy to bring me the mail."]
			],
		"type": DialogType.OBJECT
		},
	5: {
		"arr": [
				["Oak's Little Market."],
				["We have the best selection of items."],
				["Don't miss it!"]
			],
		"type": DialogType.OBJECT
		},
	6: {
		"arr": [["Oak's Farmer House."]],
		"type": DialogType.OBJECT
		},
	7: {
		"arr": [["Some of Oak's exclusive items."]],
		"type": DialogType.OBJECT
		},
	8: {
		"arr": [["Some Doritos from last night."]],
		"type": DialogType.OBJECT
		},
	9: {
		"arr": [["My old Gamecube with Twilight Princess."], ["I love this game!"]],
		"type": DialogType.OBJECT
		},
	10: {
		"arr": [["Do you want to save the game?"]],
		"type": DialogType.SYSTEM
	},
}
