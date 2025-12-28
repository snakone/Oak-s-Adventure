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
@onready var playback = anim_tree.get("parameters/playback");

const bike_texture = preload("res://Sprites/oak_bike.png");
const oak_texture = preload("res://Sprites/oak_sprite.png");
const SLEEP_TIME = 5;
var sleep_scene = "res://Scenes/Miscellania/sleep_scene.tscn";
enum PlayerState { IDLE, TURNING, WALKING };

#DATA
var start_position = Vector2.UP;
var input_direction = Vector2();
var player_state = PlayerState.IDLE;
var percent_moved: float = 0;
var area_types := [DIALOG.Type.NONE];
var battle_data: Dictionary;
var trainer_insight = false;
var trainer: StaticBody2D;

#STATES
var jumping_over_ledge = false;
var is_moving: bool = false;
var stuck_on_door = false;
var stop = false;
var ready_to_battle = false;
var can_talk = false;
var sleeping = false;
var can_pick = false;

#OBJECTS
var chair_direction: Vector2;
var cant_enter_door_direction: Vector2;
var door_type: ENUMS.DoorType;

var dialog_data: Dictionary;
var dialog_id: int;

var pickable_data: Variant;

func _ready():
	connect_signals();
	check_load_from_file();
	if(GLOBAL.on_bike): get_on_bike();

func _physics_process(delta) -> void:
	GLOBAL.play_time += delta;
	if(!_can_process()): return;
	elif(_can_input()): process_player_input();
	elif(_can_move()): move(delta);
	else: _idle_process();

func process_player_input() -> void:
	set_direction();
	check_for_dialogs();
	check_for_pickables();
	if(input_direction != Vector2.ZERO):
		set_blend_direction(input_direction);
		update_block_rays();
		#STUCK ON DOOR
		if(stuck_on_door && door_type == ENUMS.DoorType.IN):
			playback.travel("Idle");
			player_state = PlayerState.IDLE;
			await GLOBAL.timeout(1);
			stuck_on_door = false;
			return;
		#TURN
		if(GLOBAL.need_to_turn(input_direction)):
			player_state = PlayerState.TURNING;
			playback.travel("Turn");
		#DEFAULT
		else:
			start_position = position;
			is_moving = true;
			GLOBAL.emit_signal("player_moving", true);
	else: 
		playback.travel("Idle");
		player_state = PlayerState.IDLE;

func set_direction() -> void:
	if(input_direction.y == 0): 
		input_direction.x = Input.get_axis("moveLeft", "moveRight");
	if(input_direction.x == 0): 
		input_direction.y = Input.get_axis("moveUp", "moveDown");
	if(input_direction != Vector2.ZERO && !GLOBAL.on_transition):
		GLOBAL.last_direction = input_direction;

func move(delta) -> void:
	playback.travel("Move");
	player_state = PlayerState.WALKING;
	if(GLOBAL.on_bike): percent_moved += BIKE_SPEED * delta;
	else: percent_moved += SPEED * delta;
	
	round_percent_move();
	var ledge_colliding = (
		ledge_ray_cast_2d.is_colliding() && 
		input_direction == Vector2.DOWN
	);
	#BLOCK SOUND
	if(should_play_block_sound(ledge_colliding)):
		audio.stream = LIBRARIES.SOUNDS.BLOCK;
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
	if(!audio.is_playing() && !jumping_over_ledge): 
		play_audio(LIBRARIES.SOUNDS.PLAYER_JUMP);
	jumping_over_ledge = true;
	var new_position = input_direction.y * GLOBAL.TILE_SIZE * percent_moved;
	position.y = GLOBAL.get_jumping_curvature(start_position.y, new_position);
	shadow.visible = true;

func stop_jumping() -> void:
	playback.travel("Idle");
	player_state = PlayerState.IDLE;
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
	player_state = PlayerState.IDLE;
	reset_moving();
	GLOBAL.start_dialog.emit(13);

func get_on_bike():
	AUDIO.play_bike();
	if(!GLOBAL.bike_sound): 
		play_audio(LIBRARIES.SOUNDS.BIKE_SOUND);
	GLOBAL.on_bike = true;
	GLOBAL.bike_sound = true;
	sprite.texture = bike_texture;
	sprite.offset.x = -3;
	sprite.offset.y = -7;

func get_off_bike(stop_sound = true):
	if(stop_sound): 
		AUDIO.stop_and_play_last_song();
	GLOBAL.on_bike = false;
	GLOBAL.bike_sound = false;
	sprite.texture = oak_texture;
	sprite.offset.x = 0;
	sprite.offset.y = -4;

# LISTENERS
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area == null): return;
	if("Door" in area.name && area.can_be_opened): 
		_on_enter_door_animation(area);
	elif("TalkArea" in area.name || "DialogArea" in area.name): 
		_on_talk_area_entered(area);
	elif("PickableArea" in area.name): _on_pickable_area_entered(area);

