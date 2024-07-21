extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var selected: ColorRect = $Body/Container/Selected;
@onready var text_speed_option: RichTextLabel = $Body/Container/VBoxContainer/TextSpeed/Option;
@onready var frame_option: RichTextLabel = $Body/Container/VBoxContainer/Frame/Option;
@onready var container: NinePatchRect = $Body/Container;

enum Slots { TEXT, BATTLE, FRAME, CANCEL }

const DEFAULT_SELECT_POSITION = 9;
var selected_slot = int(Slots.TEXT);
var selected_text_speed = int(SETTINGS.TextSpeed.NORMAL);
var selected_theme = 0;

var slots_size = 0;
var text_speed_size = 0;
var markers_size = 0;
var exiting = false;

var speed_label = {
	SETTINGS.TextSpeed.NORMAL: "NORMAL",
	SETTINGS.TextSpeed.SLOW: "SLOW",
	SETTINGS.TextSpeed.FAST: "FAST"
}

func _ready() -> void:
	slots_size = Slots.keys().size();
	text_speed_size = SETTINGS.TextSpeed.keys().size();
	markers_size = SETTINGS.marker_switch.keys().size();
	load_settings();
	

func load_settings() -> void:
	var text_spd = int(SETTINGS.player_settings.text_speed);
	text_speed_option.text = speed_label[text_spd];
	selected_text_speed = text_spd;
	
	var current_marker = int(SETTINGS.player_settings.marker_type);
	frame_option.text = "TYPE " + str(current_marker + 1);
	selected_theme = current_marker;
	container.texture = SETTINGS.player_settings.marker;

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		exiting
	): return;
	#CLOSE
	if(Input.is_action_just_pressed("backMenu") ||
		Input.is_action_just_pressed("space")): close_settings();
	#DOWN
	elif(Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	#UP
	elif(Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(Input.is_action_just_pressed("moveRight") || 
		Input.is_action_just_pressed("ui_right")): handle_RIGHT();
	#LEFT
	elif(Input.is_action_just_pressed("moveLeft") || 
		Input.is_action_just_pressed("ui_left")): handle_LEFT();

func handle_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_slot += 1;
	if(selected_slot >= slots_size):
		selected_slot = 0;
	update_selected_option();

func handle_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_slot -= 1;
	if(selected_slot < 0): 
		selected_slot = slots_size - 1;
	update_selected_option();

func handle_RIGHT() -> void:
	if(selected_slot != int(Slots.CANCEL)):
		match selected_slot:
			Slots.TEXT: handle_text_speed(1)
			Slots.BATTLE: pass
			Slots.FRAME: handle_theme(1)

func handle_LEFT() -> void:
	if(selected_slot != int(Slots.CANCEL)):
		match selected_slot:
			Slots.TEXT: handle_text_speed(-1)
			Slots.BATTLE: pass
			Slots.FRAME: handle_theme(-1)

func handle_text_speed(value: int) -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_text_speed += value;
	if(selected_text_speed >= text_speed_size):
		selected_text_speed = 0;
	elif(selected_text_speed < 0):
		selected_text_speed = text_speed_size - 1;
	text_speed_option.text = speed_label[selected_text_speed];
	SETTINGS.set_key("text_speed", selected_text_speed);

func handle_theme(value: int) -> void:
	selected_theme += value;
	if(selected_theme >= markers_size):
		selected_theme = 0;
	elif(selected_theme < 0):
		selected_theme = markers_size - 1;
	frame_option.text = "TYPE " + str(selected_theme + 1);
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	SETTINGS.set_marker(selected_theme);
	SETTINGS.settings_changed.emit();
	container.texture = SETTINGS.player_settings.marker;

func update_selected_option() -> void:
	selected.position.y = DEFAULT_SELECT_POSITION + (selected_slot * 14);

func close_settings() -> void:
	exiting = true;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await audio.finished;
	GLOBAL.on_overlay = false;
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/SettingsScreen");

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
