extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var texture_rect = $TextureRect
var player_utils = preload("res://Utils/player_utils.gd").new()
@onready var grass_effect = $GrassEffect

func _ready():
	get_tree().current_scene.get_node("Oak").connect("player_moving", reset_texture)

func _on_area_2d_body_entered(_body) -> void:
	animation_player.play("Stepped")

func active_effect() -> void:
	grass_effect.play();

func reset_texture():
	texture_rect.visible = false

