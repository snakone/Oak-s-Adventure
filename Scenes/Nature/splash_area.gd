extends Node2D
@onready var splash_effect = $SplashEffect

func _on_area_2d_body_entered(body):
	if(body.name == "Oak"): active_effect();

func active_effect() -> void:
	await get_tree().create_timer(0.1).timeout
	splash_effect.visible = true;
	splash_effect.play();

func _on_area_2d_body_exited(_body):
	splash_effect.visible = false;
