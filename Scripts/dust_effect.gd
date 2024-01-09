extends AnimatedSprite2D

func _ready(): frame = 0;
func _on_animation_finished() -> void: visible = false;
