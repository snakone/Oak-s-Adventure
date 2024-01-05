extends CharacterBody2D

const SPEED = 4.0;
const TILE_SIZE = 16;

signal player_moving

@onready var animation_tree = $AnimationTree;
@onready var playback = animation_tree.get("parameters/playback");
@onready var block_ray_cast_2d = $BlockRayCast2D

enum PlayerState { IDLE, TURNING, WALKING };

var player_utils = preload("res://Utils/player_utils.gd").new()
var player_state = PlayerState.IDLE;

var input_direction = Vector2()
var start_position = Vector2(0, -1);

var blends = ["parameters/Idle/blend_position", 
			  'parameters/Move/blend_position', 
			  'parameters/Turn/blend_position'];

var is_moving = false;
var percent_to_next_tile = 0;

func _ready():
	start_position = position;

func _physics_process(delta) -> void:
	if(player_state == PlayerState.TURNING):
		return
	elif(is_moving == false):
		process_player_input();
	elif(input_direction != Vector2.ZERO):
		playback.travel("Move");
		move(delta);
	else:
		playback.travel("Idle");
		is_moving = false;

func process_player_input() -> void:
	check_wrong_direction()

	if(input_direction != Vector2.ZERO):
		for path in blends: animation_tree.set(path, input_direction);

		if(player_utils.need_to_turn(input_direction)):
			player_state = PlayerState.TURNING;
			playback.travel("Turn");
		else:
			start_position = position;
			is_moving = true;
	else: 
		playback.travel("Idle")

func move(delta) -> void:
	percent_to_next_tile += SPEED * delta;
	check_ray();

	if(!block_ray_cast_2d.is_colliding()):
		if(percent_to_next_tile >= 1.0):
			position = start_position + (TILE_SIZE * input_direction)
			reset_moving()
		else:
			emit_signal("player_moving")
			position = start_position + (floor(TILE_SIZE * input_direction * percent_to_next_tile));
	else: reset_moving()

func check_ray() -> void:
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2;
	block_ray_cast_2d.target_position = desired_step;
	block_ray_cast_2d.force_raycast_update();

func check_wrong_direction() -> void:
	var right_or_left = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"));
	var up_or_down = int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"));
	if(input_direction.y == 0): input_direction.x = right_or_left;
	if(input_direction.x == 0): input_direction.y = up_or_down;

func finished_turning() -> void:
	player_state = PlayerState.IDLE;

func reset_moving() -> void:
	is_moving = false;
	percent_to_next_tile = 0;

