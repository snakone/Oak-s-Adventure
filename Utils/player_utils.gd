extends Node

enum FacingDirection { LEFT, RIGHT, UP, DOWN };
var facing_direction = FacingDirection.UP;

func need_to_turn(input_direction: Vector2) -> bool:
	var new_facing_direction;
	if(input_direction.x < 0):
		new_facing_direction = FacingDirection.LEFT
	elif(input_direction.x > 0):
		new_facing_direction = FacingDirection.RIGHT
	elif(input_direction.y < 0):
		new_facing_direction = FacingDirection.UP
	elif(input_direction.y > 0):
		new_facing_direction = FacingDirection.DOWN
		
	if(facing_direction != new_facing_direction):
		facing_direction = new_facing_direction;
		return true;

	return false;
	
