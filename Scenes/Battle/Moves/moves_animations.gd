extends Node

var move_animations = {
	ENUMS.MoveNames.TACKLE: preload("res://Scenes/Battle/Moves/tackle.tscn"),
	ENUMS.MoveNames.QUICK_ATTACK: preload("res://Scenes/Battle/Moves/quick_attack.tscn")
}

func get_move_animation(id: ENUMS.MoveNames) -> Node2D:
	if(id in move_animations):
		var move = move_animations[id];
		return move.instantiate();
	return move_animations[ENUMS.MoveNames.TACKLE].instantiate();
