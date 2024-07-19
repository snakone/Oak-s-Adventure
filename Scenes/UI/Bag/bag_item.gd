extends Control

func set_data(data: Dictionary) -> void:
	get_node("Name").text = data.name;
	if("amount" in data && data.type != ENUMS.BagScreen.KEY):
		get_node("Amount").text = "x " + str(data.amount);
