extends Node

class_name Move

@export var audio_file: AudioStream = null;
@export var move_sprite = false;
@export var move_name: MOVES.MoveNames;

@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;

enum Turn { PLAYER, ENEMY, NONE }
const default_volume = -10;

var current_sprite: AnimatedSprite2D;
var current_turn = Turn.NONE;

func play_attack(sprite: AnimatedSprite2D, turn: Turn) -> void:
	current_sprite = sprite;
	current_turn = turn;
	await GLOBAL.timeout(0.1);
	if(sprite != null):
		if(current_turn == Turn.PLAYER): 
			if(move_sprite): attack();
			anim_player.play("Attack");
		elif(current_turn == Turn.ENEMY):
			if(move_sprite): attack();
			anim_player.play("EnemyAttack");

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
	BATTLE.attack_finished.emit();

func attack() -> void:
	var tween = get_tree().create_tween();
	var move = MOVES.MOVE_ANIMATION[move_name];
	var key_value = current_sprite[move.property];
	var array =  move.values.player;
	if(current_turn == Turn.ENEMY): array = move.values.enemy;
	
	for stat in array:
		tween.tween_property(
			current_sprite, 
			move.property, 
			key_value + stat.value, 
			stat.duration
		);
