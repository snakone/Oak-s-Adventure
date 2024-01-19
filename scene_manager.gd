extends Node2D

@export_file("*.tscn") var next_scene: String;

@onready var animation_player = $Transition/AnimationPlayer;
@onready var current_scene = $CurrentScene;

const DIALOG_MANAGER = preload("res://Scripts/dialog_manager.tscn");
var dialogue_inst: CanvasLayer;

var should_remove_child: bool;
var last_scene = "res://Scenes/Maps/praire_town.tscn";
var not_save_scenes = ["res://Scenes/UI/save_scene.tscn", "res://Scenes/UI/party_screen.tscn"];

func _ready():
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);

#SCENES
func transition_to_scene(new_scene: String, animated = true, remove = true) -> void:
	next_scene = new_scene;
	should_remove_child = remove;
	if(new_scene not in not_save_scenes): last_scene = new_scene;
	
	if(animated): 
		GLOBAL.on_transition = true;
		animation_player.play("FadeToBlack");
	else: create_new_scene();
	
func on_finish_transition() -> void:
	create_new_scene();
	await get_tree().create_timer(.8).timeout;
	GLOBAL.on_transition = false;

func create_new_scene() -> void:
	if(should_remove_child): current_scene.get_child(0).queue_free();
	var new_node = await load(next_scene).instantiate();
	current_scene.call_deferred("add_child", new_node);

#DIALOGS
func _on_start_dialog(id: int) -> void:
	dialogue_inst = DIALOG_MANAGER.instantiate();
	dialogue_inst.set_data(id);
	call_deferred("add_child", dialogue_inst);
	GLOBAL.dialog_open = true;
	
func _on_close_dialog() -> void:
	dialogue_inst.call_deferred("queue_free");
	GLOBAL.dialog_open = false;

#SAVE
func save() -> Dictionary:
	if(next_scene in not_save_scenes): next_scene = last_scene;
	var data = {
		"save_type": GLOBAL.SaveType.SCENE,
		"path": get_path(),
		"scene": next_scene,
	}
	return data;

#LOAD
func load(data: Dictionary) -> void:
	if(data.scene != ""): transition_to_scene(data.scene);

