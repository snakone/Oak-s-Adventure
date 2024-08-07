extends Node

var last_bag_screen = int(ENUMS.BagScreen.ITEMS);

var items = [];

func _ready(): add_to_group(GLOBAL.group_name);

func get_item_by_id(id: ENUMS.Item) -> Variant:
	for item in LIBRARIES.ITEMS.LIST:
		if(item["id"] == id): return item;
	return null;

func get_item_amount(id: ENUMS.Item) -> int:
	for item in items:
		if(item != null && "amount" in item && item["id"] == id):
			return item.amount;
	return -1;

func add_item(id: ENUMS.Item, amount: int) -> void:
	for i in range(0, items.size()):
		var item = items[i];
		if(item.id == id):
			items[i].amount += amount;
			return;
	items.push_back({"id": id, "amount": amount});

func remove_item(id: ENUMS.Item, amount: int = 1) -> void:
	for i in range(0, items.size()):
		var item = items[i];
		if(item.id == id):
			items[i].amount -= amount;
			if(items[i].amount <= 0): items.erase(item);
			return;

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
