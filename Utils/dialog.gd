extends Node

func get_dialog(npc_name: String, location: MAPS.Locations, id = 1) -> Array:
	if(
		npc_name in dialog_library && 
		location in dialog_library[npc_name] &&
		id in dialog_library[npc_name][location]
	): 
		return dialog_library[npc_name][location][id];
	return [];

var dialog_library: Dictionary = {
	"Gary": {
		MAPS.Locations.ROUTE_00: {
			1: [
				["Hey! how are you?"],
				["I was looking for you. I need to tell you something.\n", "Come into my house located right there. It will be very fun."],
				["self:I'm fine, thanks."],
				["Sure thing. You wont regret it!"]
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
	"FarmerHouseBanner": {
		MAPS.Locations.ROUTE_00: {
			1: [
				["Oak's Farmer House. Sweet!"],
			]
		}
	}
}
