extends Node

func get_dialog(npc_name: String, id: int) -> Array:
	if(npc_name in dialog_library && id in dialog_library[npc_name]): return dialog_library[npc_name][id];
	return [];

var dialog_library: Dictionary = {
	"Gary": {
		1: [
			["Hey! how are you?"],
			#["I was looking for you. I need to tell you something.\n", "Come into my house located right there. It will be very fun."],
			["self:I'm fine, thanks."],
			#["Sure thing. You wont regret it!"]
		]
	},
	"Mom": {
		1: [
			["Today is a great day!"],
			["self:Sure it is!"]
		]
	}
}
