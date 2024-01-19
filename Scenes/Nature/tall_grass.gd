extends Node2D

@onready var animation_player = $AnimationPlayer;
@onready var texture_rect = $TextureRect;
@onready var grass_effect = $GrassEffect;

func _ready(): GLOBAL.connect("player_moving", reset_texture);

func _on_area_2d_body_entered(body) -> void:
	if(body.name == "Oak"):
		if(body.input_direction == Vector2.UP && !GLOBAL.on_bike):
			await GLOBAL.timeout(.1);
		animation_player.play("Stepped");

func _on_area_2d_body_exited(_body): texture_rect.visible = false;
func active_effect() -> void: grass_effect.play();
func reset_texture(value: bool): if(value): texture_rect.visible = false;
