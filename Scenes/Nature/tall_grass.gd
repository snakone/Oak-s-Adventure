extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var texture_rect = $TextureRect
@onready var grass_effect = $GrassEffect

var inside_grass = false;

func _ready(): GLOBAL.connect("player_moving", reset_texture)

func _on_area_2d_body_entered(body) -> void:
	if(body.name == "Oak"):
		animation_player.play("Stepped");
		inside_grass = true;

func active_effect() -> void:
	grass_effect.play();

func reset_texture(value: bool):
	if(value && inside_grass): texture_rect.visible = false

func _on_area_2d_body_exited(_body):
	inside_grass = false;
