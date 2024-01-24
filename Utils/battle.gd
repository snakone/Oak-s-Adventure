extends Node

signal dialog_finished()
enum Type { WILD, TRAINER, ELITE, SPECIAL }

enum Zones {
	FIELD = 0,
	EARTH = 1,
	SNOW = 2,
	CITY = 3,
	ROCK = 4,
	SPECIAL = 5
}

const tile_density = 1325.0;
const modifire = 1.0;

func pokemon_encounter() -> bool:
	randomize()
	var tile_barrier = randi_range(0, 2879)
	if tile_barrier <= tile_density * modifire:
		randomize()
		var rand: int = randi_range(0, 100)
		if(rand < tile_density / 10):
			return true
	return false
