extends CanvasLayer

@onready var control = $Control;
@onready var cursor = $Control/NinePatchRect/Cursor;
@onready var audio = $AudioStreamPlayer;
@onready var nine_rect = $Control/NinePatchRect;

enum ScreenLoaded { NONE, MENU, POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS }
enum MenuOptions { POKEDEX, PARTY, BAG, OAK, SAVE, OPTIONS, EXIT }

const party_screen_path = "res://Scenes/UI/party_screen.tscn";
const pokedex_screen_path = "res://Scenes/UI/Pokedex/pokedex_screen.tscn";                                                      
const save_scene_path = "res://Scenes/UI/save_scene.tscn";
const profile_scene_path = "res://Scenes/UI/profile.tscn";
const profile_scene_node = "CurrentScene/Profile";
const bag_screen_path = "res://Scenes/UI/BAG/bag_screen.tscn";

var options_length = MenuOptions.keys().size();
var selected_option = 0;
var is_player_moving = false;
var screen_loaded = ScreenLoaded.NONE;
var can_use_menu = true;

func _ready():
	if(SETTINGS.selected_marker): nine_rect.texture = SETTINGS.selected_marker;
	control.visible = false;
	update_cursor();
	connect_signals();

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		is_player_moving || 
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		GLOBAL.on_battle ||
		!can_use_menu ||
		GLOBAL.insight ||
		GLOBAL.on_pc
	): return;
	
	#BIKE ON/OFF
	if(
		Input.is_action_just_pressed("bike") && 
		!GLOBAL.inside_house && 
		!GLOBAL.menu_open
	): GLOBAL.emit_signal("get_on_bike", !GLOBAL.on_bike);
	
	#BIKE INSIDE HOUSE
	if(
		Input.is_action_just_pressed("bike") && 
		GLOBAL.inside_house && 
		!GLOBAL.menu_open
	): GLOBAL.emit_signal("bike_inside");

	match (screen_loaded):
		ScreenLoaded.NONE: if(Input.is_action_just_pressed("menu") && !GLOBAL.on_overlay): 
			handle_MENU();
		ScreenLoaded.MENU:
			if(
				Input.is_action_just_pressed("menu") || 
				Input.is_action_just_pressed("backMenu") ||
				Input.is_action_just_pressed("escape")): close_menu()
			elif(
				Input.is_action_just_pressed("moveDown") || 
				Input.is_action_just_pressed("ui_down")): handle_DOWN();
			elif(
				Input.is_action_just_pressed("moveUp") || 
				Input.is_action_just_pressed("ui_up")): handle_UP();
			elif(Input.is_action_just_pressed("space")): select_option();
		ScreenLoaded.OAK: 
			if(
				Input.is_action_just_pressed("space") || 
				Input.is_action_just_pressed("backMenu")): close_profile();

func select_option() -> void:
	match(selected_option):
		MenuOptions.POKEDEX: open_pokedex()
		MenuOptions.PARTY: open_party()
		MenuOptions.BAG: open_bag()
		MenuOptions.OAK: open_profile()
		MenuOptions.SAVE: handle_save()
		MenuOptions.EXIT: close_menu()

#CLOSE
func close_menu() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	control.visible = false;
	GLOBAL.menu_open = false;
	screen_loaded = ScreenLoaded.NONE;
	selected_option = MenuOptions.POKEDEX;
	GLOBAL.emit_signal("menu_opened", false);
	update_cursor();

#POKEDEX
func open_pokedex() -> void:
	can_use_menu = false;
	screen_loaded = ScreenLoaded.POKEDEX;
	GLOBAL.on_overlay = true;
	play_audio(LIBRARIES.SOUNDS.GUI_POKEDEX_OPEN);
	await audio.finished;
	control.visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.go_to_scene(pokedex_screen_path, true, false);

#PARTY
func open_party() -> void:
	can_use_menu = false;
	screen_loaded = ScreenLoaded.PARTY;
	GLOBAL.on_overlay = true;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	await audio.finished;
	control.visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.go_to_scene(party_screen_path, true, false);

#PROFILE
func open_profile() -> void:
	can_use_menu = false;
	screen_loaded = ScreenLoaded.OAK;
	GLOBAL.on_overlay = true;
	play_audio(LIBRARIES.SOUNDS.TRAINER_CARD_OPEN);
	await audio.finished;
	control.visible = false;
	GLOBAL.go_to_scene(profile_scene_path, true, false);
	await GLOBAL.timeout(0.8);
	can_use_menu = true;

#BAG
func open_bag() -> void:
	can_use_menu = false;
	screen_loaded = ScreenLoaded.BAG;
	GLOBAL.on_overlay = true;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	await audio.finished;
	control.visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.go_to_scene(bag_screen_path, true, false);

func _on_scene_opened(value: bool, _node_name: String) -> void:
	#CLOSED
	if(GLOBAL.on_overlay || value): return;
	if(!GLOBAL.on_battle && GLOBAL.menu_open): activate_menu();

func close_profile() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	GLOBAL.on_overlay = false;
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/Profile");

func handle_MENU() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_OPEN);
	control.visible = true;
	screen_loaded = ScreenLoaded.MENU;
	GLOBAL.emit_signal("menu_opened", true);
	GLOBAL.menu_open = true;

func handle_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = MenuOptions.POKEDEX;
	update_cursor();

func handle_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(selected_option == MenuOptions.POKEDEX): 
		selected_option = MenuOptions.EXIT;
	else: selected_option -= 1;
	update_cursor();

func handle_save() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SAVE_CHOICE);
	control.visible = false;
	GLOBAL.menu_open = false;
	screen_loaded = ScreenLoaded.NONE;
	selected_option = MenuOptions.POKEDEX;
	GLOBAL.go_to_scene(save_scene_path, false, false);
	GLOBAL.start_dialog.emit(10);
	update_cursor();

func connect_signals() -> void:
	GLOBAL.connect("player_moving", _on_player_moving);
	GLOBAL.connect("scene_opened", _on_scene_opened);
	GLOBAL.connect("close_menu", close_menu);

func update_cursor() -> void:
	var perct = (selected_option % options_length) * 16;
	cursor.position.y = 12 + perct;

func activate_menu() -> void:
	can_use_menu = true;
	control.visible = true;
	screen_loaded = ScreenLoaded.MENU;
	process_mode = Node.PROCESS_MODE_INHERIT;

func _on_player_moving(value: bool) -> void: is_player_moving = value;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
