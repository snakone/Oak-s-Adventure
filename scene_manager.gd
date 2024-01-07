extends Node2D

@onready var animation_player = $Transition/AnimationPlayer;
@onready var current_scene = $CurrentScene;

var next_scene: String;

func _ready():
	pass # Replace with function body.
	
func transition_to_scene(new_scene: String):
	next_scene = new_scene;
	animation_player.play("FadeToBlack");

func on_finish_transition() -> void:
	GLOBAL.on_transition = true;
	current_scene.get_child(0).queue_free();
	var new_node = await load(next_scene).instantiate();
	current_scene.add_child(new_node)
	emit_new_tilemap_size(new_node);
	await get_tree().create_timer(.6).timeout;
	GLOBAL.on_transition = false;
	
func emit_new_tilemap_size(scene: Node2D) -> void:
	#Make sure the map it's called "TileMap"
	var size: Vector2 = scene.get_node("TileMap").get_used_rect().size;
	GLOBAL.emit_signal("on_tile_map_changed", size);
