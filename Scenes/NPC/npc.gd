extends StaticBody2D

enum States { MOVING, IDLE }

enum Directions { 
	WALK_LEFT, WALK_RIGHT, WALK_UP, WALK_DOWN, 
	LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN, NONE
}

@export var texture: Texture;
@export var frames: int = 12
@export var state: States = States.MOVING;
@export var can_left: bool = true
@export var can_right: bool = true
@export var can_up: bool = true
@export var can_down: bool = true;
@export var possitive_limits: Vector2;
@export var negative_limits: Vector2;
@export var interval: float = 1.0;
@export var dialog_id = 1;

@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var timer = $Timer;
@onready var anim_player = $AnimationPlayer;
@onready var sprite = $Sprite2D;

var limits_possitive;
var limits_negative;
var is_talking = false;
var inside_player_area = false;

var oak: CharacterBody2D;

func _ready() -> void:
	connect_signals();
	sprite.hframes = frames
	sprite.texture = texture;
	timer.wait_time = interval;
	limits_possitive = position + (possitive_limits * GLOBAL.TILE_SIZE);
	limits_negative = position + (negative_limits * GLOBAL.TILE_SIZE);
	oak = get_parent().get_node("Oak");
	if state == States.MOVING: timer.start();

func _on_timer_timeout() -> void:
	if(is_talking): return;
	randomize(); 
	var random_int: int = randi_range(0, Directions.size() - 1);
	
	match random_int:
		Directions.WALK_LEFT: if can_left: handle_direction(Vector2.LEFT)
		Directions.WALK_RIGHT: if can_right: handle_direction(Vector2.RIGHT)
		Directions.WALK_UP: if can_up: handle_direction(Vector2.UP)
		Directions.WALK_DOWN: if can_down: handle_direction(Vector2.DOWN)
		Directions.LOOK_LEFT: sprite.frame = 2
		Directions.LOOK_RIGHT: sprite.frame = 3
		Directions.LOOK_UP: sprite.frame = 1
		Directions.LOOK_DOWN: sprite.frame = 0
		Directions.NONE: return;

func handle_direction(next_step: Vector2) -> void:
	if(inside_player_area): return;
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
func _on_start_dialog(_id: int) -> void:
	is_talking = true;
	var last_direction = GLOBAL.last_player_direction;
	if(last_direction == Vector2.UP): sprite.frame = 0;
	elif(last_direction == Vector2.RIGHT): sprite.frame = 2;
	elif(last_direction == Vector2.DOWN): sprite.frame = 1;
	elif(last_direction == Vector2.LEFT): sprite.frame = 3;

func _on_close_dialog() -> void:
	await GLOBAL.timeout(.2);
	is_talking = false;

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

func _on_npc_area_body_entered(body): if("Oak" in body.name): inside_player_area = true;
func _on_npc_area_body_exited(body): if("Oak" in body.name): inside_player_area = false;
