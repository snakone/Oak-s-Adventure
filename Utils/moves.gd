extends Node

func get_move(index: int):
	if(index in LIBRARIES.MOVES.LIST): 
		return LIBRARIES.MOVES.LIST[index];

func load_move_with_pp(move: Dictionary):
	var move_data = get_move(move.id).duplicate();
	move_data.pp = move.pp;
	return move_data;

func get_type_sprite(type: ENUMS.Types) -> Variant:
	if(type in LIBRARIES.MOVES.sprites_types):
		return LIBRARIES.MOVES.sprites_types[type];
	return null;
