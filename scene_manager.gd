extends Node2D

@onready var animation_player = $Transition/AnimationPlayer;
@onready var current_scene = $CurrentScene;

@export_file("*.tscn") var next_scene: String;
var should_remove_child: bool;
var last_scene: String;

func transition_to_scene(new_scene: String, animated = true, remove = true):
	next_scene = new_scene;
	should_remove_child = remove;
	if(new_scene.find("party_screen") == -1): last_scene = new_scene;
	
	if(animated): 
		GLOBAL.on_transition = true;
		animation_player.play("FadeToBlack");
	else: create_new_scene();
	
func on_finish_transition() -> void:
	create_new_scene();
	await get_tree().create_timer(.8).timeout;
	GLOBAL.on_transition = false;

func create_new_scene():
	if(should_remove_child): current_scene.get_child(0).queue_free();
	var new_node = await load(next_scene).instantiate();
	current_scene.call_deferred("add_child", new_node);

func save() -> Dictionary:
	if(next_scene.find("party_screen") != -1):
		next_scene = last_scene;
	var data = {
		"save_type": GLOBAL.SaveType.SCENE,
		"path": get_path(),
		"scene": next_scene,
	}
	return data;
	
func load(data: Dictionary):
	if(data.scene != ""): transition_to_scene(data.scene);
