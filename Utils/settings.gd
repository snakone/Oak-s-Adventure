extends Node

enum Markers { ORANGE, BLUE, GREEN, WHITE }
enum TextSpeed { SLOW, NORMAL, HIGH }
enum BattleScene { OFF, ON }

const MARKER_ORANGE = preload("res://Assets/UI/marker_orange.png");
const MARKER_BLUE = preload("res://Assets/UI/marker_blue.png");
const MARKER_GREEN = preload("res://Assets/UI/marker_green.png");
const MARKER_WHITE = preload("res://Assets/UI/marker_white.png");

signal settings_changed;

var speed_map = {
	TextSpeed.NORMAL: 0.05,
	TextSpeed.SLOW: 0.1,
	TextSpeed.HIGH: 0.035
}

@onready var marker_switch = {
	Markers.ORANGE: MARKER_ORANGE,
	Markers.BLUE: MARKER_BLUE,
	Markers.GREEN: MARKER_GREEN,
	Markers.WHITE: MARKER_WHITE
}

var player_settings = {
	"marker_type": Markers.WHITE,
	"marker": MARKER_WHITE,
	"text_speed": SETTINGS.TextSpeed.NORMAL
}

func _ready():
	add_to_group(GLOBAL.group_name);

func set_settings(settings: Dictionary) -> void:
	set_marker(settings.marker);
	player_settings["text_speed"] = settings.text_speed;

func set_key(key: String, value: Variant) -> void:
	player_settings[key] = value;

func set_marker(marker: Markers) -> void:
	var selected_type = int(marker);
	player_settings["marker"] = marker_switch[selected_type];
	player_settings["marker_type"] = selected_type;

func get_settings_to_json() -> Dictionary:
	return {
		"marker": player_settings.marker_type,
		"text_speed": player_settings.text_speed
	}

func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.SETTINGS,
		"settings": get_settings_to_json(),
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("settings" in data): set_settings(data["settings"]);
	settings_changed.emit();
