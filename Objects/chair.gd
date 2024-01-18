extends Area2D

@export var sprite_image: Texture;
@export var position_when_sit = GLOBAL.Directions.UP;

@onready var sprite = $Sprite2D;
var sit_direction;

func _ready() -> void:
	sprite.texture = sprite_image;
	sit_direction = GLOBAL.directions_array[position_when_sit];
