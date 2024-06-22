extends Node

var last_bag_screen = int(ENUMS.BagScreen.ITEMS);

var items = [
	{ "id": ENUMS.Item.POKEBALL, "amount": 2 },
	{ "id": ENUMS.Item.GREATBALL, "amount": 1 }
];

func _ready(): add_to_group(GLOBAL.group_name);

func get_item_by_id(id: ENUMS.Item) -> Variant:
	for item in LIBRARIES.ITEMS.LIST:
		if(item["id"] == id): return item;
	return null;

func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.BAG,
		"bag_items": items,
		"last_bag_screen": last_bag_screen,
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("bag_items" in data): 
		items = data["bag_items"];
		
	if("last_bag_screen" in data): 
		last_bag_screen = data["last_bag_screen"];
