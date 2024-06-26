extends StaticBody2D

enum Directions { 
	WALK_LEFT, WALK_RIGHT, WALK_UP, WALK_DOWN, 
	LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN, NONE
}

@export var texture: Texture;
@export var frames: int = 12
@export var state: GLOBAL.NPCStates = GLOBAL.NPCStates.MOVING;
@export var can_left: bool = true
@export var can_right: bool = true
@export var can_up: bool = true
@export var can_down: bool = true;
@export var possitive_limits: Vector2;
@export var negative_limits: Vector2;
@export var interval: float = 1.0;
@export var dialog_id = 1;
@export var sprite_offset = Vector2(0, -4);

@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var timer = $Timer;
@onready var anim_player = $AnimationPlayer;
@onready var sprite = $Sprite2D;

var limits_possitive;
var limits_negative;
var is_talking = false;
var inside_player_area = false;
var is_player_moving = false;
var dialog_data: Dictionary;

func _ready() -> void:
	connect_signals();
	sprite.hframes = frames
	sprite.texture = texture;
	sprite.offset = sprite_offset;
	timer.wait_time = interval;
	limits_possitive = position + (possitive_limits * GLOBAL.TILE_SIZE);
	limits_negative = position + (negative_limits * GLOBAL.TILE_SIZE);
	timer.start();

func _on_timer_timeout() -> void:
	if(is_talking): return;
	randomize(); 
	var random_int: int = randi_range(0, Directions.size() - 1);
	
	match random_int:
		Directions.WALK_LEFT: 
			if(can_left && state == GLOBAL.NPCStates.MOVING): 
				handle_direction(Vector2.LEFT);
		Directions.WALK_RIGHT: 
			if(can_right && state == GLOBAL.NPCStates.MOVING): 
				handle_direction(Vector2.RIGHT);
		Directions.WALK_UP: 
			if(can_up && state == GLOBAL.NPCStates.MOVING):
				handle_direction(Vector2.UP);
		Directions.WALK_DOWN: 
			if(can_down && state == GLOBAL.NPCStates.MOVING): 
				handle_direction(Vector2.DOWN);
		Directions.LOOK_DOWN: if(can_down): sprite.frame = 0;
		Directions.LOOK_UP: if(can_up): sprite.frame = 1;
		Directions.LOOK_LEFT: if(can_left): sprite.frame = 2;
		Directions.LOOK_RIGHT: if(can_right): sprite.frame = 3;
		Directions.NONE: return;

func handle_direction(next_step: Vector2) -> void:
	if(inside_player_area || is_player_moving): return;
	var desired_step: Vector2 = check_limits(next_step * GLOBAL.TILE_SIZE);
	block_ray_cast_2d.target_position = desired_step / 2;
	block_ray_cast_2d.force_raycast_update();
	if !block_ray_cast_2d.is_colliding(): move(desired_step);

func move(new_direction: Vector2) -> void:
	if new_direction == Vector2.RIGHT * GLOBAL.TILE_SIZE: anim_player.play("moveRight")
	elif new_direction == Vector2.LEFT * GLOBAL.TILE_SIZE: anim_player.play("moveLeft")
	elif new_direction == Vector2.DOWN * GLOBAL.TILE_SIZE: anim_player.play("moveDown")
	elif new_direction == Vector2.UP * GLOBAL.TILE_SIZE: anim_player.play("moveUp");
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position", floor(position + new_direction), 0.3);

#LISTENERS
func _on_start_dialog(id: int) -> void:
	await GLOBAL.timeout(.1);
	var pre_data = DIALOG.get_dialog(id);
	#CHECK IS THE CORRECT DIALOG AND NPC
	if("starter" in pre_data):
		if(pre_data.starter != dialog_id):
			return;
	elif(dialog_id != id): return;
	
	is_talking = true;
	dialog_data = pre_data;
	var last_direction = GLOBAL.last_direction;
	if(last_direction == Vector2.UP): sprite.frame = 0;
	elif(last_direction == Vector2.DOWN): sprite.frame = 1;
	elif(last_direction == Vector2.RIGHT): sprite.frame = 2;
	elif(last_direction == Vector2.LEFT): sprite.frame = 3;

func _on_close_dialog() -> void:
	await GLOBAL.timeout(.1);
	#CHECK WHAT NPC DIALOG TO CLOSE
	if(
		"response" in dialog_data || 
		(
			"starter" in dialog_data && 
			dialog_data.starter == dialog_id && 
			!dialog_data["end"]
		)): return;
	
	is_talking = false;
	dialog_data = {};

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

func connect_signals() -> void:
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);
	GLOBAL.connect("player_moving", _on_player_moving);

func _on_npc_area_body_entered(body): if("Oak" in body.name): 
	inside_player_area = true;

func _on_npc_area_body_exited(body): if("Oak" in body.name): 
	inside_player_area = false;

func _on_player_moving(value: bool) -> void: is_player_moving = value;
