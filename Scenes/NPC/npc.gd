extends StaticBody2D

enum States { MOVING, STILL }

enum Directions { 
	WALK_LEFT, WALK_RIGHT, WALK_UP, WALK_DOWN, 
	LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN, NONE}

@export var texture: Texture;
@export var direction: Vector2 = Vector2(0, 0)
@export var npc: int = 0
@export var frames: int = 12
@export var state: States = States.STILL;
@export var can_left: bool = true
@export var can_right: bool = true
@export var can_up: bool = true
@export var can_down: bool = true;
@export var limits: Vector2 = Vector2(3, 3);
@export var interval = 1;

@onready var timer: Timer = $Timer;
@onready var ray_cast: RayCast2D = $BlockRayCast2D;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var sprite: Sprite2D = $Sprite2D;

var text: Array
var limits_positive;
var limits_negative;

func _ready() -> void:
	sprite.hframes = frames
	sprite.texture = texture;
	timer.wait_time = interval;
	limits_positive = position + (limits * GLOBAL.TILE_SIZE);
	limits_negative = position - (limits * GLOBAL.TILE_SIZE);
	if state == States.MOVING: timer.start();

func quit() -> void: self.queue_free();

func _on_timer_timeout() -> void:
	randomize() 
	var random_int: int = randi_range(0, 8);

	match random_int:
		Directions.WALK_LEFT: if can_left: handle_direction(Vector2(-1, 0))
		Directions.WALK_RIGHT: if can_right: handle_direction(Vector2(1, 0))
		Directions.WALK_UP: if can_up: handle_direction(Vector2(0, -1))
		Directions.WALK_DOWN: if can_down: handle_direction(Vector2(0, 1))
		Directions.LOOK_LEFT: sprite.frame = 2
		Directions.LOOK_RIGHT: sprite.frame = 3
		Directions.LOOK_UP: sprite.frame = 1
		Directions.LOOK_DOWN: sprite.frame = 0
		Directions.NONE: return

func handle_direction(next_step: Vector2):
	var desired_step: Vector2 = next_step * GLOBAL.TILE_SIZE;
	
	if(limits_positive.x <= position.x): desired_step = Vector2(-1, 0) * GLOBAL.TILE_SIZE;
	elif(limits_positive.y <= position.y): desired_step = Vector2(0, -1) * GLOBAL.TILE_SIZE;
	elif(limits_negative.x >= position.x): desired_step = Vector2(1, 0) * GLOBAL.TILE_SIZE;
	elif(limits_negative.y >= position.y): desired_step = Vector2(0, 1) * GLOBAL.TILE_SIZE;
	
	ray_cast.target_position = desired_step
	ray_cast.force_raycast_update();
	
	if !ray_cast.is_colliding(): walk(desired_step);
	else: print('colliding')

func walk(new_direction: Vector2) -> void:
	if new_direction == Vector2(16, 0): anim_player.play("move_right")
	elif new_direction == Vector2(-16, 0): anim_player.play("move_left")
	elif new_direction == Vector2(0, 16): anim_player.play("move_down")
	elif new_direction == Vector2(0, -16): anim_player.play("move_up");
	
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0: position.x = round_position(position.x);
	if fmod(position.y, GLOBAL.TILE_SIZE) != 0.0: position.y = round_position(position.y);
	
	get_tree().create_tween().tween_property(self, "position", position + new_direction, 0.5);
	
func round_position(coord: float) -> int:
	var closest = round(coord / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE;
	return int(closest)


