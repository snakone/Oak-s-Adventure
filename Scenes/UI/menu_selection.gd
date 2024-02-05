extends NinePatchRect

signal value_selected(value: GLOBAL.BinaryOptions);
@export var selection_position: Vector2 = Vector2(176, 70);

@onready var arrow = $TextureRect;
@onready var audio = $AudioStreamPlayer;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");

var selected_option = 0;
var options_length = GLOBAL.BinaryOptions.keys().size();

func _ready():
	position = selection_position;
	update_arrow();
	visible = false;
	
	if(SETTINGS.selected_marker):
		texture = SETTINGS.selected_marker;

func set_visibility(value: bool) -> void: visible = value;

func _unhandled_input(event: InputEvent) -> void:
	if(
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		!visible ||
		GLOBAL.party_open ||
		GLOBAL.closing_menu_selection ||
		!event is InputEventKey
	): return;
	
	if(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	elif(Input.is_action_just_pressed("space")): select_option();

func handle_DOWN() -> void:
	play_audio(GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = int(GLOBAL.BinaryOptions.YES);
	update_arrow();

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(selected_option == GLOBAL.BinaryOptions.YES): 
		selected_option = int(GLOBAL.BinaryOptions.NO);
	else: selected_option -= 1;
	update_arrow();

func select_option(): 
	value_selected.emit(selected_option);
	visible = false;
	selected_option = 0;
	update_arrow();

func update_arrow() -> void: arrow.position.y = 8 + (selected_option % options_length) * 14;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
