extends HouseController
@onready var poke_center_door: Area2D = $PokeCenterDoor;
@onready var selection: NinePatchRect = $Selection;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const heal_position = Vector2(112, 64);

func _ready() -> void:
	super();
	GLOBAL.on_poke_center = true;
	check_out_scene();
	
func check_out_scene() -> void:
	if(
			self.name in MAPS.CONNECTIONS &&
			MAPS.last_map in MAPS.CONNECTIONS[self.name]
		): 
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
		GLOBAL.emit_signal("start_dialog", 23);
		await GLOBAL.close_dialog;
		GLOBAL.emit_signal("start_dialog", 24);

func _on_heal_dialog_finished(): 
	await GLOBAL.timeout(.2);
	selection.set_visibility(true);

func _on_tree_exiting() -> void: GLOBAL.on_poke_center = false;

func _on_selection_value_selected(value: int) -> void:
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_heal();
		int(GLOBAL.BinaryOptions.NO): close_menu();

func handle_heal() -> void:
	print("HEAL ME!");

func close_menu(sound = true):
	print("close")
	GLOBAL.closing_menu_selection = true;
	if(sound):
		play_audio(GUI_MENU_CLOSE);
		await audio.finished;
	GLOBAL.emit_signal("close_dialog");
	GLOBAL.closing_menu_selection = false;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
