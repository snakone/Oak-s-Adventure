extends Control

func set_data(data: Dictionary) -> void:
	get_node("Name").text = data.name;
	get_node("Amount").text = "x   " + str(data.amount);
