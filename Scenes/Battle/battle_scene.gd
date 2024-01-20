extends Node

@onready var texture_rect = $TextureRect

const FIELD_BG = preload("res://Assets/UI/Battle/field_bg.png");
const SNOW_BG = preload("res://Assets/UI/Battle/snow_bg.png");

@onready var zones_array = [
	FIELD_BG,
	null,
	SNOW_BG
];

var data: Dictionary;

func _ready():
	set_battle_ui();
	
func set_battle_ui() -> void:
	var background = zones_array[data.zone];
	texture_rect.texture = background;

func set_battle_data(battle_data: Dictionary):
	data = battle_data;
	
func _unhandled_input(event):
	if(event.is_action_pressed("escape")):
		GLOBAL.emit_signal("close_battle");
