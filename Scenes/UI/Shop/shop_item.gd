extends Control

func set_data(data: Dictionary) -> void:
	get_node("Name").text = data.name;
	if("shop" in data):
		get_node("Price").text = '$ ' + str(data.shop.price);
