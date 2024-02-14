extends HouseController
@onready var poke_center_door: Area2D = $PokeCenterDoor;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

const heal_position = Vector2(112, 64);
var healing = false;

func _ready() -> void:
	super();
	GLOBAL.on_poke_center = true;
	check_out_scene();
	GLOBAL.connect("selection_value_selected", _on_selection_value_selected);
	
func check_out_scene() -> void:
	if(self.name in MAPS.CONNECTIONS &&
		MAPS.last_map in MAPS.CONNECTIONS[self.name]): 
			poke_center_door.spawn_position = MAPS.CONNECTIONS[self.name][MAPS.last_map];

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		oak.is_moving || 
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		GLOBAL.menu_open ||
		GLOBAL.party_open
	): return;
	
	if(
		Input.is_action_just_pressed("space") &&
		oak.position == heal_position &&
		GLOBAL.last_direction == Vector2.UP
	):
		healing = true;
		GLOBAL.emit_signal("start_dialog", 23);
		await GLOBAL.close_dialog;
		healing = false;

func _on_tree_exiting() -> void: GLOBAL.on_poke_center = false;

func _on_selection_value_selected(value: int) -> void:
	if(!healing): return;
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_heal();

func handle_heal() -> void:
	print("HEAL ME!");
