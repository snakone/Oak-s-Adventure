extends NinePatchRect

@export var selection_position: Vector2 = Vector2(176, 70);

@onready var cursor = $Cursor;
@onready var audio = $AudioStreamPlayer;

var selected_option = 0;
var options_length = ENUMS.BinaryOptions.keys().size();
var id: ENUMS.SelectionCategory;

func _ready():
	position = selection_position;
	update_cursor();
	visible = false;
	if(SETTINGS.selected_marker): texture = SETTINGS.selected_marker;

func set_visibility(
	value: bool,
	data = {
		"category": ENUMS.SelectionCategory.BINARY,
		"selected": ENUMS.BinaryOptions.YES
	}) -> void:
	if(value): BATTLE.can_use_menu = false;
	await GLOBAL.timeout(0.1);
	visible = value;
	id = data.category;
	if("selected" in data): selected_option = data.selected;
	update_cursor();

func _unhandled_input(event: InputEvent) -> void:
	if(
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		!visible ||
		GLOBAL.on_overlay ||
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
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = int(ENUMS.BinaryOptions.YES);
	update_cursor();

func handle_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(selected_option == ENUMS.BinaryOptions.YES): 
		selected_option = int(ENUMS.BinaryOptions.NO);
	else: selected_option -= 1;
	update_cursor();

func select_option(): 
	GLOBAL.selection_value_select.emit(selected_option, id);
	visible = false;
	selected_option = 0;
	update_cursor();

func update_cursor() -> void:
	var perct = (selected_option % options_length) * 14;
	cursor.position.y = 8 + perct;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
