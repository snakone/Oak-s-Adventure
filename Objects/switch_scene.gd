extends Area2D

@export_file("*.tscn") var next_scene: String;
@export var enter_direction = GLOBAL.DIRECTIONS.UP;
@export var animated = true;

var can_be_entered = true;
var next_scene_directon: Vector2;

func _ready():
	next_scene_directon = GLOBAL.directions_array[enter_direction];

func _on_body_entered(body):
	check_direction();
	if(can_be_entered && body.name == "Oak"):
		GLOBAL.last_player_direction = next_scene_directon;
		MAPS.position_before_changing_scene = body.position;
		enter_scene();

func check_direction():
	if(next_scene_directon != Vector2.ZERO):
		can_be_entered = next_scene_directon == GLOBAL.last_player_direction;

func enter_scene():
	if(next_scene):
		get_node("/root/SceneManager").transition_to_scene(next_scene, false);


