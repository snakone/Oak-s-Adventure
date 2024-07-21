extends Node2D

@export var oak: CharacterBody2D;
@export var light_texture: Texture;

@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var point_light_2d: PointLight2D = $PointLight2D;

const bike_texture = preload("res://Sprites/oak_bike.png");
const oak_texture = preload("res://Sprites/oak_sprite.png");

const DEFAULT_OFFSET = Vector2(0, 17);
const BIKE_OFFSET = Vector2(-3, 17);

func _ready() -> void:
	point_light_2d.texture = light_texture;
	sprite_2d.visible = true;
	GLOBAL.connect("get_on_bike", _on_get_on_bike);
	await GLOBAL.timeout(0.2);
	if(GLOBAL.on_bike): get_on_bike();

func _process(_delta: float) -> void: 
	sprite_2d.position = oak.position;
	sprite_2d.frame = oak.sprite.frame;

#BIKE
func _on_get_on_bike(value: bool):
	if(oak.is_moving): return;
	if(value): get_on_bike();
	else: get_off_bike();

func get_on_bike() -> void:
	sprite_2d.texture = bike_texture;
	sprite_2d.offset = BIKE_OFFSET;
	
func get_off_bike() -> void:
	sprite_2d.texture = oak_texture;
	sprite_2d.offset = DEFAULT_OFFSET;
