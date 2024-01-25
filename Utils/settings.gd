extends Node

enum Markers { ORANGE, BLUE, GREEN }

const MARKER_ORANGE = preload("res://Assets/UI/marker_orange.png");
const MARKER_BLUE = preload("res://Assets/UI/marker_blue.png");
const MARKER_GREEN = preload("res://Assets/UI/marker_green.png");

@onready var marker_switch = {
	Markers.ORANGE: MARKER_ORANGE,
	Markers.BLUE: MARKER_BLUE,
	Markers.GREEN: MARKER_GREEN
}

var selected_type: Markers;
var selected_marker: Resource;

func _ready():
	selected_marker = marker_switch[Markers.ORANGE];
	selected_type = Markers.ORANGE;

var player_settings: Dictionary = {
	"marker": selected_marker,
	"marker_type": selected_type
}

func set_settings(settings: Dictionary) -> void:
	selected_marker = settings.marker;
	selected_type = settings.marker_type;