func _on_talk_area_entered(area: Area2D) -> void:
	if(area == null): return;
	await GLOBAL.timeout(0.1);
	can_talk = true;
	dialog_id = area.get_parent().dialog_id;
	if(is_area_trainer(area)): 
		trainer = area.get_parent();
	dialog_data = DIALOG.get_dialog(dialog_id);
	area_types = [dialog_data.type];

func _on_pickable_area_entered(area: Area2D) -> void:
	if(area == null): return;
	await GLOBAL.timeout(0.1);
	can_pick = true;
	var parent = area.get_parent();
	area_types = [DIALOG.Type.PICKABLE];
	pickable_data = {
		"pickable": parent.pickable,
		"direction": parent.direction,
		"id": parent.id
	}

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area == null): return;
	if("TalkArea" in area.name || "DialogArea" in area.name): 
		can_talk = false;
		dialog_id = -1;
		if(is_area_trainer(area)):
			trainer = null;
			trainer_insight = false;
	elif("PickableArea" in area.name): 
		can_pick = false;
		pickable_data = null;

#MENU
func _on_menu_opened(value: bool) -> void:
	if(is_moving): return;
	if(value):
		stop = true;
		playback.travel("Idle");
		player_state = PlayerState.IDLE;
		reset_moving();
	else: stop = false;

#CHECKERS
func check_position_out_bounds():
	if fmod(position.x, GLOBAL.TILE_SIZE) != 0.0 && percent_moved >= 1:
		print("WARNING: OUT OF BOUNDS (X)");
	elif(fmod(position.y, GLOBAL.TILE_SIZE) != 0.0) && percent_moved >= 1:
		print("WARNING: OUT OF BOUNDS (Y)");

#DIALOGS
func check_for_dialogs() -> void:
	if(!can_talk || dialog_id == -1): return;
	if Input.is_action_just_pressed("space"):
		var desired_step: Vector2 = GLOBAL.last_direction * (GLOBAL.TILE_SIZE / 2.0);
		update_dialog_rays(desired_step);
		#NPC
		if(is_npc_dialog() || is_shop_dialog()): 
			var collider = npc_ray_cast_2d.get_collider();
			start_dialog_state(collider.dialog_id);
		#TRAINER
		elif(is_trainer_dialog()): open_trainer_dialog();
		#OBJECT
		elif(is_object_dialog()): open_object_dialog();
		#PC
		elif(is_pc_dialog()):
			GLOBAL.on_pc = true;
			GLOBAL.emit_signal("open_pc");

func open_trainer_dialog() -> void:
	if(trainer != null && !trainer.already_defeated):
		AUDIO.stop();
		can_talk = false;
		await trainer.show_trainer_exclamation(0);
	start_dialog_state(dialog_id, trainer == null);

func open_object_dialog() -> void:
	var direction = GLOBAL.DIRECTIONS[dialog_data.direction];
	if(direction != GLOBAL.last_direction && direction != Vector2.INF): return;
	var collider = object_ray_cast_2d.get_collider();
	start_dialog_state(collider.dialog_id);

func start_dialog_state(id: int, sound = true) -> void:
	GLOBAL.start_dialog.emit(id);
	playback.travel("Idle");
	player_state = PlayerState.IDLE;
	reset_moving();
	if(sound): play_audio(LIBRARIES.SOUNDS.CONFIRM);

#PICKABLES
func check_for_pickables() -> void:
	if(!can_pick || pickable_data == null): return;
	if Input.is_action_just_pressed("space"):
		var desired_step: Vector2 = GLOBAL.last_direction * (GLOBAL.TILE_SIZE / 2.0);
		update_dialog_rays(desired_step);
		if(is_pickable_dialog()): open_pickable_dialog();

func open_pickable_dialog() -> void:
	var direction = GLOBAL.DIRECTIONS[pickable_data.direction];
	if(direction != GLOBAL.last_direction && direction != Vector2.INF): return;
	start_pickable_state();

func start_pickable_state() -> void:
	GLOBAL.emit_signal("pick_item", pickable_data);
	playback.travel("Idle");
	player_state = PlayerState.IDLE;
	reset_moving();
	play_audio(LIBRARIES.SOUNDS.ITEM_GET);

#BATTLE
func check_for_battle() -> void:
	if(ready_to_battle || trainer_insight):
		playback.travel("Idle");
		player_state = PlayerState.IDLE;
		stop = true;
		await GLOBAL.timeout(0.4);
		#START
		if(battle_data != {}): 
			GLOBAL.emit_signal("start_battle", battle_data);
			call_deferred("set_process", Node.PROCESS_MODE_DISABLED);

func set_battle_data(data: Dictionary) -> void:
	battle_data = data;
	ready_to_battle = true;

func _on_end_battle(data: Dictionary) -> void:
	await GLOBAL.timeout(0.4);
	stop = false;
	call_deferred("set_process", Node.PROCESS_MODE_INHERIT);
	BATTLE.coming_from_battle = true;
	ready_to_battle = false;
	battle_data = {};
	if(data.type == ENUMS.BattleType.TRAINER):
		area_types = [DIALOG.Type.NPC];
		can_talk = true;

