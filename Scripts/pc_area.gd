extends StaticBody2D

@export var dialog_id: int = 32;
@export var show_sprite = true;

@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var sprite_2d: Sprite2D = $Sprite2D;

func _ready() -> void:
	GLOBAL.connect("open_pc", _on_open_pc);
	GLOBAL.connect("close_pc", _on_close_pc);
	if(show_sprite): sprite_2d.visible = true;

func _on_open_pc() -> void:
	await GLOBAL.timeout(1);
	anim_player.play("PcOn");

func _on_close_pc() -> void:
	anim_player.play("PcOff");
	await anim_player.animation_finished;
	GLOBAL.on_pc = false;
