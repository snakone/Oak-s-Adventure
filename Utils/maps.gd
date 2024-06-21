extends Node

var position_before_scene = Vector2.ZERO;
var spawn_position = Vector2.ZERO;
var last_map;
var npc_shared_list: Array[int] = [];
var must_flip_sprite = false;
var on_shared_scene = false;

func _ready(): add_to_group(GLOBAL.group_name);

func get_map_size_and_emit(tilemap: TileMap) -> Vector2:
	var size = tilemap.get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size, Vector2.ZERO);
	return Vector2(int(size.x * GLOBAL.TILE_SIZE), int(size.y * GLOBAL.TILE_SIZE));

func get_map_name(get_string = false) -> String:
	var current_scene = get_node("/root/SceneManager/CurrentScene");
	var map = current_scene.get_child(0).name;
	if(map in LIBRARIES.MAPS.location_string):
		if(get_string): return map;
		var string: String = LIBRARIES.MAPS.location_string[map];
		return string.to_upper();
	else: return "Mysterious Place";

func get_next_map() -> String:
	if(last_map == null): return "";
	var switch = {
		"Route00": "res://Scenes/Maps/Routes/route_00.tscn",
		"Route01": "res://Scenes/Maps/Routes/route_01.tscn",
		"Route02": "res://Scenes/Maps/Routes/route_02.tscn",
		"PraireTown": "res://Scenes/Maps/Towns/praire_town.tscn",
		"CalderockVillage": "res://Scenes/Maps/Towns/calderock_village.tscn"
	}
	
	return switch[last_map];

func reset_npc_shared_list() -> void: npc_shared_list = [];

#SAVE
func save() -> Dictionary:
	var data = {
		"save_type": ENUMS.SaveType.NPC,
		"path": get_path(),
		"npc_list": npc_shared_list,
		"on_shared_scene": on_shared_scene
	}
	return data;

#LOAD
func load(data: Dictionary) -> void:
	if("npc_list" in data): npc_shared_list.assign(data["npc_list"]);
	if("on_shared_scene" in data): on_shared_scene = data["on_shared_scene"];
