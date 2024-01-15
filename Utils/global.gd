extends Node

signal cant_enter_door;
signal player_moving(value: bool);
signal menu_opened(value: bool);
signal party_opened(value: bool);
signal get_on_bike(value: bool);
signal start_dialog(text: Array, self_name: String, npc_name: String)
signal close_dialog;
signal on_tile_map_changed(size: Vector2, camera_offset: Vector2);

enum DIRECTIONS {LEFT, RIGHT, UP, DOWN, NONE}
enum FacingDirection { LEFT, RIGHT, UP, DOWN };
enum Genders { MALE, FEMALE }
enum SaveType { PLAYER, SCENE }
enum DoorType { IN, OUT }

var player_data_to_load = null;

const directions_array: Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1), Vector2.ZERO];
const TILE_SIZE: int = 16;
const WINDOW_SIZE = Vector2(15, 10);

var last_player_direction = directions_array[DIRECTIONS.DOWN];
var on_transition = false;
var facing_direction = FacingDirection.UP;
var last_used_door: String;
var spawn_location = null;
var first_spawn = false;
var camera_connected = false;

var party_open = false;
var menu_open = false;
var on_bike = false;
var inside_house = false;
var dialog_open = false;

var blends = [
	"parameters/Idle/blend_position", 
	'parameters/Move/blend_position', 
	'parameters/Turn/blend_position'];

var walk: Dictionary = {
	"UP": Vector2(0, -1),
	"RIGHT": Vector2(1, 0),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1, 0)
}

func need_to_turn(input_direction: Vector2) -> bool:
	var new_facing_direction;
	if(input_direction.x < 0): new_facing_direction = FacingDirection.LEFT
	elif(input_direction.x > 0): new_facing_direction = FacingDirection.RIGHT
	elif(input_direction.y < 0): new_facing_direction = FacingDirection.UP
	elif(input_direction.y > 0): new_facing_direction = FacingDirection.DOWN
	
	if(facing_direction != new_facing_direction):
		facing_direction = new_facing_direction;
		return true;
	return false;

func get_jumping_curvature(
	initial_position: float, 
	new_position: float
) -> float:
	return initial_position + (-0.96 - 0.57 * new_position + 0.05 * pow(new_position, 2));
