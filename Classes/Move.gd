extends Node

class_name Move

@export var audio_file: AudioStream = null;
@export var move_sprite = false;
@export var move_name: ENUMS.MoveNames;

@onready var anim_player = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;

const TAKE_TACKLE_HIT = preload("res://Assets/UI/Battle/Moves/take_tackle_hit.png");
const default_volume = -10;

var shadow: Sprite2D;

var take_hit: Sprite2D;
var current_sprite: AnimatedSprite2D;
var current_turn = BATTLE.Turn.NONE;

func play_attack(sprite: AnimatedSprite2D) -> void:
	check_take_hit();
	current_sprite = sprite;
	current_turn = BATTLE.current_turn;
	await GLOBAL.timeout(0.1);

	if(sprite != null):
		if(current_turn == BATTLE.Turn.PLAYER): 
			if(move_sprite): custom_animation();
			anim_player.play("Attack");
		elif(current_turn == BATTLE.Turn.ENEMY):
			if(move_sprite): custom_animation();
			anim_player.play("EnemyAttack");
		#SHADOW
		await GLOBAL.timeout(0.1);
		var parent = sprite.get_parent();
		if(parent.has_node("Shadow")):
			shadow = parent.get_node("Shadow");
			shadow.visible = false;

func emit_on_hit() -> void:
	play_sound();
	BATTLE.on_move_hit.emit();

func play_effective_sound() -> void:
	if(take_hit.texture == null): return;
	if(is_weak_attack()):
			play_sound(LIBRARIES.SOUNDS.BATTLE_DAMAGE_WEAK, -15);
	elif(is_effective_attack()):
			play_sound(LIBRARIES.SOUNDS.BATTLE_DAMAGE_SUPER, -15);
	else: play_sound(LIBRARIES.SOUNDS.DAMAGE_NORMAL, -15);

func is_weak_attack() -> bool:
	return (ENUMS.AttackResult.AWFULL in BATTLE.attack_result || 
		ENUMS.AttackResult.LOW in BATTLE.attack_result);

func is_effective_attack() -> bool:
	return (ENUMS.AttackResult.EFFECTIVE in BATTLE.attack_result || 
		ENUMS.AttackResult.FULMINATE in BATTLE.attack_result)

func _on_animation_finished(_name) -> void:
	if(take_hit.texture != null): 
		await GLOBAL.timeout(0.3);
	BATTLE.attack_finished.emit();

func custom_animation() -> void:
	var tween = get_tree().create_tween();
	var animation = LIBRARIES.MOVES.MOVE_ANIMATION[move_name];
	var key_value = current_sprite[animation.property];
	var array =  animation.values.player;
	if(current_turn == BATTLE.Turn.ENEMY): array = animation.values.enemy;
	
	for stat in array:
		tween.tween_property(
			current_sprite, 
			animation.property, 
			key_value + stat.value, 
			stat.duration
		);

func check_shadow() -> void:
	if(shadow != null):
		shadow.visible = true;

func check_take_hit() -> void:
	take_hit = get_node("TakeHit");
	if(ENUMS.AttackResult.NONE in BATTLE.attack_result):
		take_hit.texture = null;
	else: take_hit.texture = TAKE_TACKLE_HIT;

func play_sound(sound = audio_file, volume = default_volume) -> void:
	audio.stream = sound;
	audio.volume_db = volume;
	audio.play();
