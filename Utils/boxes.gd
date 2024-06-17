extends Node

var boxes_array: Array = [];

func _ready(): 
	add_to_group(GLOBAL.group_name);
	boxes_array = LIBRARIES.BOXES.boxes_array.duplicate();

func create_boxes_from_json(boxes: Array) -> Array:
	for i in range(0, boxes.size()):
		for j in range(0, boxes[i].size()):
			if(boxes[i][j] != null):
				var poke = boxes[i][j];
				var new_poke = Pokemon.new(poke);
				boxes[i][j] = new_poke;
	return boxes;

#SAVE
func get_boxes_as_json() -> Array:
	var array = [];
	var size = boxes_array.size();
	array.resize(size);
	for i in range(0, size):
		array[i] = LIBRARIES.BOXES.get_empty_box();
	
	for i in range(0, size):
		for j in range(0, boxes_array[i].size()):
			if(boxes_array[i][j] != null):
				var poke = boxes_array[i][j];
				var new_data = poke.data.duplicate();
				for prop in PARTY.ERASE_PROPS: 
					new_data.erase(prop);
				var new_moves = [];
				for move in poke.data.battle_moves.duplicate():
					new_moves.push_back({
						"name": move.name,
						"pp": move.pp,
						"id": move.id
					})
				new_data.battle_moves = new_moves;
				array[i][j] = new_data;
	return array;

func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.BOXES,
		"boxes": get_boxes_as_json(),
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("boxes" in data): 
		boxes_array = create_boxes_from_json(data["boxes"]);
