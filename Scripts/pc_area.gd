extends StaticBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer;

@export var dialog_id: int;

func _ready() -> void:
	GLOBAL.connect("open_pc", _on_open_pc);
	GLOBAL.connect("close_pc", _on_close_pc);

func _on_open_pc() -> void:
	await GLOBAL.timeout(1);
	anim_player.play("PcOn");

func _on_close_pc() -> void:
	anim_player.play("PcOff");
