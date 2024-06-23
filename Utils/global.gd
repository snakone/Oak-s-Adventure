extends Node

signal cant_enter_door;
signal player_moving(value: bool);
signal menu_opened(value: bool);
signal close_menu;
signal scene_opened(value: bool, node_name: String);
signal get_on_bike(value: bool);
signal bike_inside;
signal start_dialog(id: int);
signal close_dialog;
signal create_dialog(text: Array);
signal on_tile_map_changed(size: Vector2, camera_offset: Vector2);
signal selection_value_select(value: ENUMS.BinaryOptions, category: ENUMS.SelectionCategory);
signal visit_panel(map: String, delay: float);

signal start_battle(battle_data: Dictionary);
signal close_battle;

signal pick_item(pickable: Dictionary);

signal open_pc();
signal close_pc();

signal time_of_day_changed(new_time_of_day);

const TILE_SIZE: int = 16;
const WINDOW_SIZE = Vector2(15, 10);
const group_name = "Persist";

const DIRECTIONS: Array = [
	Vector2.LEFT, 
	Vector2.RIGHT, 
	Vector2.UP, 
	Vector2.DOWN, 
	Vector2.ZERO, 
	Vector2.INF
];

var player_data_to_load = null;
var last_direction = DIRECTIONS[ENUMS.Directions.DOWN];
var facing_direction = ENUMS.FacingDirection.UP;
var last_used_door: String;
var spawn_location = null;
var camera_connected = false;
var no_saved_data = true;
var play_time: float;

#STATES
var on_transition = false;
var first_spawn = false;
var menu_open = false;
var on_bike = false;
var inside_house = false;
var dialog_open = false;
var on_battle = false;
var healing = false;
var on_overlay = false;

#VALUES
var current_money = 0;
var current_time_of_day: ENUMS.Climate;

const blends = [
	"parameters/Idle/blend_position", 
	'parameters/Move/blend_position', 
	'parameters/Turn/blend_position'];

func go_to_scene(
	next_scene: String,
	animated = true,
	remove = true
): get_node("/root/SceneManager").transition_to_scene(next_scene, animated, remove);

func need_to_turn(input_direction: Vector2) -> bool:
	var new_facing_direction;
	if(input_direction.x < 0): new_facing_direction = ENUMS.FacingDirection.LEFT
	elif(input_direction.x > 0): new_facing_direction = ENUMS.FacingDirection.RIGHT
	elif(input_direction.y < 0): new_facing_direction = ENUMS.FacingDirection.UP
	elif(input_direction.y > 0): new_facing_direction = ENUMS.FacingDirection.DOWN
	
	if(facing_direction != new_facing_direction):
		facing_direction = new_facing_direction;
		return true;
	return false;

func get_jumping_curvature(
	initial_position: float, 
	new_position: float
) -> float:
	return initial_position + (-0.96 - 0.57 * new_position + 0.05 * pow(new_position, 2));

func timeout(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout;

func get_time_played() -> String:
	var time = floor(play_time);
	var hours = time / 3600.0
	var minutes = fmod(time, 3600) / 60
	var seconds = fmod(time, 60)
	var ellapsed = "%02d:%02d:%02d" % [hours, minutes, seconds];
	return ellapsed;
