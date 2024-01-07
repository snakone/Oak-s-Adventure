extends Node2D
@onready var oak = $Oak;

func _ready():
	oak.position = MAPS.LIBRARY.OakHouse.start_position;
	oak.set_blend_direction(MAPS.LIBRARY.OakHouse.spawn_position);
