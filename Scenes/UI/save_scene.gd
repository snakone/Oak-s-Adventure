extends CanvasLayer

@onready var player_stats = $PlayerStats;
@onready var location = $PlayerStats/Location;
@onready var time = $PlayerStats/Time;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const SAVE_GAME = preload("res://Assets/Sounds/save game.mp3");

var want_to_save = false;
const selection_category = GLOBAL.SelectionCategory.BINARY;

func _ready():
	location.text = MAPS.get_map_name();
	time.text = GLOBAL.get_time_played();
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
	
	if(SETTINGS.selected_marker):
		player_stats.texture = SETTINGS.selected_marker;

func close_menu():
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
	MEMORY._save();
	close_menu();

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func _on_selection_value_select(
	value: int,
	category: GLOBAL.SelectionCategory
) -> void:
	if(category != selection_category): return;
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_save();
		int(GLOBAL.BinaryOptions.NO): close_menu();
