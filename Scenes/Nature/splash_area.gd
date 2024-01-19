extends Node2D
@onready var splash_effect = $SplashEffect

func active_effect() -> void:
	await GLOBAL.timeout(.1);
	splash_effect.visible = true;
	splash_effect.play();

func _on_area_2d_body_entered(body): if(body.name == "Oak"): active_effect();
func _on_area_2d_body_exited(_body): splash_effect.visible = false;
