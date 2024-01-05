extends CharacterBody2D

const SPEED = 4;
const TILE_SIZE = 16;
signal player_moving;

@onready var animation_tree = $AnimationTree;
@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var ledge_ray_cast_2d = $LedgeRayCast2D;
@onready var shadow = $Shadow;
@onready var dust_effect = $DustEffect;
@onready var playback = animation_tree.get("parameters/playback");
@onready var rays = [block_ray_cast_2d, ledge_ray_cast_2d];
var player_utils = preload("res://Utils/player_utils.gd").new()

enum PlayerState { IDLE, TURNING, WALKING };
var player_state = PlayerState.IDLE;
var input_direction = Vector2()
var start_position = Vector2(0, -1);
var jumping_over_ledge = false;
var is_moving: bool = false;
var percent_moved: float = 0;

var blends = ["parameters/Idle/blend_position", 
			  'parameters/Move/blend_position', 
			  'parameters/Turn/blend_position'];

func _ready():
	start_position = position;

func _physics_process(delta) -> void:
	if(player_state == PlayerState.TURNING): return;
	elif(is_moving == false): process_player_input();
	elif(input_direction != Vector2.ZERO):
		playback.travel("Move");
		move(delta);
	else:
		playback.travel("Idle");
		is_moving = false;

func process_player_input() -> void:
	check_wrong_direction();
	if(input_direction != Vector2.ZERO):
		for path in blends: animation_tree.set(path, input_direction);
		if(player_utils.need_to_turn(input_direction)):
			player_state = PlayerState.TURNING;
			playback.travel("Turn");
		else:
			start_position = position;
			is_moving = true;
	else: playback.travel("Idle")

func move(delta) -> void:
	percent_moved += SPEED * delta;
	# prevents jump when 2 tiles away and move towards a ledge
	if(!jumping_over_ledge && percent_moved >= 0.99):
		percent_moved = 1
	update_rays();
	var ledge_colliding = (ledge_ray_cast_2d.is_colliding() && input_direction == Vector2(0, 1));
	if(ledge_colliding || jumping_over_ledge): check_ledges();
	elif(!block_ray_cast_2d.is_colliding()): check_moving();
	else: reset_moving();

func update_rays() -> void:
	for ray in rays:
		var desired_step: Vector2 = input_direction * TILE_SIZE / 2;
		ray.target_position = desired_step;
		ray.force_raycast_update();

func check_moving() -> void:
	if(percent_moved >= 1):
		position = start_position + (TILE_SIZE * input_direction);
		reset_moving();
	else:
		emit_signal("player_moving")
		position = start_position + (floor(TILE_SIZE * input_direction * percent_moved));

func check_ledges() -> void:
	if(percent_moved >= 2): stop_jumping();
	else: jump();

func check_wrong_direction() -> void:
	var right_or_left = int(Input.is_action_pressed("moveRight")) - int(Input.is_action_pressed("moveLeft"));
	var up_or_down = int(Input.is_action_pressed("moveDown")) - int(Input.is_action_pressed("moveUp"));
	if(input_direction.y == 0): input_direction.x = right_or_left;
	if(input_direction.x == 0): input_direction.y = up_or_down;

func finished_turning() -> void:
	player_state = PlayerState.IDLE;

func reset_moving() -> void:
	is_moving = false;
	percent_moved = 0;
	
func jump() -> void:
	dust_effect.visible = false;
	jumping_over_ledge = true;
	shadow.visible = true;
	var new_position = input_direction.y * TILE_SIZE * percent_moved;
	position.y = player_utils.get_jumping_curvature(start_position.y, new_position);

func stop_jumping() -> void:
	position = start_position + (TILE_SIZE * input_direction * 2);
	percent_moved = 0;
	is_moving = false;
	jumping_over_ledge = false;
	shadow.visible = false;
	dust_effect.visible = true;
	dust_effect.play();

