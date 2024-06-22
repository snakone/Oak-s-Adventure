extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var title: TextureRect = $Title;
@onready var bag_sprite: Sprite2D = $BagSprite;
@onready var arrow_left: Sprite2D = $Arrows/ArrowLeft;
@onready var arrow_right: Sprite2D = $Arrows/ArrowRight;

const ITEM_scene = preload("res://Scenes/UI/bag_item.tscn");

@onready var view_list = {
	ENUMS.BagScreen.ITEMS: {
		"node": $Items,
		"title": LIBRARIES.IMAGES.TITLE_ITEMS
	},
	ENUMS.BagScreen.POKEBALL: {
		"node": $Pokeball,
		"title": LIBRARIES.IMAGES.TITLE_POKEBALL
	},
	ENUMS.BagScreen.KEY: {
		"node": $Key,
		"title": LIBRARIES.IMAGES.TITLE_KEY
	}
}

var selected_view = int(ENUMS.BagScreen.ITEMS);
var pokeball_list = [];
var items_list = [];
var key_list = [];
var views_size: int;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;
	view_list[selected_view].node.visible = true;
	selected_view = BAG.last_bag_screen;
	views_size = view_list.keys().size();
	set_textures();
	create_bag();

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		Input.is_action_just_pressed("menu")
	): return;
	#CLOSE
	if(Input.is_action_just_pressed("backMenu")): 
		close_bag();
		return;
	#RIGHT
	elif(
		(Input.is_action_just_pressed("moveRight") || 
		Input.is_action_just_pressed("ui_right")) && 
		selected_view + 1 < views_size): handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_just_pressed("moveLeft") || 
		Input.is_action_just_pressed("ui_left")) && 
		selected_view - 1 >= 0): handle_LEFT();

#VIEW
func change_view(view: ENUMS.BagScreen) -> void:
	var current_node = view_list[int(selected_view)].node;
	var next_node = view_list[int(view)].node;
	if(current_node): current_node.visible = false;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	selected_view = int(view);
	if(next_node): next_node.visible = true;

func handle_RIGHT() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_view += 1;
	set_textures();

func handle_LEFT() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_view -= 1;
	set_textures();

#CREATE
func create_bag() -> void:
	for item in BAG.items:
		var item_info = BAG.get_item_by_id(item.id);
		item_info["amount"] = item.amount;
		match item_info.type:
			ENUMS.BagScreen.POKEBALL:
				pokeball_list.push_back(item_info);
			ENUMS.BagScreen.ITEMS:
				items_list.push_back(item_info);
			ENUMS.BagScreen.KEY:
				key_list.push_back(item_info);
	print(pokeball_list);

func close_bag() -> void:
	GLOBAL.on_overlay = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	BAG.last_bag_screen = selected_view;
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/BagScreen");
	if(GLOBAL.on_battle): BATTLE.state = ENUMS.BattleStates.MENU;
	process_mode = Node.PROCESS_MODE_DISABLED;

func set_textures() -> void:
	title.texture = view_list[int(selected_view)].title;
	bag_sprite.frame = selected_view;
	set_arrows_visibility(selected_view > 0, selected_view < views_size - 1)

func set_arrows_visibility(left: bool, right: bool) -> void:
	arrow_left.visible = left;
	arrow_right.visible = right;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
