extends Control

func set_data(data: Dictionary) -> void:
	get_node("Number").text = data.number;
	get_node("Control/Owned").visible = data.owned;
	get_node("Name").text = data.name;
	get_node("Types/Type1").texture = data.type1_texture;
	get_node("Types/Type2").texture = data.type2_texture;
