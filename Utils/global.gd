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
signal on_tile_map_changed(size: Vector2, camera_offset: Vector2);
signal selection_value_select(value: BinaryOptions, category: SelectionCategory);

signal start_battle(battle_data: Dictionary);
signal close_battle;

signal open_pc();
signal close_pc();

enum Directions { LEFT, RIGHT, UP, DOWN, NONE, ALL }
enum FacingDirection { LEFT, RIGHT, UP, DOWN };
enum Genders { MALE, FEMALE }
enum SaveType { PLAYER, SCENE, PARTY }
enum DoorType { IN, OUT }
enum BinaryOptions { YES, NO }
enum DoorCategory { DOOR, TUNNEL }
enum SelectionCategory { BINARY, HEAL }

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
var last_direction = DIRECTIONS[Directions.DOWN];
var facing_direction = FacingDirection.UP;
var last_used_door: String;
var spawn_location = null;
var camera_connected = false;
var no_saved_data = true;
var play_time: float;

#STATES
var on_transition = false;
var first_spawn = false;
var party_open = false;
var menu_open = false;
var on_bike = false;
var inside_house = false;
var dialog_open = false;
var on_battle = false;
var healing = false;
var on_boxes = false;
var on_pc = false;

#VALUES
var current_money = 0;

const blends = [
	"parameters/Idle/blend_position", 
	'parameters/Move/blend_position', 
	'parameters/Turn/blend_position'];

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

func timeout(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout;

func get_time_played() -> String:
	var time = floor(play_time);
	var hours = time / 3600.0
	var minutes = fmod(time, 3600) / 60
	var seconds = fmod(time, 60)
	var ellapsed = "%02d:%02d:%02d" % [hours, minutes, seconds];
	return ellapsed;

const HAND_POSITIONS = {
	#SELECTION ROW
	Vector2(0, -2): Vector2(104, 2),
	Vector2(1, -2): Vector2(192, 2),
	#BOX ROW
	Vector2(0, -1): Vector2(145, -4),
	Vector2(1, -1): Vector2(145, -4),
	Vector2(2, -1): Vector2(145, -4),
	Vector2(3, -1): Vector2(145, -4),
	Vector2(4, -1): Vector2(145, -4),
	Vector2(5, -1): Vector2(145, -4),
	#FIRST ROW
	Vector2.ZERO: Vector2(84, 20),
	Vector2(1, 0): Vector2(108, 20),
	Vector2(2, 0): Vector2(132, 20),
	Vector2(3, 0): Vector2(156, 20),
	Vector2(4, 0): Vector2(180, 20),
	Vector2(5, 0): Vector2(204, 20),
	#SECOND ROW
	Vector2(0, 1): Vector2(84, 42),
	Vector2(1, 1): Vector2(108, 42),
	Vector2(2, 1): Vector2(132, 42),
	Vector2(3, 1): Vector2(156, 42),
	Vector2(4, 1): Vector2(180, 42),
	Vector2(5, 1): Vector2(204, 42),
	#THIRD ROW
	Vector2(0, 2): Vector2(84, 64),
	Vector2(1, 2): Vector2(108, 64),
	Vector2(2, 2): Vector2(132, 64),
	Vector2(3, 2): Vector2(156, 64),
	Vector2(4, 2): Vector2(180, 64),
	Vector2(5, 2): Vector2(204, 64),
	#FOURTH ROW
	Vector2(0, 3): Vector2(84, 86),
	Vector2(1, 3): Vector2(108, 86),
	Vector2(2, 3): Vector2(132, 86),
	Vector2(3, 3): Vector2(156, 86),
	Vector2(4, 3): Vector2(180, 86),
	Vector2(5, 3): Vector2(204, 86),
	#FIFTH ROW
	Vector2(0, 4): Vector2(84, 108),
	Vector2(1, 4): Vector2(108, 108),
	Vector2(2, 4): Vector2(132, 108),
	Vector2(3, 4): Vector2(156, 108),
	Vector2(4, 4): Vector2(180, 108),
	Vector2(5, 4): Vector2(204, 108),
	#PARTY
	Vector2(6, 0): Vector2(88, 36),
	Vector2(6, 1): Vector2(137, -12),
	Vector2(6, 2): Vector2(137, 12),
	Vector2(6, 3): Vector2(137, 36),
	Vector2(6, 4): Vector2(137, 60),
	Vector2(6, 5): Vector2(137, 84),
	Vector2(6, 6): Vector2(137, 115),
}

var boxes_background = {
	1: {
		"texture": preload("res://Assets/UI/Boxes/box1.png"),
		"name": "BOX 1"
	},
	2: {
		"texture": preload("res://Assets/UI/Boxes/box2.png"),
		"name": "BOX 2"
	},
	3: {
		"texture": preload("res://Assets/UI/Boxes/box3.png"),
		"name": "BOX 3"
	},
	4: {
		"texture": preload("res://Assets/UI/Boxes/box4.png"),
		"name": "BOX 4"
	},
	5: {
		"texture": preload("res://Assets/UI/Boxes/box5.png"),
		"name": "BOX 5"
	},
	6: {
		"texture": preload("res://Assets/UI/Boxes/box6.png"),
		"name": "BOX 6"
	},
	7: {
		"texture": preload("res://Assets/UI/Boxes/box7.png"),
		"name": "BOX 7"
	},
	8: {
		"texture": preload("res://Assets/UI/Boxes/box8.png"),
		"name": "BOX 8"
	},
	9: {
		"texture": preload("res://Assets/UI/Boxes/box9.png"),
		"name": "BOX 9"
	},
	10: {
		"texture": preload("res://Assets/UI/Boxes/box10.png"),
		"name": "BOX 10"
	},
	11: {
		"texture": preload("res://Assets/UI/Boxes/box11.png"),
		"name": "BOX 11"
	},
	12: {
		"texture": preload("res://Assets/UI/Boxes/box12.png"),
		"name": "BOX 12"
	},
	13: {
		"texture": preload("res://Assets/UI/Boxes/box13.png"),
		"name": "BOX 13"
	},
	14: {
		"texture": preload("res://Assets/UI/Boxes/box14.png"),
		"name": "BOX 14"
	},
	15: {
		"texture": preload("res://Assets/UI/Boxes/box15.png"),
		"name": "BOX 15"
	}
}

const BOXES_SLOTS = {
	#FIRST ROW
	0: Vector2.ZERO,
	1: Vector2(24, 0),
	2: Vector2(48, 0),
	3: Vector2(72, 0),
	4: Vector2(96, 0),
	5: Vector2(120, 0),
	#SECOND ROW
	6: Vector2(0, 22),
	7: Vector2(24, 22),
	8: Vector2(48, 22),
	9: Vector2(72, 22),
	10: Vector2(96, 22),
	11: Vector2(120, 22),
	#THRID ROW
	12: Vector2(0, 44),
	13: Vector2(24, 44),
	14: Vector2(48, 44),
	15: Vector2(72, 44),
	16: Vector2(96, 44),
	17: Vector2(120, 44),
	#FOURTH ROW
	18: Vector2(0, 66),
	19: Vector2(24, 66),
	20: Vector2(48, 66),
	21: Vector2(72, 66),
	22: Vector2(96, 66),
	23: Vector2(120, 66),
	#FIFTH ROW
	24: Vector2(0, 88),
	25: Vector2(24, 88),
	26: Vector2(48, 88),
	27: Vector2(72, 88),
	28: Vector2(96, 88),
	29: Vector2(120, 88),
}

var boxes_array = [
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box()
];

func get_empty_box() -> Array:
	var array = [];
	array.resize(30);
	return array.duplicate();
