extends Node2D;

@onready var player_sprite = $PlayerSprite;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var enemy_sprite = $EnemySprite;

var enemy: bool;
var current_sprite: Sprite2D;

func set_data_and_attack(sprite: Sprite2D, is_enemy: bool) -> void:
	current_sprite = sprite;
	enemy = is_enemy;
	await GLOBAL.timeout(.1);
	if(sprite != null):
		if(!is_enemy): 
			player_sprite.texture = sprite.texture;
			anim_player.play("Attack");
		else:
			enemy_sprite.texture = sprite.texture;
			anim_player.play("EnemyAttack");
		sprite.visible = false;

func emit_on_hit() -> void: 
	audio.play();
	BATTLE.on_move_hit.emit(enemy);

func _on_animation_finished(_name):
	current_sprite.visible = true;
	BATTLE.attack_finished.emit();