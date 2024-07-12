extends Node

var boxes_array: Array = [];

func _ready(): 
	add_to_group(GLOBAL.group_name);
	boxes_array = LIBRARIES.BOXES.boxes_array.duplicate();

func add_pokemon_to_box(poke: Object) -> void:
	var index = find_first_empty_slot();
	if(index != null): 
		boxes_array[index.i][index.j] = poke;

func find_first_empty_slot() -> Variant:
	for i in range(0, boxes_array.size()):
		for j in range(0, boxes_array[i].size()):
			if(boxes_array[i][j] == null): return {"i": i, "j": j};
	return null;

func create_boxes_from_json(boxes: Array) -> Array:
	for i in range(0, boxes.size()):
		for j in range(0, boxes[i].size()):
			if(boxes[i][j] != null):
				var poke = boxes[i][j];
				var new_poke = Pokemon.new(poke);
				boxes[i][j] = new_poke;
	return boxes;

func healh_boxes_pokemon() -> void:
	for box in boxes_array:
		for poke in box:
			if(poke != null):
				poke.data.death = false;
				poke.data.current_hp = poke.data.battle_stats["HP"];

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
				for prop in PARTY.ERASE_PROPS: new_data.erase(prop);
				new_data.battle_moves = poke.create_moves();
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
