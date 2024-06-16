extends CharacterBody2D

const SPEED = 4;
const BIKE_SPEED = 6;

@onready var anim_tree = $AnimationTree;
@onready var shadow = $Shadow;
@onready var dust_effect = $DustEffect;
@onready var sprite = $Sprite2D;

@onready var block_ray_cast_2d = $BlockRayCast2D;
@onready var ledge_ray_cast_2d = $LedgeRayCast2D;
@onready var npc_ray_cast_2d = $NPCRayCast2D
@onready var object_ray_cast_2d = $ObjectRayCast2D;
@onready var block_rays = [block_ray_cast_2d, ledge_ray_cast_2d];
@onready var dialog_rays = [npc_ray_cast_2d, object_ray_cast_2d];

@onready var audio = $AudioStreamPlayer;
@onready var anim_player = $AnimationPlayer;
@onready var playback = anim_tree.get("parameters/playback");

const bike_texture = preload("res://Sprites/oak_bike.png");
const oak_texture = preload("res://Sprites/oak_sprite.png");
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const BLOCK = preload("res://Assets/Sounds/Player bump.ogg");
const PLAYER_JUMP = preload("res://Assets/Sounds/Player jump.ogg");

enum PlayerState { IDLE, TURNING, WALKING };

#DATA
var start_position = Vector2.UP;
var input_direction = Vector2();
var player_state = PlayerState.IDLE;
var percent_moved: float = 0;
var area_types := [DIALOG.Type.NONE];
var battle_data: Dictionary;

#STATES
var jumping_over_ledge = false;
var is_moving: bool = false;
var sit_on_chair = false;
var stuck_on_door = false;
var stop = false;
var ready_to_battle = false;
var can_talk = false;

#OBJECTS
var chair_direction: Vector2;
var cant_enter_door_direction: Vector2;
var door_type: GLOBAL.DoorType;

var dialog_data: Dictionary;
var dialog_id: int;

func _ready():
	connect_signals();
	check_load_from_file();
	if(GLOBAL.on_bike): get_on_bike();

func _physics_process(delta) -> void:
	GLOBAL.play_time += delta;
	if(
		stop ||
		player_state == PlayerState.TURNING || 
		GLOBAL.dialog_open || 
		GLOBAL.on_overlay ||
		GLOBAL.menu_open
	): return;
	elif(!is_moving && !GLOBAL.on_transition): process_player_input();
	elif(input_direction != Vector2.ZERO && !stuck_on_door): move(delta);
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
		if(stuck_on_door && door_type == GLOBAL.DoorType.IN):
			playback.travel("Idle");
			await GLOBAL.timeout(1);
			stuck_on_door = false;
			return;
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
	if(input_direction.y == 0): 
		input_direction.x = Input.get_axis("moveLeft", "moveRight");
	if(input_direction.x == 0): 
		input_direction.y = Input.get_axis("moveUp", "moveDown");
	if(input_direction != Vector2.ZERO && !GLOBAL.on_transition):
		GLOBAL.last_direction = input_direction;

func move(delta) -> void:
	playback.travel("Move");
	if(GLOBAL.on_bike): percent_moved += BIKE_SPEED * delta;
	else: percent_moved += SPEED * delta;
	
	round_percent_move();
	var ledge_colliding = (
		ledge_ray_cast_2d.is_colliding() && 
		input_direction == Vector2.DOWN
	);
	
	#BLOCK SOUND
	if(
		block_ray_cast_2d.is_colliding() && 
		!audio.playing && 
		!ledge_colliding && 
		!GLOBAL.on_transition
	):
		audio.stream = BLOCK;
		audio.play();
		
	elif(ledge_colliding || jumping_over_ledge): check_ledges();
	elif(!block_ray_cast_2d.is_colliding()): check_moving();
	else: reset_moving();

#MOVEMENT
func check_moving() -> void:
	if(percent_moved >= 1): stop_movement();
	else: update_position();

