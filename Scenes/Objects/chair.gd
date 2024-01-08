extends Area2D

@export var position_when_sit = GLOBAL.DIRECTIONS.UP;
var sit_direction;

func _ready() -> void: 
	sit_direction = GLOBAL.directions_array[position_when_sit];
