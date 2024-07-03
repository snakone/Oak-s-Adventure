extends StaticBody2D

class_name NPC

@export var texture: Texture;
@export var frames: int = 12;
@export var state: ENUMS.NPCStates = ENUMS.NPCStates.MOVING;
@export var can_left: bool = true;
@export var can_right: bool = true;
@export var can_up: bool = true
@export var can_down: bool = true;
@export var possitive_limits: Vector2;
@export var negative_limits: Vector2;
@export var interval: float = 1.0;
@export var dialog_id = 1;
@export var sprite_offset = Vector2(0, -4);
@export var schedule: ENUMS.Climate = ENUMS.Climate.ANY;
@export var facing_direction: ENUMS.FacingDirection = ENUMS.FacingDirection.DOWN;
@export var type = ENUMS.NPCType.DEFAULT;

@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var timer = $Timer;
@onready var sprite = $Sprite2D;
@onready var anim_player = $AnimationPlayer;

signal trainer_change_position();

var limits_possitive;
var limits_negative;
var is_talking = false;
var inside_player_area = false;
var is_player_moving = false;
var dialog_data: Dictionary;

var oak: CharacterBody2D;

func _ready() -> void:
	timer.start();
	check_schedule();
	connect_signals();
	assign_npc();

func check_schedule() -> void:
	if(
		schedule != GLOBAL.current_time_of_day && 
		schedule != ENUMS.Climate.ANY
	): 
		queue_free();

func assign_npc() -> void:
	sprite.hframes = frames
	sprite.texture = texture;
	sprite.offset = sprite_offset;
	timer.wait_time = interval;
	sprite.frame = int(facing_direction);
	limits_possitive = position + (possitive_limits * GLOBAL.TILE_SIZE);
	limits_negative = position + (negative_limits * GLOBAL.TILE_SIZE);

func _on_timer_timeout() -> void:
	if(is_talking): return;
	match state:
		ENUMS.NPCStates.MOVING:
			randomize(); 
			var random_int: int = randi_range(0, ENUMS.NPCDirections.size() - 1);
			handle_moving(random_int);
			handle_idle(random_int);
		ENUMS.NPCStates.IDLE: handle_idle(null);
	if(type == ENUMS.NPCType.TRAINER):
		emit_signal("trainer_change_position");

func handle_moving(random: int) -> void:
	match random:
		ENUMS.NPCDirections.WALK_LEFT: 
			if(can_left && state == ENUMS.NPCStates.MOVING): 
				handle_direction(Vector2.LEFT);
		ENUMS.NPCDirections.WALK_RIGHT: 
			if(can_right && state == ENUMS.NPCStates.MOVING): 
				handle_direction(Vector2.RIGHT);
		ENUMS.NPCDirections.WALK_UP: 
			if(can_up && state == ENUMS.NPCStates.MOVING):
				handle_direction(Vector2.UP);
		ENUMS.NPCDirections.WALK_DOWN: 
			if(can_down && state == ENUMS.NPCStates.MOVING): 
				handle_direction(Vector2.DOWN);

func handle_idle(random: Variant) -> void:
	if(random == null):
		randomize(); 
		random = randi_range(4, ENUMS.NPCDirections.size() - 1);
	match random:
		ENUMS.NPCDirections.LOOK_DOWN: if(can_down): 
			sprite.frame = 0;
			facing_direction = ENUMS.FacingDirection.DOWN;
		ENUMS.NPCDirections.LOOK_UP: if(can_up): 
			sprite.frame = 1;
			facing_direction = ENUMS.FacingDirection.UP;
		ENUMS.NPCDirections.LOOK_LEFT: if(can_left): 
			sprite.frame = 2;
			facing_direction = ENUMS.FacingDirection.LEFT;
		ENUMS.NPCDirections.LOOK_RIGHT: if(can_right): 
			sprite.frame = 3;
			facing_direction = ENUMS.FacingDirection.RIGHT;
		ENUMS.NPCDirections.NONE: return;

func handle_direction(next_step: Vector2) -> void:
	if(inside_player_area || is_player_moving): return;
	var desired_step: Vector2 = check_limits(next_step * GLOBAL.TILE_SIZE);
	block_ray_cast_2d.target_position = desired_step / 2;
	block_ray_cast_2d.force_raycast_update();
	if(!block_ray_cast_2d.is_colliding()): 
		move(desired_step);

func move(new_direction: Vector2, duration = 0.4) -> void:
	if(anim_player.is_playing()): 
		await anim_player.animation_finished;
	if new_direction == Vector2.RIGHT * GLOBAL.TILE_SIZE: 
		anim_player.play("moveRight");
		facing_direction = ENUMS.FacingDirection.RIGHT;
	elif new_direction == Vector2.LEFT * GLOBAL.TILE_SIZE: 
		anim_player.play("moveLeft");
		facing_direction = ENUMS.FacingDirection.LEFT;
	elif new_direction == Vector2.DOWN * GLOBAL.TILE_SIZE: 
		anim_player.play("moveDown");
		facing_direction = ENUMS.FacingDirection.DOWN;
	elif new_direction == Vector2.UP * GLOBAL.TILE_SIZE: 
		anim_player.play("moveUp");
		facing_direction = ENUMS.FacingDirection.UP;
		
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position", floor(position + new_direction), duration);
	await tween.finished;

#LISTENERS
func _on_start_dialog(id: int) -> void:
	await get_tree().process_frame;
	var pre_data = DIALOG.get_dialog(id);
	if(!can_start_dialog(pre_data, id)): return;
	set_npc_direction();
	is_talking = true;
	dialog_data = pre_data;

func _on_close_dialog() -> void:
	if(!can_close_dialog()): return;
	is_talking = false;
	dialog_data = {};

func set_npc_direction() -> void:
	var last_direction = GLOBAL.last_direction;
	if(last_direction == Vector2.UP): sprite.frame = 0;
	elif(last_direction == Vector2.DOWN): sprite.frame = 1;
	elif(last_direction == Vector2.RIGHT): sprite.frame = 2;
	elif(last_direction == Vector2.LEFT): sprite.frame = 3;

#CHECKERS
func check_limits(step: Vector2) -> Vector2:
	if(limits_possitive.x < position.x + step.x): 
		return Vector2.LEFT * GLOBAL.TILE_SIZE;
	elif(limits_possitive.y < position.y + step.y): 
		return Vector2.UP * GLOBAL.TILE_SIZE;
	elif(limits_negative.x > position.x + step.x):
		return Vector2.RIGHT * GLOBAL.TILE_SIZE;
	elif(limits_negative.y > position.y + step.y):
		return Vector2.DOWN * GLOBAL.TILE_SIZE;
	return step;

func can_start_dialog(pre_data: Dictionary, id: int) -> bool:
	if("starter" in pre_data):
		if(pre_data.starter != dialog_id):
			return false;
		return true;
	elif(dialog_id != id): return false;
	return true;

func can_close_dialog() -> bool:
	if("response" in dialog_data || 
		(
			"starter" in dialog_data && 
			dialog_data.starter == dialog_id && 
			dialog_data["end"] == false
		)): return false;
	return true;

func connect_signals() -> void:
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);
	GLOBAL.connect("player_moving", _on_player_moving);

func _on_npc_area_body_entered(body): 
	if("Oak" in body.name): 
		inside_player_area = true;
		oak = body;
	if(body.position == position): position.y += 16;

func _on_npc_area_body_exited(body): 
	if("Oak" in body.name): inside_player_area = false;

func _on_player_moving(value: bool) -> void: is_player_moving = value;
