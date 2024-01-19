extends CharacterBody2D

const SPEED = 4;
const BIKE_SPEED = 6;

@onready var animation_tree = $AnimationTree;
@onready var animation_player = $AnimationPlayer;
@onready var shadow = $Shadow;
@onready var dust_effect = $DustEffect;
@onready var sprite = $Sprite2D;

@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var ledge_ray_cast_2d = $LedgeRayCast2D;
@onready var npc_ray_cast_2d = $NPCRayCast2D
@onready var object_ray_cast_2d = $ObjectRayCast2D
@onready var audio_player = $AudioStreamPlayer;

@onready var playback = animation_tree.get("parameters/playback");
@onready var block_rays = [block_ray_cast_2d, ledge_ray_cast_2d];
@onready var dialog_rays = [npc_ray_cast_2d, object_ray_cast_2d];

var bike_texture = preload("res://Sprites/oak_bike.png");
var oak_texture = preload("res://Sprites/oak_sprite.png");

const CONFIRM = preload("res://Assets/confirm.wav");
const BLOCK = preload("res://Assets/Player bump.ogg");
const PLAYER_JUMP = preload("res://Assets/Player jump.ogg");

enum PlayerState { IDLE, TURNING, WALKING };
var player_state = PlayerState.IDLE;
var input_direction = Vector2();
var start_position = Vector2.UP;
var jumping_over_ledge = false;
var is_moving: bool = false;
var percent_moved: float = 0;
var running = false;
var sit_on_chair = false;
var chair_direction: Vector2;
var cant_enter_door_direction: Vector2;
var stuck_on_door = false;
var door_type: GLOBAL.DoorType;
var can_talk = false;
var dialog_text := [];
var area_type := GLOBAL.DialogAreaType.NONE;
var stop = false;

var npc: StaticBody2D;
var dialog_area: StaticBody2D; 

func _ready():
	connect_signals();
	check_load_from_file();
	if(GLOBAL.on_bike): get_on_bike();

func _physics_process(delta) -> void:
	if(player_state == PlayerState.TURNING || stop): return;
	elif(!is_moving && !GLOBAL.on_transition): process_player_input();
	elif(input_direction != Vector2.ZERO): move(delta);
	else:
		playback.travel("Idle");
		is_moving = false;
		GLOBAL.emit_signal("player_moving", false);

func process_player_input() -> void:
	set_direction();
	check_for_dialogs();
	if(input_direction != Vector2.ZERO):
		set_blend_direction(input_direction);
		update_block_rays();
		#STUCK ON DOOR
		if(
			stuck_on_door && 
			door_type == GLOBAL.DoorType.IN && 
			input_direction == GLOBAL.walk.UP
		):
			playback.travel("Idle");
			return;
		else: stuck_on_door = false;
		#SIT ON CHAIR
		if(
			sit_on_chair && 
			block_ray_cast_2d.is_colliding() && 
			input_direction == chair_direction
		): return;
		#TURN
		if(GLOBAL.need_to_turn(input_direction) && !sit_on_chair):
			player_state = PlayerState.TURNING;
			playback.travel("Turn");
		#DEFAULT
		else:
			start_position = position;
			is_moving = true;
			GLOBAL.emit_signal("player_moving", true);
	elif(!sit_on_chair): playback.travel("Idle");
	
func set_direction() -> void:
	if(input_direction.y == 0): input_direction.x = Input.get_axis("moveLeft", "moveRight");
	if(input_direction.x == 0): input_direction.y = Input.get_axis("moveUp", "moveDown");
	if(input_direction != Vector2.ZERO && !GLOBAL.on_transition):
		GLOBAL.last_player_direction = input_direction;

func move(delta) -> void:
	playback.travel("Move");
	if(GLOBAL.on_bike): percent_moved += BIKE_SPEED * delta;
	else: percent_moved += SPEED * delta;
	round_percent_move();
	var ledge_colliding = (ledge_ray_cast_2d.is_colliding() && input_direction == Vector2.DOWN);
	if(block_ray_cast_2d.is_colliding() && !audio_player.playing && !ledge_colliding):
		audio_player.stream = BLOCK;
		audio_player.play();
	if(GLOBAL.on_transition): check_transition();
	elif(ledge_colliding || jumping_over_ledge): check_ledges();
	elif(!block_ray_cast_2d.is_colliding()): check_moving();
	else: reset_moving();

