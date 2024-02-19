extends Node2D

@export_file("*.tscn") var next_scene: String;

@onready var anim_player = $Transition/AnimationPlayer;
@onready var current_scene = $CurrentScene;

const BATTLE_SCENE = preload("res://Scenes/Battle/battle_scene.tscn")
const DIALOG_MANAGER = preload("res://Scripts/dialog_manager.tscn");
const PC_SCENE = preload("res://Scenes/UI/pc_player.tscn");

const not_save_scenes = [
	"res://Scenes/UI/save_scene.tscn", 
	"res://Scenes/UI/party_screen.tscn",
	"res://Scenes/UI/profile.tscn",
	"res://Scenes/UI/pokemon_boxes.tscn"
	];


var dialogue_inst: CanvasLayer;
var battle_inst: CanvasLayer;
var pc_inst: CanvasLayer;

var last_scene = "res://Scenes/Maps/praire_town.tscn";
var should_remove_child: bool;

func _ready():
	listen_to_signals();

#SCENES
func transition_to_scene(
	new_scene: String,
	animated = true,
	remove = true
) -> void:
	next_scene = new_scene;
	should_remove_child = remove;
	if(new_scene not in not_save_scenes): last_scene = new_scene;
	
	if(animated): 
		GLOBAL.on_transition = true;
		anim_player.play("FadeToBlack");
	else: create_new_scene();
	
func on_finish_transition() -> void:
	create_new_scene();
	await GLOBAL.timeout(0.8);
	GLOBAL.on_transition = false;

func create_new_scene() -> void:
	if(should_remove_child): current_scene.get_child(0).queue_free();
	var new_node = await load(next_scene).instantiate();
	current_scene.call_deferred("add_child", new_node);

#DIALOGS
func _on_start_dialog(id: int) -> void:
	if(dialogue_inst != null): _on_close_dialog();
	dialogue_inst = DIALOG_MANAGER.instantiate();
	dialogue_inst.set_data(id);
	GLOBAL.dialog_open = true;
	call_deferred("add_child", dialogue_inst);

func _on_close_dialog() -> void:
	GLOBAL.dialog_open = false;
	dialogue_inst.call_deferred("queue_free");

#PC
func _on_open_pc() -> void:
	if(pc_inst != null): _on_close_pc();
	pc_inst = PC_SCENE.instantiate();
	GLOBAL.dialog_open = true;
	call_deferred("add_child", pc_inst);

func _on_close_pc() -> void:
	_on_close_dialog();
	pc_inst.call_deferred("queue_free");

#BATTLE
func _on_start_battle(battle_data: Dictionary):
	GLOBAL.on_battle = true;
	battle_inst = BATTLE_SCENE.instantiate();
	battle_inst.set_battle_data(battle_data);
	anim_player.play("StartBattle");
	
func _on_end_battle() -> void:
	GLOBAL.on_battle = false;
	battle_inst.call_deferred("queue_free");

func go_battle(): call_deferred("add_child", battle_inst);

#SAVE
func save() -> Dictionary:
	if(next_scene in not_save_scenes): next_scene = last_scene;
	var data = {
		"save_type": GLOBAL.SaveType.SCENE,
		"path": get_path(),
		"scene": next_scene,
		"last_map": MAPS.last_map
	}
	return data;

#LOAD
func load(data: Dictionary) -> void:
	if(data.scene != ""): transition_to_scene(data.scene, true, false);
	if("last_map" in data): MAPS.last_map = data.last_map;
	
func listen_to_signals() -> void:
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);
	GLOBAL.connect("start_battle", _on_start_battle);
	GLOBAL.connect("close_battle", _on_end_battle);
	GLOBAL.connect("open_pc", _on_open_pc);
	GLOBAL.connect("close_pc", _on_close_pc);

