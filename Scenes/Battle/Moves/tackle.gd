extends Node2D;

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio = $AudioStreamPlayer

func _ready():
	pass # Replace with function body.

func set_data_and_attack(sprite: Sprite2D) -> void:
	await GLOBAL.timeout(.1);
	if(sprite != null):
		sprite_2d = sprite;
		animation_player.play("attack");
		sprite.visible = false;

func emit_on_hit() -> void: 
	audio.play();
	BATTLE.on_move_hit.emit();

func _on_animation_finished(_name): BATTLE.attack_finished.emit();
