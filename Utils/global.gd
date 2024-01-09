extends Node

signal on_tile_map_changed(size: Vector2, camera_offset: Vector2);
signal player_moving(value: bool);
signal cant_enter_door;
signal menu_opened(value: bool);

enum DIRECTIONS {LEFT, RIGHT, UP, DOWN, NONE}
const directions_array: Array = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1), Vector2.ZERO]

var last_player_direction = directions_array[DIRECTIONS.NONE];
var on_transition = false;

enum FacingDirection { LEFT, RIGHT, UP, DOWN };
var facing_direction = FacingDirection.UP;
const TILE_SIZE: int = 16;
const WINDOW_SIZE = Vector2(15, 10);

var spawn_location = null;
var first_spawn = false;

var camera_connected = false;

func need_to_turn(input_direction: Vector2) -> bool:
	var new_facing_direction;
	if(input_direction.x < 0):
		new_facing_direction = FacingDirection.LEFT
	elif(input_direction.x > 0):
		new_facing_direction = FacingDirection.RIGHT
	elif(input_direction.y < 0):
		new_facing_direction = FacingDirection.UP
	elif(input_direction.y > 0):
		new_facing_direction = FacingDirection.DOWN
		
	if(facing_direction != new_facing_direction):
		facing_direction = new_facing_direction;
		return true;
	return false;
	

func get_jumping_curvature(
	initial_position: float, 
	new_position: float
) -> float:
	return initial_position + (-0.96 - 0.57 * new_position + 0.05 * pow(new_position, 2));
