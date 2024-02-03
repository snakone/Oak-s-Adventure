extends Node

class_name Move

@export var audio_file: AudioStream = null;

@onready var player_sprite = $PlayerSprite;
@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var enemy_sprite = $EnemySprite;

enum Turn { PLAYER, ENEMY, NONE }

var current_sprite: Sprite2D;
var default_volume = -10;

func play_attack(sprite: Sprite2D, current_turn: Turn) -> void:
	current_sprite = sprite;
	await GLOBAL.timeout(.1);
	if(sprite != null):
		if(current_turn == Turn.PLAYER): 
			player_sprite.texture = sprite.texture;
			anim_player.play("Attack");
		else:
			enemy_sprite.texture = sprite.texture;
			anim_player.play("EnemyAttack");
		current_sprite.visible = false;

func emit_on_hit() -> void:
	play_sound();
	BATTLE.on_move_hit.emit();

func play_sound(sound = audio_file, volume = default_volume) -> void:
	audio.stream = sound;
	audio.volume_db = volume;
	audio.play();

func play_effective_sound() -> void:
	audio.stop();
	play_sound(BATTLE.BATTLE_SOUNDS.DAMAGE_NORMAL, -15);

func _on_animation_finished(_name):
	current_sprite.visible = true;
	BATTLE.attack_finished.emit();