#MOVEMENT
func update_position() -> void:
	position = start_position + (floor(GLOBAL.TILE_SIZE * input_direction * percent_moved)); 

func stop_movement() -> void:
	position = start_position + (GLOBAL.TILE_SIZE * input_direction);
	check_position_out_bounds();
	reset_moving();

func reset_moving() -> void:
	is_moving = false;
	percent_moved = 0;
	GLOBAL.emit_signal("player_moving", false);

func check_moving() -> void:
	if(percent_moved >= 1): stop_movement();
	else: update_position();

#LEDGES
func check_ledges() -> void:
	if(percent_moved >= 2): stop_jumping();
	else: jump();

#TRANSITION
func check_transition():
	if(percent_moved >= 1): 
		stop_movement();
		GLOBAL.on_transition = false;
	else: update_position();

#JUMP
func jump() -> void:
	audio_player.stream = PLAYER_JUMP;
	audio_player.play();
	jumping_over_ledge = true;
	var new_position = input_direction.y * GLOBAL.TILE_SIZE * percent_moved;
	position.y = GLOBAL.get_jumping_curvature(start_position.y, new_position);
	shadow.visible = true;

func stop_jumping() -> void:
	playback.travel("Idle");
	show_dust_effect(true);
	shadow.visible = false;
	position = start_position + (GLOBAL.TILE_SIZE * input_direction * 2);
	await audio_player.finished;
	reset_moving();
	jumping_over_ledge = false;

#BIKE
func get_on_bike():
	AUDIO.play_bike();
	GLOBAL.on_bike = true;
	sprite.texture = bike_texture;
	sprite.offset.x = -3;
	sprite.offset.y = -8;

func get_off_bike(stop_sound = true):
	if(stop_sound): AUDIO.stop_and_play_last_song();
	GLOBAL.on_bike = false;
	sprite.texture = oak_texture;
	sprite.offset.x = 0;
	sprite.offset.y = -4;

# LISTENERS
func _on_area_2d_area_entered(area: Area2D) -> void:
	if("Door" in area.name && area.can_be_opened): enter_door_animation(area);
	elif("Chair" in area.name): sit_on_chair_animation(area);
	elif("NPCHitBox" in area.name): npc_talk_on_area_entered(area);
	elif("DialogArea" in area.name): object_talk_on_area_entered(area);

func _on_area_2d_area_exited(area: Area2D) -> void:
	if("Chair" in area.name): sit_on_chair = false;
	elif("NPCHitBox" in area.name || "DialogArea" in area.name): 
		can_talk = GLOBAL.dialog_open;
		area_type = GLOBAL.DialogAreaType.NONE;
		dialog_text = [];

func _on_menu_opened(value: bool) -> void:
	if(is_moving): return;
	if(value): stop = true;
	else: stop = false;
	
func _on_close_dialog() -> void:
	await get_tree().create_timer(.3).timeout
	stop = false;
	can_talk = true;
	
func npc_talk_on_area_entered(area: Area2D) -> void:
	can_talk = true;
	npc = area.get_parent();
	dialog_text = npc.dialog;
	area_type = GLOBAL.DialogAreaType.NPC;
	
func object_talk_on_area_entered(object: Area2D) -> void:
	can_talk = true;
	dialog_area = object.get_parent();
	dialog_text = object.dialog;
	area_type = GLOBAL.DialogAreaType.OBJECT;

func _on_get_on_bike(value: bool):
	if(is_moving): return;
	if(value): get_on_bike();
	else: get_off_bike();