func update_position() -> void:
	var perct = input_direction * percent_moved;
	position = start_position + floor(GLOBAL.TILE_SIZE * perct); 

func stop_movement() -> void:
	position = start_position + (GLOBAL.TILE_SIZE * input_direction);
	check_position_out_bounds();
	reset_moving();
	check_for_battle();

func reset_moving() -> void:
	is_moving = false;
	percent_moved = 0;
	GLOBAL.emit_signal("player_moving", false);

#LEDGES
func check_ledges() -> void:
	if(percent_moved >= 2): stop_jumping();
	else: jump();

#JUMP
func jump() -> void:
	if(!audio.is_playing() && !jumping_over_ledge): play_audio(PLAYER_JUMP);
	jumping_over_ledge = true;
	var new_position = input_direction.y * GLOBAL.TILE_SIZE * percent_moved;
	position.y = GLOBAL.get_jumping_curvature(start_position.y, new_position);
	shadow.visible = true;

func stop_jumping() -> void:
	playback.travel("Idle");
	show_dust_effect(true);
	shadow.visible = false;
	position = start_position + (GLOBAL.TILE_SIZE * input_direction * 2);
	reset_moving();
	jumping_over_ledge = false;

#BIKE
func _on_get_on_bike(value: bool):
	if(is_moving): return;
	if(value): get_on_bike();
	else: get_off_bike();

func _on_bike_inside() -> void:
	playback.travel("Idle");
	reset_moving();
	GLOBAL.emit_signal("start_dialog", 13);

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
	if("Door" in area.name && area.can_be_opened): 
		_on_enter_door_animation(area);
	elif("Chair" in area.name): 
		_on_sit_on_chair_animation(area);
	elif("TalkArea" in area.name || "DialogArea" in area.name): 
		_on_talk_area_entered(area);

func _on_talk_area_entered(object: Area2D) -> void:
	await GLOBAL.timeout(.2);
	can_talk = true;
	dialog_id = object.get_parent().dialog_id;
	dialog_data = DIALOG.get_dialog(dialog_id);
	area_types.push_front(dialog_data.type);

func _on_area_2d_area_exited(area: Area2D) -> void:
	if("Chair" in area.name): sit_on_chair = false;
	elif("TalkArea" in area.name || "DialogArea" in area.name): 
		can_talk = false;
		area_types = [DIALOG.Type.NONE];

#MENU
func _on_menu_opened(value: bool) -> void:
	if(is_moving): return;
	if(value):
		stop = true;
		playback.travel("Idle");
		reset_moving();
	else: stop = false;

#CHECKERS
func check_position_out_bounds():
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0 && percent_moved >= 1:
		#position.x = floor(position.x / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE;
		print("WARNING: OUT OF BOUNDS (X)");
	elif(fmod(position.y, GLOBAL.TILE_SIZE) != 0.0) && percent_moved >= 1:
		#position.y = floor(position.y / GLOBAL.TILE_SIZE) * GLOBAL.TILE_SIZE;
		print("WARNING: OUT OF BOUNDS (Y)");

#DIALOGS
func check_for_dialogs() -> void:
	if(!can_talk): return;
	if Input.is_action_just_pressed("space"):
		var desired_step: Vector2 = GLOBAL.last_direction * (GLOBAL.TILE_SIZE / 2.0);
		update_dialog_rays(desired_step);
		if(
			DIALOG.Type.NPC in area_types && 
			npc_ray_cast_2d.is_colliding() &&
			!GLOBAL.healing
			): start_dialog_state(dialog_id);
		elif(
			DIALOG.Type.OBJECT in area_types &&
			object_ray_cast_2d.is_colliding()
		): open_object_dialog();
		elif(
			DIALOG.Type.PC in area_types &&
			object_ray_cast_2d.is_colliding()
		): GLOBAL.emit_signal("open_pc");

func open_object_dialog():
	var direction = GLOBAL.DIRECTIONS[dialog_data.direction];
	if(direction != GLOBAL.last_direction && direction != Vector2.INF): return;
	start_dialog_state(dialog_id);

