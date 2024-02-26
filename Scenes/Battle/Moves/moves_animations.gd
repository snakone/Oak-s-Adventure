extends Node

var move_animations = {
	"tackle": preload("res://Scenes/Battle/Moves/tackle.tscn"),
	"quick attack": preload("res://Scenes/Battle/Moves/quick_attack.tscn")
}

func get_move_animation(move_name: String) -> Node2D:
	if(move_name in move_animations):
		var move = move_animations[move_name];
		return move.instantiate();
	return null;
