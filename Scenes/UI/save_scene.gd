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

enum Options { YES, NO }
var selected_option = 0;
var options_length = Options.keys().size();
var want_to_save = false;
var closing_menu = false;

func _ready():
	update_arrow();
	selection.visible = false;
	location.text = MAPS.get_map_name();
	time.text = GLOBAL.get_time_played();
	
	GLOBAL.connect("start_dialog", _on_dialog_start);
	GLOBAL.connect("system_dialog_finished", _on_system_dialog_finished);
	
	if(SETTINGS.selected_marker):
		player_stats.texture = SETTINGS.selected_marker;
		selection.texture = SETTINGS.selected_marker;

func _unhandled_input(event: InputEvent) -> void:
	if(
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		!selection.visible ||
		GLOBAL.on_battle ||
		closing_menu
	): return;
	
	if(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	elif(event.is_action_pressed("space")): select_option();

func handle_DOWN() -> void:
	play_audio(GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): selected_option = Options.YES;
	update_arrow();

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(selected_option == Options.YES): selected_option = Options.NO;
	else: selected_option -= 1;
	update_arrow();

func select_option():
	match(selected_option):
		Options.NO: close_menu();
		Options.YES: handle_save()

func close_menu(sound = true):
	closing_menu = true;
	if(sound):
		play_audio(GUI_MENU_CLOSE);
		await audio.finished;
	GLOBAL.emit_signal("close_dialog");
	GLOBAL.emit_signal("menu_opened", false);
	call_deferred("queue_free");

func handle_save() -> void:
	if(GLOBAL.no_saved_data || want_to_save): 
		save_and_close();
		return;
	
	play_audio(GUI_SEL_DECISION);
	GLOBAL.emit_signal("start_dialog", 11);
	want_to_save = true;

func save_and_close() -> void:
	play_audio(GUI_SAVE_GAME);
	await audio.finished;
	MEMORY._save();
	close_menu(false);
	GLOBAL.no_saved_data = false;

func _on_dialog_start(_id: int) -> void: 
	selection.visible = false;
	closing_menu = false;

func _on_system_dialog_finished(): 
	await GLOBAL.timeout(.2);
	selection.visible = true;

func update_arrow() -> void: arrow.position.y = 8 + (selected_option % options_length) * 14;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