# ANIMATIONS
#DOOR
func _on_enter_door_animation(area: Area2D) -> void:
	door_type = area.type;
	var delay = 0.15;
	if(area.flip_after_enter): MAPS.must_flip_sprite = true;
	if(area.category == ENUMS.DoorCategory.TUNNEL): delay = 0;
	if(GLOBAL.on_bike && area.category != ENUMS.DoorCategory.TUNNEL): 
		get_off_bike(false);
	var tween = get_tree().create_tween();
	tween.tween_property(sprite, "modulate:a", 0, delay);
	await tween.finished;
	stop = true;

func _on_cant_enter_door(_area: Area2D) -> void:
	stuck_on_door = true;
	playback.travel("Idle");
	player_state = PlayerState.IDLE;
	play_audio(LIBRARIES.SOUNDS.BLOCK);
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

#SELECTION
func _on_selection_value_select(
	value: ENUMS.BinaryOptions,
	category: ENUMS.SelectionCategory
) -> void:
	if(value == ENUMS.BinaryOptions.NO): return;
	match category:
		ENUMS.SelectionCategory.SLEEP: handle_sleep();

#SLEEP ZZZ
func handle_sleep() -> void:
	sleeping = true;
	playback.travel("SleepFromLeft");
	AUDIO.stop();
	await GLOBAL.timeout(1);
	GLOBAL.go_to_scene(sleep_scene, true, false);
	await GLOBAL.timeout(SLEEP_TIME);
	PARTY.healh_party_pokemon();
	playback.travel("WakeToLeft");
	await GLOBAL.timeout(1);
	GLOBAL.start_dialog.emit(56);
	await GLOBAL.close_dialog;
	sleeping = false;
	set_blend_direction(GLOBAL.DIRECTIONS[ENUMS.Directions.LEFT]);
	player_state = PlayerState.IDLE;
	AUDIO.stop_and_play_last_song();
	
#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.PLAYER,
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

# prevents jump when 2 tiles away and move towards a ledge
func round_percent_move() -> void:
	if(!jumping_over_ledge && percent_moved >= 0.99): percent_moved = 1;

func show_dust_effect(value: bool) -> void:
	if(value): dust_effect.play();
	dust_effect.visible = value;

func finished_turning() -> void: player_state = PlayerState.IDLE;
func _can_input() -> bool: return !is_moving && !GLOBAL.on_transition;
func _can_move() -> bool: return input_direction != Vector2.ZERO && !stuck_on_door;

func _can_process() -> bool:
	if(stop || sleeping ||
	player_state == PlayerState.TURNING || 
	GLOBAL.dialog_open || 
	GLOBAL.on_overlay ||
	GLOBAL.menu_open ||
	GLOBAL.on_pc
	): return false;
	return true;

func is_area_trainer(area: Area2D) -> bool:
	if("TalkArea" in area.name && 
		area.get_parent().type == ENUMS.NPCType.TRAINER):
			return true;
	return false;

func is_npc_dialog() -> bool:
	if(DIALOG.Type.NPC in area_types && 
		npc_ray_cast_2d.is_colliding()): 
			return true;
	return false;

func is_shop_dialog() -> bool:
	if(DIALOG.Type.SHOP in area_types && 
		npc_ray_cast_2d.is_colliding()): 
			return true;
	return false;

func is_trainer_dialog() -> bool:
	if(DIALOG.Type.TRAINER in area_types && 
		npc_ray_cast_2d.is_colliding()):
			return true;
	return false;

func is_object_dialog() -> bool:
	if(DIALOG.Type.OBJECT in area_types &&
		object_ray_cast_2d.is_colliding()):
			return true;
	return false;

func is_pc_dialog() -> bool:
	if(DIALOG.Type.PC in area_types &&
		object_ray_cast_2d.is_colliding()):
			return true;
	return false;

func is_pickable_dialog() -> bool:
	if(DIALOG.Type.PICKABLE in area_types && 
		object_ray_cast_2d.is_colliding()):
			return true;
	return false;

func should_play_block_sound(ledge_colliding: bool) -> bool:
	if(block_ray_cast_2d.is_colliding() && 
		!audio.playing && 
		!ledge_colliding && 
		!GLOBAL.on_transition
	): return true;
	return false;

func _idle_process() -> void:
	playback.travel("Idle");
	player_state = PlayerState.IDLE;
	is_moving = false;
	GLOBAL.emit_signal("player_moving", false);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func connect_signals() -> void:
	GLOBAL.connect("cant_enter_door", _on_cant_enter_door);
	GLOBAL.connect("menu_opened", _on_menu_opened);
	GLOBAL.connect("get_on_bike", _on_get_on_bike);
	GLOBAL.connect("bike_inside", _on_bike_inside);
	GLOBAL.connect("close_battle", _on_end_battle);
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
