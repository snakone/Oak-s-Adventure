extends Node2D;

@onready var player_sprite = $PlayerSprite;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var enemy_sprite = $EnemySprite;

enum Turn { PLAYER, ENEMY, NONE }
var current_sprite: Sprite2D;

func set_data_and_attack(sprite: Sprite2D, current_turn: Turn) -> void:
	current_sprite = sprite;
	await GLOBAL.timeout(.1);
	if(sprite != null):
		if(current_turn == Turn.PLAYER): 
			player_sprite.texture = sprite.texture;
			anim_player.play("Attack");
		else:
			enemy_sprite.texture = sprite.texture;
			anim_player.play("EnemyAttack");
		sprite.visible = false;

func emit_on_hit() -> void: 
	audio.play();
	BATTLE.on_move_hit.emit();

func _on_animation_finished(_name):
	current_sprite.visible = true;
	BATTLE.attack_finished.emit();
