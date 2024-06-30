extends StaticBody2D

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

#TRAINER
@export var battle_zone: ENUMS.BattleZones;
@export var battle_pokemon: Array[ENUMS.Pokedex];
@export var battle_range_level: Array[int];
@export var trainer_id: int;
@export var start_dialog: int;
@export var defeat_dialog: int;
@export var end_dialog: int;
@export_range(1, 5) var view_range = 5;

@onready var trainer_container: Node2D = $Trainer;
@onready var trainer_ray_cast_2d: RayCast2D = $Trainer/TrainerRayCast2D;
@onready var trainer_timer: Timer = $Trainer/TrainerTimer;
@onready var exclamation: TextureRect = $Trainer/Exclamation;

var limits_possitive;
var limits_negative;
var is_talking = false;
var inside_player_area = false;
var is_player_moving = false;
var dialog_data: Dictionary;
var insight = false;
var walking_towards = false;

func _ready() -> void:
	check_schedule();
	connect_signals();
	assign_npc();
	timer.start();
	check_if_trainer();

func check_schedule() -> void:
	if(
		schedule != GLOBAL.current_time_of_day && 
		schedule != ENUMS.Climate.ANY
	): 
		queue_free();

func check_if_trainer() -> void:
	if(type != ENUMS.NPCType.TRAINER):
		trainer_container.queue_free();
	else:
		trainer_ray_cast_2d.target_position.y = view_range * GLOBAL.TILE_SIZE;
		trainer_timer.start();
		connect_trainer_signals();
		update_trainer_raycast_direction();

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
		update_trainer_raycast_direction();

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
	if !block_ray_cast_2d.is_colliding(): 
		move(desired_step);

func move(new_direction: Vector2, duration = 0.4) -> void:
	if(trainer_ray_cast_2d != null):
		trainer_ray_cast_2d.enabled = false;
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
	if(trainer_ray_cast_2d != null):
		trainer_ray_cast_2d.enabled = true;

#LISTENERS
func _on_start_dialog(id: int) -> void:
	await get_tree().process_frame;
	var pre_data = DIALOG.get_dialog(id);
	#CHECK IS THE CORRECT DIALOG AND NPC
	if("starter" in pre_data):
		if(pre_data.starter != dialog_id):
			return;
	elif(dialog_id != id): return;
		
	var last_direction = GLOBAL.last_direction;
	if(last_direction == Vector2.UP): sprite.frame = 0;
	elif(last_direction == Vector2.DOWN): sprite.frame = 1;
	elif(last_direction == Vector2.RIGHT): sprite.frame = 2;
	elif(last_direction == Vector2.LEFT): sprite.frame = 3;
		
	is_talking = true;
	dialog_data = pre_data;

func _on_close_dialog() -> void:
	#CHECK WHAT NPC DIALOG TO CLOSE
	if(
		"response" in dialog_data || 
		(
			"starter" in dialog_data && 
			dialog_data.starter == dialog_id && 
			dialog_data["end"] == false
		)): return;
	is_talking = false;
	dialog_data = {};

#TRAINER
func update_trainer_raycast_direction() -> void:
	match facing_direction:
		ENUMS.FacingDirection.DOWN: trainer_ray_cast_2d.rotation_degrees = 0;
		ENUMS.FacingDirection.UP: trainer_ray_cast_2d.rotation_degrees = 180.0;
		ENUMS.FacingDirection.LEFT: trainer_ray_cast_2d.rotation_degrees = 90.0;
		ENUMS.FacingDirection.RIGHT: trainer_ray_cast_2d.rotation_degrees = 270.0;

var frame_directions = {
	ENUMS.FacingDirection.DOWN: Vector2(0, 1) * GLOBAL.TILE_SIZE,
	ENUMS.FacingDirection.UP: Vector2(0, -1) * GLOBAL.TILE_SIZE,
	ENUMS.FacingDirection.LEFT: Vector2(-1, 0) * GLOBAL.TILE_SIZE,
	ENUMS.FacingDirection.RIGHT: Vector2(1, 0) * GLOBAL.TILE_SIZE
}

func _on_trainer_timer_timeout() -> void:
	if(trainer_ray_cast_2d.is_colliding()):
		var collider = trainer_ray_cast_2d.get_collider();
		if(not collider is CharacterBody2D): return;
		trainer_timer.stop();
		timer.stop();
		await start_walking_towards(collider);
		trainer_container.queue_free();

#WALK
func start_walking_towards(oak: CharacterBody2D) -> void:
	AUDIO.stop();
	oak.trainer_insight = true;
	await GLOBAL.timeout(0.2);
	await show_trainer_exclamation();
	var steps = get_intermediate_points(self.position, oak.position);
	var direction = frame_directions[facing_direction];
	for step in steps: 
		await move(direction);
	await GLOBAL.timeout(0.2);
	await start_trainer_battle(oak, direction);

func show_trainer_exclamation() -> void:
	await GLOBAL.timeout(0.2);
	exclamation.visible = true;
	await GLOBAL.timeout(1);
	exclamation.visible = false;

#TRAINER BATTLE
func start_trainer_battle(oak: CharacterBody2D, direction: Vector2) -> void:
	oak.set_blend_direction((direction / GLOBAL.TILE_SIZE) * -1);
	await GLOBAL.timeout(0.1);
	oak.trainer_insight = false;
	GLOBAL.start_dialog.emit(start_dialog);
	await GLOBAL.close_dialog;
	
	var battle_data = {
		"enemies": battle_pokemon,
		"zone": battle_zone,
		"type": ENUMS.BattleType.TRAINER,
		"levels": battle_range_level,
		"trainer_id": trainer_id
	}
	oak.set_battle_data(battle_data);
	oak.check_for_battle();

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

func connect_trainer_signals() -> void:
	GLOBAL.connect("close_battle", _on_end_battle);
	trainer_timer.connect("timeout", _on_trainer_timer_timeout);

func _on_end_battle(battle_data: Dictionary) -> void:
	await GLOBAL.timeout(0.4);
	if(
		battle_data.type == ENUMS.BattleType.TRAINER &&
		"trainer_id" in battle_data && 
		battle_data.trainer_id != null &&
		trainer_id == battle_data.trainer_id
		):
		GLOBAL.start_dialog.emit(end_dialog);

func _on_npc_area_body_entered(body): 
	if("Oak" in body.name): inside_player_area = true;
	if(body.position == position): position.y += 16;

func _on_npc_area_body_exited(body): 
	if("Oak" in body.name): inside_player_area = false;

func _on_player_moving(value: bool) -> void: is_player_moving = value;

func get_intermediate_points(
	start_point: Vector2, 
	end_point: Vector2, 
	step = GLOBAL.TILE_SIZE
) -> Array:
	var points = [];
	
	if start_point.x == end_point.x:
		var y_start = min(start_point.y, end_point.y) + step;
		var y_end = max(start_point.y, end_point.y);
		for y in range(y_start, y_end, step):
			points.append(Vector2(start_point.x, y));
	elif start_point.y == end_point.y:
		var x_start = min(start_point.x, end_point.x) + step;
		var x_end = max(start_point.x, end_point.x);
		for x in range(x_start, x_end, step):
			points.append(Vector2(x, start_point.y));
	
	return points;
