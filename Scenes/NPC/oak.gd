extends CharacterBody2D

const SPEED = 4;
var cant_move = false;

@onready var animation_tree = $AnimationTree;
@onready var animation_player = $AnimationPlayer;
@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var ledge_ray_cast_2d = $LedgeRayCast2D;
@onready var shadow = $Shadow;
@onready var dust_effect = $DustEffect;
@onready var sprite = $Sprite2D;

@onready var playback = animation_tree.get("parameters/playback");
@onready var rays = [block_ray_cast_2d, ledge_ray_cast_2d];

enum PlayerState { IDLE, TURNING, WALKING };
var player_state = PlayerState.IDLE;
var input_direction = Vector2()
var start_position = Vector2(0, -1);
var jumping_over_ledge = false;
var is_moving: bool = false;
var percent_moved: float = 0;
var running = false;
var sit_on_chair = false;
var chair_direction: Vector2;

var blends = [
	"parameters/Idle/blend_position", 
	'parameters/Move/blend_position', 
	'parameters/Turn/blend_position'];

func _ready():
	start_position = position;
	$Sprite2D.visible = true;

func _physics_process(delta) -> void:
	if(player_state == PlayerState.TURNING || cant_move): return;
	elif(GLOBAL.on_transition):
		is_moving = false;
		return;
	elif(is_moving == false): process_player_input();
	elif(input_direction != Vector2.ZERO): move(delta);
	else:
		playback.travel("Idle");
		is_moving = false;

func process_player_input() -> void:
	check_wrong_direction();
	if(input_direction != Vector2.ZERO):
		set_blend_direction(input_direction);
		update_rays()
		if(sit_on_chair):
			if(block_ray_cast_2d.is_colliding() && input_direction == chair_direction):
				return;
		if(GLOBAL.need_to_turn(input_direction) && !sit_on_chair):
			player_state = PlayerState.TURNING;
			playback.travel("Turn");
		else:
			start_position = position;
			is_moving = true;
	elif(!sit_on_chair): playback.travel("Idle")

func move(delta) -> void:
	playback.travel("Move");
	percent_moved += SPEED * delta;
	# prevents jump when 2 tiles away and move towards a ledge
	if(!jumping_over_ledge && percent_moved >= 0.99): percent_moved = 1;
	var ledge_colliding = (ledge_ray_cast_2d.is_colliding() && input_direction == Vector2(0, 1));
	if(ledge_colliding || jumping_over_ledge): check_ledges();
	elif(!block_ray_cast_2d.is_colliding()): check_moving();
	else: reset_moving();

func update_rays() -> void:
	for ray in rays:
		var desired_step: Vector2 = input_direction * GLOBAL.TILE_SIZE / 2;
		ray.target_position = desired_step;
		ray.force_raycast_update();

func check_moving() -> void:
	if(percent_moved >= 1):
		position = start_position + (GLOBAL.TILE_SIZE * input_direction);
		reset_moving();
	else:
		GLOBAL.emit_signal("player_moving")
		position = start_position + (floor(GLOBAL.TILE_SIZE * input_direction * percent_moved));

func check_ledges() -> void:
	if(percent_moved >= 2): stop_jumping();
	else: jump();

func check_wrong_direction() -> void:
	if(input_direction.y == 0): input_direction.x = Input.get_axis("moveLeft", "moveRight");
	if(input_direction.x == 0): input_direction.y = Input.get_axis("moveUp", "moveDown");
	if(input_direction != Vector2.ZERO):
		GLOBAL.last_player_direction = input_direction;

func finished_turning() -> void:
	player_state = PlayerState.IDLE;

func reset_moving() -> void:
	is_moving = false;
	percent_moved = 0;

func jump() -> void:
	jumping_over_ledge = true;
	var new_position = input_direction.y * GLOBAL.TILE_SIZE * percent_moved;
	position.y = GLOBAL.get_jumping_curvature(start_position.y, new_position);
	shadow.visible = true;
	show_dust_effect(false);

func stop_jumping() -> void:
	position = start_position + (GLOBAL.TILE_SIZE * input_direction * 2);
	percent_moved = 0;
	is_moving = false;
	jumping_over_ledge = false;
	shadow.visible = false;
	show_dust_effect(true);

func show_dust_effect(value: bool) -> void:
	if(value): dust_effect.play();
	dust_effect.visible = value;

func _on_area_2d_area_entered(area):
	if("Door" in area.name && area.can_be_opened):
		await get_tree().create_timer(.2).timeout
		var tween = get_tree().create_tween()
		await tween.tween_property(sprite, "modulate:a", 0, 0.1).finished;
		cant_move = true;
		GLOBAL.can_change_camera = true;

	elif("Chair" in area.name):
		await get_tree().create_timer(.3).timeout
		if(input_direction == Vector2.ZERO):
			set_blend_direction(area.sit_direction);
			chair_direction = area.sit_direction;
			if(GLOBAL.last_player_direction == Vector2(0, 1)): 
				playback.travel("ChairDown");
			else: playback.travel("Chair");
			sit_on_chair = true;

func _on_area_2d_area_exited(area):
	if("Chair" in area.name):
		sit_on_chair = false;

func set_blend_direction(direction: Vector2):
	for path in blends: animation_tree.set(path, direction);


