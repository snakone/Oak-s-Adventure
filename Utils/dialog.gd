extends Node

func get_dialog(npc_name: String, location: MAPS.Locations, id = 1) -> Array:
	if(
		npc_name in dialog_library && 
		location in dialog_library[npc_name] &&
		id in dialog_library[npc_name][location]
	): 
		return dialog_library[npc_name][location][id];
	return [];

func check_more_dialogs(npc_name: String, location: MAPS.Locations) -> void:
	var dialogs = dialog_library[npc_name][location];
	if(dialogs.size() >= 2):
		dialog_count[npc_name][location] += 1;
		if(dialogs.size() < dialog_count[npc_name][location]):
			dialog_count[npc_name][location] = 1;

func get_next_dialog(npc_name: String, location: MAPS.Locations, text: Array):
	if(npc_name in dialog_count):
		var count = dialog_count[npc_name][location];
		return get_dialog(npc_name, location, count);
	return text;

var dialog_library: Dictionary = {
	"Gary": {
		MAPS.Locations.ROUTE_00: {
			1: [
				["Hey! how are you?"],
				["self:I'm fine, thanks."]
			]
		}
	},
	"Mom": {
		MAPS.Locations.PRAIRE_TOWN: {
			1: [
				["Today is a great day!"],
				["self:Sure it is!"]
			],
			2: [
				["So are you interested in something very fun?"],
				["self:Mmm I don't know!"]
			]
		}
	},
	"Jar": {
		MAPS.Locations.ROUTE_00: {
			1: [
				["There are several types of seeds inside."],
			]
		}
	},
	"Mail": {
		MAPS.Locations.PRAIRE_TOWN: {
			1: [
				["Oh, it looks like there's no mail today!"],
				["Maybe I should find a boy to bring me the mail."],
			]
		}
	},
	"Banner": {
		MAPS.Locations.PRAIRE_TOWN: {
			1: [
				["Oak's Little Market."],
				["We have the best selection of items."],
				["Don't miss it!"]
			]
		},
		MAPS.Locations.ROUTE_00: {
			1: [
				["Oak's Farmer House."],
			]
		}
	},
	"Box": {
		MAPS.Locations.PRAIRE_TOWN: {
			1: [
				["Some of Oak's exclusive items."],
			]
		}
	},
	"Bin": {
		MAPS.Locations.OAK_HOUSE: {
			1: [
				["Some Doritos from last night."],
			]
		}
	},
	"GameCube": {
		MAPS.Locations.OAK_HOUSE: {
			1: [
				["My old Gamecube with Twilight Princess."],
				["I love this game!"],
			]
		}
	}
}

var dialog_count = {
	"Mom": {
		MAPS.Locations.PRAIRE_TOWN: 1
	},
}
