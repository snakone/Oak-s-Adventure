extends CanvasLayer

@onready var player_stats = $PlayerStats;
@onready var selection = $Selection;
@onready var location = $PlayerStats/Location;
@onready var time = $PlayerStats/Time;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

const GUI_SAVE_GAME = preload("res://Assets/Sounds/GUI save game.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");

var want_to_save = false;

func _ready():
	location.text = MAPS.get_map_name();
	time.text = GLOBAL.get_time_played();
	
	GLOBAL.connect("start_dialog", _on_dialog_start);
	GLOBAL.connect("system_dialog_finished", _on_system_dialog_finished);
	
	if(SETTINGS.selected_marker):
		player_stats.texture = SETTINGS.selected_marker;

func close_menu(sound = true):
	GLOBAL.closing_menu_selection = true;
	if(sound):
		play_audio(GUI_MENU_CLOSE);
		await audio.finished;
	GLOBAL.emit_signal("close_dialog");
	GLOBAL.emit_signal("menu_opened", false);
	call_deferred("queue_free");
	GLOBAL.closing_menu_selection = false;

func handle_save() -> void:
	if(GLOBAL.no_saved_data || want_to_save): 
		save_and_close();
		return;
	
	play_audio(GUI_SEL_DECISION);
	GLOBAL.emit_signal("start_dialog", 11);
	want_to_save = true;

func save_and_close() -> void:
	GLOBAL.closing_menu_selection = true;
	play_audio(GUI_SAVE_GAME);
	await audio.finished;
	MEMORY._save();
	close_menu(false);
	GLOBAL.no_saved_data = false;

func _on_dialog_start(_id: int) -> void: 
	selection.visible = false;
	GLOBAL.closing_menu_selection = false;

func _on_system_dialog_finished(): 
	await GLOBAL.timeout(.2);
	selection.set_visibility(true);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func _on_selection_value_selected(value: int) -> void:
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_save();
		int(GLOBAL.BinaryOptions.NO): close_menu();
