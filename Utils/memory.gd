extends Node

func _save() -> void:
	var save_file = FileAccess.open("save.poke", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if !node.has_method("save"):
			print("Node '%s' is missing a save function, skipped" % node.name)
		else: 
			var node_data = node.call("save")
			save_file.store_line(JSON.stringify(node_data))
		
	save_file.close();

func _load() -> void:
	if !FileAccess.file_exists("save.poke"):
		print("Error, no Save File to load.")
		return
	var save_file = FileAccess.open("save.poke", FileAccess.READ)

	while save_file.get_position() < save_file.get_length():
		var json = JSON.new()
		json.parse(save_file.get_line())
		var node_data = json.get_data();
		if(node_data.has("path") && has_node(node_data["path"])):
			get_node(node_data["path"]).load(node_data);
		elif(node_data.has("player")):GLOBAL.player_data_to_load = node_data;
	save_file.close();
	
func _ready():
	await get_tree().create_timer(3).timeout;
	_load();
