extends Area2D

@export_file("*.tscn") var next_scene: String;
@export var enter_direction = ENUMS.Directions.UP;
@export var new_map: ENUMS.Locations;

var can_be_entered = false;
var next_scene_directon: Vector2;

func _ready():
	next_scene_directon = GLOBAL.DIRECTIONS[enter_direction];

func _on_body_entered(body):
	check_direction();
	if(can_be_entered && body.name == "Oak"):
		MAPS.position_before_scene = body.position;
		GLOBAL.last_direction = next_scene_directon;
		MAPS.last_map = MAPS.get_map_name(true);
		enter_scene();

func check_direction():
	if(next_scene_directon != Vector2.ZERO):
		can_be_entered = next_scene_directon == GLOBAL.last_direction;

func enter_scene():
	if(next_scene):
		get_node("/root/SceneManager").transition_to_scene(next_scene, false);
