extends StaticBody2D

@export var pickable: ENUMS.Item;
@export var amount = 1;
@export var direction = ENUMS.Directions.ALL;

const PICKABLE_DIALOG = 59;

var uuid = preload("res://uuid.gd").new();
var id;

func _ready() -> void:
	GLOBAL.connect("pick_item", _on_pick_item);
	id = uuid.v4();

func _on_pick_item(data: Dictionary) -> void:
	if(data.id != id): return;
	var item = BAG.get_item_by_id(data.pickable);
	get_node("PickableArea").emit_signal("area_exited", self);
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.emit_signal("create_dialog", PICKABLE_DIALOG, generate_text(item.name, amount));
	BAG.add_item(data.pickable, amount);
	await GLOBAL.timeout(0.2);
	call_deferred("queue_free");

func generate_text(item_name: String, num: int) -> Array:
	if(num == 1): return [[item_name + " Obtained!"]];
	return [[str(num) + " x " + item_name + " Obtained!"]]
