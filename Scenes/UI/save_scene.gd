extends CanvasLayer

@onready var player_stats = $PlayerStats;
@onready var selection = $Selection;
@onready var location = $PlayerStats/Location;
@onready var time = $PlayerStats/Time;
@onready var arrow = $Selection/TextureRect;
@onready var audio = $AudioStreamPlayer;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_SAVE_GAME = preload("res://Assets/Sounds/GUI save game.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");

enum MenuOptions { YES, NO }
var selected_option = 0;
var options_length = MenuOptions.keys().size();
var already_save = false;
var closing_menu = false;

func _ready():
	update_arrow();
	selection.visible = false;
	location.text = get_map_name();
	time.text = get_time_played();
	
	GLOBAL.connect("start_dialog", _on_dialog_start);
	GLOBAL.connect("system_dialog_finished", _on_dialog_finished);
	
	if(SETTINGS.selected_marker):
		player_stats.texture = SETTINGS.selected_marker;
		selection.texture = SETTINGS.selected_marker;

func _unhandled_input(event: InputEvent) -> void:
	if(
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		!selection.visible ||
		closing_menu
	): return;
	
	if(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	#ACCEPT
	elif(event.is_action_pressed("space")): select_option();

func handle_DOWN() -> void:
	audio.stream = GUI_SEL_CURSOR;
	audio.play();
	selected_option += 1;
	if(selected_option > options_length - 1): selected_option = MenuOptions.YES;
	update_arrow();

func handle_UP() -> void:
	audio.stream = GUI_SEL_CURSOR;
	audio.play();
	if(selected_option == MenuOptions.YES): selected_option = MenuOptions.NO;
	else: selected_option -= 1;
	update_arrow();

func select_option():
	match(selected_option):
		MenuOptions.NO: close_menu();
		MenuOptions.YES: handle_save()

func close_menu(sound = true):
	closing_menu = true;
	if(sound):
		audio.stream = GUI_MENU_CLOSE;
		audio.play();
		await audio.finished;
	call_deferred("queue_free");
	GLOBAL.emit_signal("close_dialog");

func handle_save() -> void:
	closing_menu = true;
	if(GLOBAL.no_saved_data || already_save): save_and_close();
	elif(!already_save):
		audio.stream = GUI_SEL_DECISION;
		audio.play();
		GLOBAL.emit_signal("start_dialog", 11);
		already_save = true;

func save_and_close() -> void:
	audio.stream = GUI_SAVE_GAME;
	audio.play();
	await audio.finished;
	MEMORY._save();
	close_menu(false);
	GLOBAL.no_saved_data = false;

func _on_dialog_start(_id: int) -> void: 
	selection.visible = false;
	closing_menu = false;

func _on_dialog_finished(): 
	await GLOBAL.timeout(.2);
	selection.visible = true;

func get_map_name() -> String:
	var map = get_node("/root/SceneManager/CurrentScene").get_child(0).name;
	var string: String = MAPS.location_string[map];
	return string.to_upper();

func get_time_played() -> String:
	var play_time = int(floor(GLOBAL.play_time));
	var hours = int(play_time / 3600)
	var minutes = int((play_time % 3600) / 60)
	var seconds = int(play_time % 60)
	var elapsed = "%02d:%02d:%02d" % [hours, minutes, seconds];
	return elapsed;

func update_arrow() -> void: arrow.position.y = 8 + (selected_option % options_length) * 14;