#CHECKERS
func check_position_out_bounds():
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0 && percent_moved >= 1:
		position.x = floor(position.x / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE;
	elif(fmod(position.y, GLOBAL.TILE_SIZE) != 0.0) && percent_moved >= 1:
		position.y = floor(position.y / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE;

func check_for_dialogs() -> void:
	if(!can_talk || dialog_text.size() == 0): return;
	if Input.is_action_just_pressed("space"):
		var desired_step: Vector2 = GLOBAL.last_player_direction * (GLOBAL.TILE_SIZE / 2.0);
		update_dialog_rays(desired_step);
		#NPC
		if(area_type == GLOBAL.DialogAreaType.NPC && npc_ray_cast_2d.is_colliding()):
			if(npc && npc.name in DIALOG.dialog_count):
				dialog_text = DIALOG.get_next_dialog(npc.name, npc.location, dialog_text)
			open_npc_dialog(dialog_text);
		#OBJECT
		elif(area_type == GLOBAL.DialogAreaType.OBJECT && object_ray_cast_2d.is_colliding()):
			open_object_dialog(dialog_text);

func open_npc_dialog(text: Array):
	GLOBAL.emit_signal("start_dialog", text, self.name, npc.name, npc.location);
	stop = true;
	playback.travel("Idle");
	reset_moving();
	audio_player.stream = CONFIRM;
	audio_player.play();

func open_object_dialog(text: Array):
	var direction = GLOBAL.directions_array[dialog_area.talk_direction];
	if(direction != GLOBAL.last_player_direction && direction != Vector2.INF): return;
	GLOBAL.emit_signal("start_dialog", text, "", "", dialog_area.location);
	stop = true;
	playback.travel("Idle");
	reset_moving();
	audio_player.stream = CONFIRM;
	audio_player.play();

# ANIMATIONS
func enter_door_animation(area: Area2D) -> void:
	var delay_time := 0.1;
	if(area.type == GLOBAL.DoorType.OUT): delay_time = 0.2;
	if(GLOBAL.on_bike): get_off_bike(false);
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween();
	await tween.tween_property(sprite, "modulate:a", 0, delay_time).finished;
	stop = true;

func sit_on_chair_animation(area: Area2D) -> void:
	await get_tree().create_timer(.3).timeout;
	if(input_direction == Vector2.ZERO):
		set_blend_direction(area.sit_direction);
		chair_direction = area.sit_direction;
	if(GLOBAL.last_player_direction == Vector2.DOWN): 
		playback.travel("ChairDown");
	else: playback.travel("Chair");
	sit_on_chair = true;

func _on_cant_enter_door(area: Area2D) -> void:
	stuck_on_door = true;
	await get_tree().create_timer(.2).timeout;
	position = start_position;
	door_type = area.type;
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD);
	tween.tween_property(sprite, "position:y", sprite.position.y - 4, 0.2);

#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": GLOBAL.SaveType.PLAYER,
		"player": self.name,
		"position.x": position.x,
		"position.y": position.y,
		"direction.x": GLOBAL.last_player_direction.x,
		"direction.y": GLOBAL.last_player_direction.y,
		"on_bike": GLOBAL.on_bike
	}
	return data

#LOAD
func check_load_from_file():
	if(GLOBAL.player_data_to_load != null):
		await get_tree().create_timer(0.01).timeout;
		var data = GLOBAL.player_data_to_load;
		if(data != null):
			position.x = data["position.x"];
			position.y = data["position.y"];
			if(data.has("on_bike") && data["on_bike"]): get_on_bike();
			set_blend_direction(Vector2(data["direction.x"], data["direction.y"]));
			GLOBAL.player_data_to_load = null;

#UTILS
func connect_signals() -> void:
	GLOBAL.connect("cant_enter_door", _on_cant_enter_door);
	GLOBAL.connect("menu_opened", _on_menu_opened);
	GLOBAL.connect("get_on_bike", _on_get_on_bike);
	GLOBAL.connect("close_dialog", _on_close_dialog);

func set_blend_direction(direction: Vector2) -> void:
	for path in GLOBAL.blends: animation_tree.set(path, direction);

func update_block_rays() -> void:
	for ray in block_rays:
		var desired_step: Vector2 = input_direction * GLOBAL.TILE_SIZE / 2;
		ray.target_position = desired_step;
		ray.force_raycast_update();

func update_dialog_rays(desired_step: Vector2) -> void:
	for ray in dialog_rays:
		ray.target_position = desired_step;
		ray.force_raycast_update();

func round_percent_move() -> void:
# prevents jump when 2 tiles away and move towards a ledge
	if(!jumping_over_ledge && percent_moved >= 0.99): percent_moved = 1;

func show_dust_effect(value: bool) -> void:
	if(value): dust_effect.play();
	dust_effect.visible = value;

func finished_turning() -> void: player_state = PlayerState.IDLE;
