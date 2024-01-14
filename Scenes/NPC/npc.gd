extends RigidBody2D

enum States { MOVING, IDLE }

enum Directions { 
	WALK_LEFT, WALK_RIGHT, WALK_UP, WALK_DOWN, 
	LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN, NONE
}

@export var texture: Texture;
@export var npc: int = 0
@export var frames: int = 12
@export var state: States = States.MOVING;
@export var can_left: bool = true
@export var can_right: bool = true
@export var can_up: bool = true
@export var can_down: bool = true;
@export var limits: Vector2 = Vector2(3, 3);
@export var interval = 1;
@onready var oak_ray_cast_2d = $OakRayCast2D;

@onready var timer: Timer = $Timer;
@onready var ray_cast: RayCast2D = $BlockRayCast2D;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var sprite: Sprite2D = $Sprite2D;

var text: Array
var limits_positive;
var limits_negative;

var walk: Dictionary = {
	"UP": Vector2(0, -1),
	"RIGHT": Vector2(1, 0),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1, 0)
}

var wrong_directions = [];

func _ready() -> void:
	sprite.hframes = frames
	sprite.texture = texture;
	timer.wait_time = interval;
	limits_positive = position + (limits * GLOBAL.TILE_SIZE);
	limits_negative = position - (limits * GLOBAL.TILE_SIZE);
	if state == States.MOVING: timer.start();

func quit() -> void: self.queue_free();

func _on_timer_timeout() -> void:
	randomize(); 
	var random_int: int = randi_range(0, Directions.size() - 1);
	
	match random_int:
		Directions.WALK_LEFT: if can_left: handle_direction(walk.LEFT)
		Directions.WALK_RIGHT: if can_right: handle_direction(walk.RIGHT)
		Directions.WALK_UP: if can_up: handle_direction(walk.UP)
		Directions.WALK_DOWN: if can_down: handle_direction(walk.DOWN)
		Directions.LOOK_LEFT: sprite.frame = 2
		Directions.LOOK_RIGHT: sprite.frame = 3
		Directions.LOOK_UP: sprite.frame = 1
		Directions.LOOK_DOWN: sprite.frame = 0
		Directions.NONE: return

func handle_direction(next_step: Vector2):
	var desired_step: Vector2 = next_step * GLOBAL.TILE_SIZE;
	
	if(limits_positive.x <= position.x): desired_step = walk.LEFT * GLOBAL.TILE_SIZE;
	elif(limits_positive.y <= position.y): desired_step = walk.UP * GLOBAL.TILE_SIZE;
	elif(limits_negative.x >= position.x): desired_step = walk.RIGHT * GLOBAL.TILE_SIZE;
	elif(limits_negative.y >= position.y): desired_step = walk.DOWN * GLOBAL.TILE_SIZE;
	
	ray_cast.target_position = desired_step
	ray_cast.force_raycast_update();
	var collapsing = ray_cast.is_colliding();
	
	oak_ray_cast_2d.target_position = desired_step * 2;
	oak_ray_cast_2d.force_raycast_update();
	var oak_collading = oak_ray_cast_2d.is_colliding();
	
	if(desired_step in wrong_directions): return;
	if !collapsing && !oak_collading: move(desired_step);

func move(new_direction: Vector2) -> void:
	if new_direction == Vector2(16, 0): anim_player.play("moveRight")
	elif new_direction == Vector2(-16, 0): anim_player.play("moveLeft")
	elif new_direction == Vector2(0, 16): anim_player.play("moveDown")
	elif new_direction == Vector2(0, -16): anim_player.play("moveUp");
	check_positon_bounds();
	get_tree().create_tween().tween_property(self, "position", floor(position + new_direction), 0.3);

func _on_hit_box_body_entered(body):
	#@TODO avoid 2 bodies goes towards the same tile at same time
	await get_tree().create_timer(.33).timeout
	var direction_y = [Vector2(0, -1) * GLOBAL.TILE_SIZE, Vector2(0, 1) * GLOBAL.TILE_SIZE];
	var direction_x = [Vector2(1, 0) * GLOBAL.TILE_SIZE, Vector2(-1, 0) * GLOBAL.TILE_SIZE];
	
	if(
		body.position.x == position.x && body.position.y > position.y ||
		body.position.x == position.x && body.position.y < position.y
	): wrong_directions = direction_y;
	elif(
		body.position.y == position.y && body.position.x > position.x ||
		body.position.y == position.y && body.position.x < position.x
	): wrong_directions = direction_x;
	
func check_positon_bounds():
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0: position.x = round_position(position.x);
	if fmod(position.y, GLOBAL.TILE_SIZE) != 0.0: position.y = round_position(position.y);
	
func round_position(coord: float) -> int:
	return int(floor(coord / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE)

func _on_hit_box_body_exited(_body): wrong_directions = [];
