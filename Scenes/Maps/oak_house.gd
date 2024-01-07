extends Node2D
@onready var oak = $Oak;

func _ready():
	if(oak):
		oak.position = MAPS.LIBRARY.OakHouse.start_position;
		oak.set_spawn(MAPS.LIBRARY.OakHouse.spawn_position)