func start_dialog_state(id: int) -> void:
	GLOBAL.emit_signal("start_dialog", id);
	playback.travel("Idle");
	reset_moving();
	play_audio(CONFIRM);

#BATTLE
func check_for_battle() -> void:
	if(ready_to_battle):
		playback.travel("Idle");
		stop = true;
		await GLOBAL.timeout(.4);
		#AUDIO
		match(battle_data.type):
			BATTLE.Type.WILD: AUDIO.play_battle_wild();
		#START
		GLOBAL.emit_signal("start_battle", battle_data);
		call_deferred("set_process", Node.PROCESS_MODE_DISABLED);

func set_battle_data(data: Dictionary) -> void:
	battle_data = data;
	ready_to_battle = true;

func _on_end_battle() -> void:
	await GLOBAL.timeout(.4);
	stop = false;
	call_deferred("set_process", Node.PROCESS_MODE_INHERIT);
	BATTLE.coming_from_battle = true;
	ready_to_battle = false;

# ANIMATIONS
#DOOR
func _on_enter_door_animation(area: Area2D) -> void:
	door_type = area.type;
	var delay = 0.15;
	if(area.flip_after_enter): MAPS.must_flip_sprite = true;
	if(area.category == GLOBAL.DoorCategory.TUNNEL): delay = 0;
	if(GLOBAL.on_bike && area.category != GLOBAL.DoorCategory.TUNNEL): 
		get_off_bike(false);
	var tween = get_tree().create_tween();
	tween.tween_property(sprite, "modulate:a", 0, delay);
	await tween.finished;
	stop = true;

func _on_cant_enter_door(_area: Area2D) -> void:
	stuck_on_door = true;
	playback.travel("Idle");
	play_audio(BLOCK);
	await audio.finished;
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC);
	tween.tween_property(
		sprite, "position:y", 
		sprite.position.y - 4, 0.15
	).set_ease(Tween.EASE_IN);
	
	tween.tween_property(
		sprite, "position:y", 
		sprite.position.y + 3, 0.1
	).set_ease(Tween.EASE_OUT);
	
	position = start_position;
	start_dialog_state(12);

#CHAIR
func _on_sit_on_chair_animation(area: Area2D) -> void:
	await GLOBAL.timeout(.2);
	if(is_moving): return;
	chair_direction = area.sit_direction;
	set_blend_direction(chair_direction);
	playback.travel("Chair");
	sit_on_chair = true;

#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": GLOBAL.SaveType.PLAYER,
		"player": self.name,
		"position.x": position.x,
		"position.y": position.y,
		"direction.x": GLOBAL.last_direction.x,
		"direction.y": GLOBAL.last_direction.y,
		"on_bike": GLOBAL.on_bike,
		"play_time": GLOBAL.play_time,
		"money": GLOBAL.current_money
	}
	return data

#LOAD
func check_load_from_file():
	if(GLOBAL.player_data_to_load != null):
		await GLOBAL.timeout(0.1);
		var data = GLOBAL.player_data_to_load;
		position.x = data["position.x"];
		position.y = data["position.y"];
		if(data.has("on_bike") && data["on_bike"]): get_on_bike();
		set_blend_direction(Vector2(data["direction.x"], data["direction.y"]));
		GLOBAL.play_time = data["play_time"];
		GLOBAL.player_data_to_load = null;
		GLOBAL.current_money = data["money"];

#UTILS
func connect_signals() -> void:
	GLOBAL.connect("cant_enter_door", _on_cant_enter_door);
	GLOBAL.connect("menu_opened", _on_menu_opened);
	GLOBAL.connect("get_on_bike", _on_get_on_bike);
	GLOBAL.connect("bike_inside", _on_bike_inside);
	GLOBAL.connect("close_battle", _on_end_battle);

func set_blend_direction(direction: Vector2) -> void:
	for path in GLOBAL.blends: anim_tree.set(path, direction);

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

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
