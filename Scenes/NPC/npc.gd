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

@onready var block_ray_cast_2d: RayCast2D = $BlockRayCast2D;
@onready var oak_ray_cast_2d = $OakRayCast2D;
@onready var timer: Timer = $Timer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var sprite: Sprite2D = $Sprite2D;
@onready var rays = [block_ray_cast_2d, oak_ray_cast_2d];

var dialog: Array;
var limits_possitive;
var limits_negative;
var wrong_directions = [];
var is_talking = false;

func _ready() -> void:
	GLOBAL.connect("start_dialog", _on_start_dialog);
	GLOBAL.connect("close_dialog", _on_close_dialog);
	sprite.hframes = frames
	sprite.texture = texture;
	timer.wait_time = interval;
	limits_possitive = position + (possitive_limits * GLOBAL.TILE_SIZE);
	limits_negative = position + (negative_limits * GLOBAL.TILE_SIZE);
	
	dialog = DIALOG.get_dialog(self.name, dialog_id);
	if state == States.MOVING: timer.start();

func quit() -> void: self.queue_free();

func _on_timer_timeout() -> void:
	if(is_talking): return;
	randomize(); 
	var random_int: int = randi_range(0, Directions.size() - 1);
	
	match random_int:
		Directions.WALK_LEFT: if can_left: handle_direction(GLOBAL.walk.LEFT)
		Directions.WALK_RIGHT: if can_right: handle_direction(GLOBAL.walk.RIGHT)
		Directions.WALK_UP: if can_up: handle_direction(GLOBAL.walk.UP)
		Directions.WALK_DOWN: if can_down: handle_direction(GLOBAL.walk.DOWN)
		Directions.LOOK_LEFT: sprite.frame = 2
		Directions.LOOK_RIGHT: sprite.frame = 3
		Directions.LOOK_UP: sprite.frame = 1
		Directions.LOOK_DOWN: sprite.frame = 0
		Directions.NONE: return

func handle_direction(next_step: Vector2) -> void:
	var desired_step: Vector2 = check_limits(next_step * GLOBAL.TILE_SIZE);
	update_rays(next_step);
	if(desired_step in wrong_directions): return;
	var collapsing = block_ray_cast_2d.is_colliding();
	var oak_collading = oak_ray_cast_2d.is_colliding();
	if !collapsing && !oak_collading: move(desired_step);

func move(new_direction: Vector2) -> void:
	if new_direction == Vector2(16, 0): anim_player.play("moveRight")
	elif new_direction == Vector2(-16, 0): anim_player.play("moveLeft")
	elif new_direction == Vector2(0, 16): anim_player.play("moveDown")
	elif new_direction == Vector2(0, -16): anim_player.play("moveUp");
	check_positon_bounds();
	get_tree().create_tween().tween_property(self, "position", floor(position + new_direction), 0.3);

func _on_hit_box_body_entered(body) -> void:
	#@TODO avoid 2 bodies goes towards the same tile at same time
	await get_tree().create_timer(.4).timeout
	var direction_y = [GLOBAL.walk.UP * GLOBAL.TILE_SIZE, GLOBAL.walk.DOWN * GLOBAL.TILE_SIZE];
	var direction_x = [GLOBAL.walk.RIGHT * GLOBAL.TILE_SIZE, GLOBAL.walk.LEFT * GLOBAL.TILE_SIZE];
	#Avoid NPC walks in the same coordinates if both are close
	if(
		body.position.x == position.x && body.position.y > position.y ||
		body.position.x == position.x && body.position.y < position.y
	): wrong_directions = direction_y;
	elif(
		body.position.y == position.y && body.position.x > position.x ||
		body.position.y == position.y && body.position.x < position.x
	): wrong_directions = direction_x;

func _on_hit_box_body_exited(_body): wrong_directions = [];

func check_positon_bounds() -> void:
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0: position.x = round_position(position.x);
	if fmod(position.y, GLOBAL.TILE_SIZE) != 0.0: position.y = round_position(position.y);

func round_position(coord: float) -> int:
	return int(floor(coord / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE)

func check_limits(step: Vector2) -> Vector2:
	if(limits_possitive.x < position.x + step.x): 
		return GLOBAL.walk.LEFT * GLOBAL.TILE_SIZE;
	elif(limits_possitive.y < position.y + step.y): 
		return GLOBAL.walk.UP * GLOBAL.TILE_SIZE;
	elif(limits_negative.x > position.x + step.x):
		return GLOBAL.walk.RIGHT * GLOBAL.TILE_SIZE;
	elif(limits_negative.y > position.y + step.y):
		return GLOBAL.walk.DOWN * GLOBAL.TILE_SIZE;
	return step;

func update_rays(direction: Vector2) -> void:
	for ray in rays:
		var desired_step: Vector2 = direction * GLOBAL.TILE_SIZE / 2;
		ray.target_position = desired_step;
		ray.force_raycast_update();

func _on_start_dialog(_text, _self_name, _npc_name) -> void:
	is_talking = true;
	var last_direction = GLOBAL.last_player_direction;
	if(last_direction == GLOBAL.walk.UP): sprite.frame = 0;
	elif(last_direction == GLOBAL.walk.RIGHT): sprite.frame = 2;
	elif(last_direction == GLOBAL.walk.DOWN): sprite.frame = 1;
	elif(last_direction == GLOBAL.walk.LEFT): sprite.frame = 3;

func _on_close_dialog() -> void: is_talking = false;
