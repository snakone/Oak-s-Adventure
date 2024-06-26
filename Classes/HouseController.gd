extends Node2D
 # Check for Spawn on Houses only.
class_name HouseController;

@onready var oak = $Oak;
@onready var tilemap = $TileMap;
@export var song: AudioStream;

const NPC_scene = preload("res://Scenes/NPC/npc.tscn");

func _ready():
	set_camera();
	check_npc_spawn();
	GLOBAL.inside_house = true;
	if(song): AUDIO.play(song);
	oak.set_blend_direction(GLOBAL.last_direction);
	
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;

func set_camera() -> void:
	var size: Vector2 = tilemap.get_used_rect().size;
	var diff = GLOBAL.WINDOW_SIZE - size;
	var camera_offset = Vector2.ZERO;
	if(diff > Vector2.ZERO): camera_offset = diff / 2;
	GLOBAL.emit_signal("on_tile_map_changed", size, camera_offset);

func check_npc_spawn() -> void:
	if(MAPS.npc_shared_list.size() > 0):
		for i in MAPS.npc_shared_list:
			var npc = MAPS.NPC_SHARED_MAP[i];
			create_npc(npc);

func create_npc(npc: Dictionary) -> void:
	if(npc && NPC_scene):
		var scene = NPC_scene.instantiate();
		for key in npc.keys():
			scene.set(key, npc[key])
		call_deferred("add_child", scene);
