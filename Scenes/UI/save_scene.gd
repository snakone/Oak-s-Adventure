extends CanvasLayer

@onready var player_stats = $PlayerStats;
@onready var location = $PlayerStats/Location;
@onready var time = $PlayerStats/Time;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

var want_to_save = false;

func _ready():
	location.text = MAPS.get_map_name();
	time.text = GLOBAL.get_time_played();
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
	player_stats.texture = SETTINGS.player_settings.marker;

func close_menu():
	GLOBAL.emit_signal("menu_opened", false);
	call_deferred("queue_free");

func handle_save() -> void:
	if(GLOBAL.no_saved_data || want_to_save): 
		save_and_close();
		return;
	
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	GLOBAL.start_dialog.emit(11);
	want_to_save = true;

func save_and_close() -> void:
	MEMORY._save();
	close_menu();

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func _on_selection_value_select(
	value: int,
	category: ENUMS.SelectionCategory
) -> void:
	if(category != ENUMS.SelectionCategory.BINARY): return;
	match value:
		int(ENUMS.BinaryOptions.YES): handle_save();
		int(ENUMS.BinaryOptions.NO): close_menu();
