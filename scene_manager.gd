extends Node2D

@onready var animation_player = $Transition/AnimationPlayer;
@onready var current_scene = $CurrentScene;

var next_scene: String;

func transition_to_scene(new_scene: String, animated: bool):
	next_scene = new_scene;
	if(animated): 
		GLOBAL.on_transition = true;
		animation_player.play("FadeToBlack");
	else: create_new_scene()
	
func create_new_scene():
	current_scene.get_child(0).queue_free();
	var new_node = await load(next_scene).instantiate();
	current_scene.call_deferred("add_child", new_node);

func on_finish_transition() -> void:
	create_new_scene();
	await get_tree().create_timer(.8).timeout;
	GLOBAL.on_transition = false;
