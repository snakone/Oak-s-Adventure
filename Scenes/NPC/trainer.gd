extends NPC

@export var trainer_id: ENUMS.Trainer = ENUMS.Trainer.NONE;
@export var end_dialog: int;
@export var after_defeat_dialog: int;
@export var battle_zone: ENUMS.BattleZones;
@export var battle_pokemon: Array[ENUMS.Pokedex];
@export var battle_range_level: Array[int];
@export var exclamation_offset = 0;
@export_range(1, 5) var view_range = 5;

@onready var trainer_container: Node2D = $Trainer;
@onready var trainer_ray_cast_2d: RayCast2D = $Trainer/TrainerRayCast2D;
@onready var trainer_timer: Timer = $Trainer/TrainerTimer;
@onready var exclamation: TextureRect = $Exclamation;

var walking_towards = false;
var already_defeated = false;
var insight = false;

func _ready() -> void:
	super();
	if(check_if_defeated()): return;
	trainer_timer.start();
	trainer_ray_cast_2d.target_position.y = view_range * GLOBAL.TILE_SIZE;
	connect_trainer_signals();
	update_trainer_raycast_direction();
	exclamation.position.x = exclamation_offset;
	
func check_if_defeated() -> bool:
	if(TRAINERS.is_already_defeated(trainer_id)):
		already_defeated = true;
		dialog_id = after_defeat_dialog;
		type = ENUMS.NPCType.DEFAULT;
		free_trainer_after_defeat();
		if(trainer_container != null): 
			trainer_container.queue_free();
		return true;
	return false;

func _on_start_dialog(id: int) -> void:
	await get_tree().process_frame;
	var pre_data = DIALOG.get_dialog(id);
	if(!can_start_dialog(pre_data, id)): return;
	is_talking = true;
	dialog_data = pre_data;
	if(walking_towards): return;
	if(!insight): 
		set_npc_direction();
		if(trainer_container != null): 
			trainer_container.queue_free();

func _on_close_dialog() -> void:
	if(can_start_battle()):
		start_trainer_battle();
		return;
	is_talking = false;
	dialog_data = {};

func _on_trainer_timer_timeout() -> void:
	if(trainer_ray_cast_2d.is_colliding()):
		var collider = trainer_ray_cast_2d.get_collider();
		if(not collider is CharacterBody2D): return;
		insight = true;
		trainer_timer.stop();
		trainer_container.queue_free();
		await start_walking_towards(collider);

#WALK TO PLAYER
func start_walking_towards(collider: CharacterBody2D) -> void:
	AUDIO.stop();
	walking_towards = true;
	collider.trainer_insight = true;
	await GLOBAL.timeout(0.2);
	await show_trainer_exclamation();
	var steps = get_intermediate_points(self.position, collider.position);
	var direction = frame_directions[facing_direction];
	for step in steps: 
		await move(direction);
	await GLOBAL.timeout(0.2);
	await start_battle_dialog(collider, direction);

func start_battle_dialog(collider: CharacterBody2D, direction: Vector2) -> void:
	var next_direction = (direction / GLOBAL.TILE_SIZE) * -1;
	collider.set_blend_direction(next_direction);
	GLOBAL.last_direction = next_direction;
	await GLOBAL.timeout(0.1);
	collider.trainer_insight = false;
	is_talking = true;
	GLOBAL.start_dialog.emit(dialog_id);

#TRAINER BATTLE
func start_trainer_battle() -> void:
	walking_towards = false;
	var battle_data = {
		"enemies": battle_pokemon,
		"zone": battle_zone,
		"type": ENUMS.BattleType.TRAINER,
		"levels": battle_range_level,
		"trainer_id": trainer_id
	}
	
	oak.set_battle_data(battle_data);
	oak.check_for_battle();
	process_mode = Node.PROCESS_MODE_DISABLED;

#END
func _on_end_battle(battle_data: Dictionary) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
	await GLOBAL.timeout(0.4);
	if(is_same_trainer(battle_data)):
		already_defeated = true;
		TRAINERS.add_defeat_trainer(battle_data.trainer_id);
		type = ENUMS.NPCType.DEFAULT;
		GLOBAL.start_dialog.emit(end_dialog);
		await GLOBAL.close_dialog;
		oak.dialog_id = after_defeat_dialog;
		dialog_id = after_defeat_dialog;
		free_trainer_after_defeat();
		insight = false;
		oak.battle_data = {};

func show_trainer_exclamation(delay: float = 0.2) -> void:
	if(!already_defeated):
		await GLOBAL.timeout(delay);
		exclamation.visible = true;
		await GLOBAL.timeout(1);
		exclamation.visible = false;

func can_start_battle() -> bool:
	if(
		!already_defeated &&
		"trainer_id" in dialog_data && 
		dialog_data.trainer_id == trainer_id
		): return true;
	return false;

func is_same_trainer(battle_data: Dictionary) -> bool:
	if(
		battle_data.type == ENUMS.BattleType.TRAINER &&
		"trainer_id" in battle_data && 
		battle_data.trainer_id != null &&
		trainer_id == battle_data.trainer_id
		): return true;
	return false;

func free_trainer_after_defeat() -> void:
	if(state == ENUMS.NPCStates.IDLE):
		can_down = true;
		can_left = true;
		can_right = true;
		can_up = true;

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

func update_trainer_raycast_direction() -> void:
	if(trainer_ray_cast_2d != null):
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

func connect_trainer_signals() -> void:
	GLOBAL.connect("close_battle", _on_end_battle);
	trainer_timer.connect("timeout", _on_trainer_timer_timeout);
	self.connect("trainer_change_position", update_trainer_raycast_direction);
