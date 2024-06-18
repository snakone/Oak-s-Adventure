extends Node

class_name Move

@export var audio_file: AudioStream = null;
@export var move_sprite = false;
@export var move_name: ENUMS.MoveNames;

@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;

const TAKE_TACKLE_HIT = preload("res://Assets/UI/Battle/Moves/take_tackle_hit.png");
enum Turn { PLAYER, ENEMY, NONE }
const default_volume = -10;

var take_hit: Sprite2D;
var current_sprite: AnimatedSprite2D;
var current_turn = Turn.NONE;

func play_attack(sprite: AnimatedSprite2D) -> void:
	check_take_hit();
	current_sprite = sprite;
	current_turn = BATTLE.current_turn;
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
	if(take_hit.texture == null): return;
	audio.stop();
	play_sound(LIBRARIES.SOUNDS.DAMAGE_NORMAL, -15);

func _on_animation_finished(_name):
	BATTLE.attack_finished.emit();

func attack() -> void:
	var tween = get_tree().create_tween();
	var move = LIBRARIES.MOVES.MOVE_ANIMATION[move_name];
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

func check_take_hit() -> void:
	take_hit = get_node("TakeHit");
	if(ENUMS.AttackResult.NONE in BATTLE.attack_result):
		take_hit.texture = null;
	else: take_hit.texture = TAKE_TACKLE_HIT;
