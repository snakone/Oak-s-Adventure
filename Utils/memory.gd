extends Node

const save_path = "user://save.poke";

func _save() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group(GLOBAL.group_name);
	for node in save_nodes:
		if !node.has_method("save"):
			print("Node '%s' is missing a save function, skipped" % node.name)
		else: 
			var node_data = node.call("save")
			save_file.store_line(JSON.stringify(node_data))
	save_file.close();

func _load() -> void:
	if !FileAccess.file_exists(save_path):
		print("Error, no Save File to load.");
		GLOBAL.no_saved_data = true;
		return;
		
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json = JSON.new();
		json.parse(save_file.get_line())
		var node_data = json.get_data();
		if(node_data.has("path") && has_node(node_data["path"])):
			get_node(node_data["path"]).load(node_data);
		elif(node_data.has("player")):GLOBAL.player_data_to_load = node_data;
	GLOBAL.no_saved_data = false;
	save_file.close();
	
func _ready():
	await GLOBAL.timeout(1);
	_load();
