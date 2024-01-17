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
@export var interval = 1;
@export var dialog_id = 1;
@export var location: MAPS.Locations;

@onready var block_ray_cast_2d: RayCast2D = $BlockRayCast2D;
@onready var oak_ray_cast_2d = $OakRayCast2D;
@onready var timer: Timer = $Timer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var sprite: Sprite2D = $Sprite2D;

var dialog: Array;
var limits_possitive;
var limits_negative;
var wrong_directions = [];
var is_talking = false;

var oak: CharacterBody2D;

func _ready() -> void:
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);
	sprite.hframes = frames
	sprite.texture = texture;
	timer.wait_time = interval;
	limits_possitive = position + (possitive_limits * GLOBAL.TILE_SIZE);
	limits_negative = position + (negative_limits * GLOBAL.TILE_SIZE);
	oak = get_parent().get_node("Oak");
	dialog = DIALOG.get_dialog(self.name, location);
	if state == States.MOVING: timer.start();

func quit() -> void: self.queue_free();

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
		Directions.NONE: return

func handle_direction(next_step: Vector2) -> void:
	var desired_step: Vector2 = check_limits(next_step * GLOBAL.TILE_SIZE);
	check_corners();
	if(desired_step in wrong_directions): return;
	
	block_ray_cast_2d.target_position = desired_step / 2;
	block_ray_cast_2d.force_raycast_update();
	oak_ray_cast_2d.target_position = desired_step * 2;
	oak_ray_cast_2d.force_raycast_update();
	
	var collapsing = block_ray_cast_2d.is_colliding();
	var oak_collading = oak_ray_cast_2d.is_colliding();
	if !collapsing && !oak_collading: move(desired_step);

func move(new_direction: Vector2) -> void:
	if new_direction == Vector2.RIGHT * GLOBAL.TILE_SIZE: anim_player.play("moveRight")
	elif new_direction == Vector2.LEFT * GLOBAL.TILE_SIZE: anim_player.play("moveLeft")
	elif new_direction == Vector2.DOWN * GLOBAL.TILE_SIZE: anim_player.play("moveDown")
	elif new_direction == Vector2.UP * GLOBAL.TILE_SIZE: anim_player.play("moveUp");
	wrong_directions = [];
	get_tree().create_tween().tween_property(self, "position", floor(position + new_direction), 0.3);
	check_positon_bounds();

#LISTENERS
func _on_hit_box_body_entered(body) -> void:
	#Avoid NPC walks in the same coordinates
	await get_tree().create_timer(.4).timeout
	var direction_y = [Vector2.UP * GLOBAL.TILE_SIZE, Vector2.DOWN * GLOBAL.TILE_SIZE];
	var direction_x = [Vector2.RIGHT * GLOBAL.TILE_SIZE, Vector2.LEFT * GLOBAL.TILE_SIZE];

	if(
		body.position.x == position.x && body.position.y > position.y ||
		body.position.x == position.x && body.position.y < position.y
	): wrong_directions = direction_y;
	elif(
		body.position.y == position.y && body.position.x > position.x ||
		body.position.y == position.y && body.position.x < position.x
	): wrong_directions = direction_x;

func _on_hit_box_body_exited(_body): 
	if(is_talking): return;
	wrong_directions = [];

func _on_start_dialog(_text, _self_name, _npc_name) -> void:
	is_talking = true;
	var last_direction = GLOBAL.last_player_direction;
	if(last_direction == Vector2.UP): sprite.frame = 0;
	elif(last_direction == Vector2.RIGHT): sprite.frame = 2;
	elif(last_direction == Vector2.DOWN): sprite.frame = 1;
	elif(last_direction == Vector2.LEFT): sprite.frame = 3;

func _on_close_dialog() -> void:
	await get_tree().create_timer(0.2).timeout;
	is_talking = false;

#CHECKERS
func check_positon_bounds() -> void:
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0: position.x = round_position(position.x);
	if fmod(position.y, GLOBAL.TILE_SIZE) != 0.0: position.y = round_position(position.y);

func round_position(coord: float) -> int:
	return int(floor(coord / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE);

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

func check_corners() -> void:
	#UP_RIGHT
	if(position.x + GLOBAL.TILE_SIZE == oak.position.x && position.y - GLOBAL.TILE_SIZE == oak.position.y):
		wrong_directions = [Vector2.UP * GLOBAL.TILE_SIZE, Vector2.RIGHT * GLOBAL.TILE_SIZE];
	#DOWN_LEFT
	elif(position.x - GLOBAL.TILE_SIZE == oak.position.x && position.y + GLOBAL.TILE_SIZE == oak.position.y):
		wrong_directions = [Vector2.LEFT * GLOBAL.TILE_SIZE, Vector2.DOWN * GLOBAL.TILE_SIZE];
	#UP_LEFT
	elif(position.x - GLOBAL.TILE_SIZE == oak.position.x && position.y - GLOBAL.TILE_SIZE == oak.position.y):
		wrong_directions = [Vector2.LEFT * GLOBAL.TILE_SIZE, Vector2.UP * GLOBAL.TILE_SIZE];
	#DOWN_RIGHT
	elif(position.x + GLOBAL.TILE_SIZE == oak.position.x && position.y + GLOBAL.TILE_SIZE == oak.position.y):
		wrong_directions = [Vector2.RIGHT * GLOBAL.TILE_SIZE, Vector2.DOWN * GLOBAL.TILE_SIZE];
