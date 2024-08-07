extends Node2D

class_name SpawnController;
# Check for Spawn on Areas that have more than 1 spawn.

@onready var oak = $Oak;
@onready var tilemap = $TileMap;
@export var song: AudioStream;

var climate_canvas: CanvasLayer;

func _ready():
	if(song): AUDIO.play(song);
	GLOBAL.inside_house = false;
	var size = MAPS.get_map_size_and_emit(tilemap);
	create_climate(size);
	oak.set_blend_direction(GLOBAL.last_direction);
	GLOBAL.connect("time_of_day_changed", _on_climate_change);
	
	#COMING FROM HOUSE
	if(MAPS.spawn_position):
		oak.position = MAPS.spawn_position;
		MAPS.spawn_position = null;
		show_visit_panel(0.5);
		return;
	#COMING FROM SCENE
	if(MAPS.position_before_scene && MAPS.last_map != null):
		if(
			MAPS.last_map in LIBRARIES.MAPS.CONNECTIONS &&
			self.name in LIBRARIES.MAPS.CONNECTIONS[MAPS.last_map] &&
			MAPS.position_before_scene in LIBRARIES.MAPS.CONNECTIONS[MAPS.last_map][name]
		):
			var map_position = LIBRARIES.MAPS.CONNECTIONS[MAPS.last_map];
			oak.position = map_position[name][MAPS.position_before_scene];
			
	show_visit_panel();

func create_climate(size: Vector2) -> void:
	climate_canvas = CanvasLayer.new();
	climate_canvas.layer = 0;
	var night = ColorRect.new();
	night.size = size;
	night.self_modulate = Color(0, 0, 0, 0.98);
	climate_canvas.add_child(night);
	call_deferred("add_child", climate_canvas);
	var time = Time.get_time_dict_from_system();
	if("hour" in time):
		if(time.hour >= 6 && time.hour < 18):
			_on_climate_change(ENUMS.Climate.DAY);
		else: _on_climate_change(ENUMS.Climate.NIGHT);

func _on_climate_change(time: ENUMS.Climate) -> void:
	var nodes = get_tree().get_nodes_in_group("Lights");
	for light in nodes:
		light.visible = time == ENUMS.Climate.NIGHT;
	climate_canvas.visible = time == ENUMS.Climate.NIGHT;

func show_visit_panel(delay: float = 0.0) -> void:
	GLOBAL.emit_signal("visit_panel", self.name, delay);
