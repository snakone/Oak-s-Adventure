extends Area2D

@export_file("*.tscn") var next_scene: String;
@export var enter_direction = GLOBAL.DIRECTIONS.UP;
@export var spawn_position = Vector2.ZERO;
@export var animated = true;
@onready var animation_player = $AnimationPlayer;

var can_be_opened = true;
var door_open_directon: Vector2;

func _ready():
	door_open_directon = GLOBAL.directions_array[enter_direction];

func _on_body_entered(body) -> void:
	check_direction();
	if(can_be_opened && body.name == "Oak"):
		MAPS.spawn_position = spawn_position;
		if(animated): animation_player.play("Open");
		else: enter_house();

func check_direction() -> void:
	if(door_open_directon != Vector2.ZERO):
		can_be_opened = door_open_directon == GLOBAL.last_player_direction;

func enter_house() -> void:
	if(next_scene):
		get_node("/root/SceneManager").transition_to_scene(next_scene, true);