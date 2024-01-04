extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var texture_rect = $TextureRect
var player_utils = preload("res://Utils/player_utils.gd").new()

var player_inside = false;

func _ready():
	get_tree().current_scene.get_node("Oak").connect("player_moving_down_signal", _on_moving_down_signal)

func _on_area_2d_body_entered(_body) -> void:
	animation_player.play("Stepped")
	player_inside = true;
	player_in_grass()
	
func player_in_grass() -> void:
	if(player_inside):
		await get_tree().create_timer(0.2).timeout
		texture_rect.visible = true
		texture_rect.z_index = 2;

func _on_area_2d_body_exited(body):
	player_inside = false;
	texture_rect.visible = false
	texture_rect.z_index = 0;
	
func _on_moving_down_signal():
	if(player_inside):
		texture_rect.visible = false
		texture_rect.z_index = 0;

