extends StaticBody2D

@export var pickable: ENUMS.Item;
@export var amount = 1;
@export var direction = ENUMS.Directions.ALL;
@export var area: ENUMS.Locations;
@export var number: int = 1;
@export var texture = preload("res://Sprites/pickable.png");

@onready var sprite_2d: Sprite2D = $Sprite2D

const PICKABLE_DIALOG = 59;

var uuid = preload("res://uuid.gd").new();
var id;

func _ready() -> void:
	check_if_already_picked();
	GLOBAL.connect("pick_item", _on_pick_item);
	id = uuid.v4();
	if(texture): sprite_2d.texture = texture;

func check_if_already_picked() -> void:
	if(str(area) in MAPS.pickable_by_map):
		var pick_area = MAPS.pickable_by_map[str(area)];
		if(str(pickable) in pick_area):
			var item = pick_area[str(pickable)];
			if(str(number) in item && item[str(number)]):
				handle_pick();
				queue_free();
				return;
	sprite_2d.visible = true;

func _on_pick_item(data: Dictionary) -> void:
	if(data.id != id): return;
	var item = BAG.get_item_by_id(data.pickable);
	handle_pick();
	GLOBAL.emit_signal(
		"create_dialog", 
		PICKABLE_DIALOG, 
		generate_text(item.name, amount)
	);
	BAG.add_item(data.pickable, amount);
	MAPS.pickable_by_map[str(area)][str(pickable)][str(number)] = true;
	await GLOBAL.timeout(0.2);
	queue_free();

func handle_pick() -> void:
	get_node("PickableArea").emit_signal("area_exited", self);
	process_mode = Node.PROCESS_MODE_DISABLED;

func generate_text(item_name: String, num: int) -> Array:
	if(num == 1): return [[item_name + " Obtained!"]];
	return [[str(num) + " x " + item_name + " Obtained!"]]
