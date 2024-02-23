extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Control/NinePatchRect;
@onready var cursor: TextureRect = $Control/NinePatchRect/Cursor;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const PC_ACCESS = preload("res://Assets/Sounds/PC access.ogg");

const POKEMON_BOXES = "res://Scenes/UI/pokemon_boxes.tscn";

enum PcOptions { BILL, OAK, POKEDEX, OFF }

var can_use_menu = false;
var selected_option = 0;
var options_length = PcOptions.keys().size();
var scene_manager: Node2D;

func _ready() -> void:
	GLOBAL.on_pc = true;
	set_marker();
	start_dialog();
	scene_manager = get_parent();
	GLOBAL.connect("scene_opened", _on_scene_opened);

func start_dialog() -> void:
	play_audio(CONFIRM);
	GLOBAL.start_dialog.emit(32);
	await GLOBAL.close_dialog;
	GLOBAL.start_dialog.emit(33);
	await GLOBAL.timeout(1.8);
	nine_rect.visible = true;
	await GLOBAL.timeout(0.2);
	can_use_menu = true;

func _on_scene_opened(value: bool, node_name: String) -> void:
	#CLOSED
	if(!value):
		can_use_menu = true;
		process_mode = Node.PROCESS_MODE_INHERIT;
		nine_rect.visible = true;
		GLOBAL.on_boxes = false;
	scene_manager.get_node(node_name).queue_free();

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		GLOBAL.party_open ||
		!can_use_menu
	): return;
	if(Input.is_action_just_pressed("backMenu")): close_menu();
	elif(
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
		selected_option = PcOptions.BILL;
	update_cursor();

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(selected_option == PcOptions.BILL): 
		selected_option = PcOptions.OFF;
	else: selected_option -= 1;
	update_cursor();

func select_option() -> void:
	play_audio(CONFIRM);
	match(selected_option):
		PcOptions.BILL: select_storage()
		PcOptions.OAK: select_oak()
		PcOptions.POKEDEX: select_pokedex()
		PcOptions.OFF: close_menu()

func select_storage() -> void:
	can_use_menu = false;
	nine_rect.visible = false;
	GLOBAL.start_dialog.emit(37);
	await GLOBAL.close_dialog;
	GLOBAL.on_boxes = true;
	play_audio(PC_ACCESS);
	await audio.finished;
	scene_manager.transition_to_scene(POKEMON_BOXES, true, false);
	process_mode = Node.PROCESS_MODE_DISABLED;

func select_oak() -> void:
	print("Oak");

func select_pokedex() -> void:
	print("Pokedex");

func close_menu() -> void:
	can_use_menu = false;
	play_audio(GUI_MENU_CLOSE);
	nine_rect.visible = false;
	await GLOBAL.timeout(0.3);
	GLOBAL.close_pc.emit();
	GLOBAL.on_pc = false;

func update_cursor() -> void:
	var perct = (selected_option % options_length) * 16;
	cursor.position.y = 12 + perct;

#MARKERS
func set_marker() -> void:
	if(SETTINGS.selected_marker):
		nine_rect.texture = SETTINGS.selected_marker;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
