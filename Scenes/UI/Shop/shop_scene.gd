extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect;
@onready var cursor: TextureRect = $Select/NinePatchRect/Cursor;
@onready var container: VBoxContainer = $Shopping/ScrollContainer/VBoxContainer;
@onready var money_amount: RichTextLabel = $Shopping/Money/Amount;
@onready var scroll_container: ScrollContainer = $Shopping/ScrollContainer;
@onready var shopping_cursor: TextureRect = $Shopping/Cursor;
@onready var item_description: RichTextLabel = $Shopping/Description/Text;
@onready var sprite_2d: Sprite2D = $Shopping/Description/Sprite2D;
@onready var amount_in_bag: RichTextLabel = $Purchasing/Item_Bag/Title;
@onready var item_bag: NinePatchRect = $Purchasing/Item_Bag;
@onready var select_amount: NinePatchRect = $Purchasing/Select_Amount;

@onready var control_shopping: Control = $Shopping;
@onready var control_purchasing: Control = $Purchasing;

enum State { SELECT, SHOPPING, PURCHASING }
enum ShopOptions { BUY, SELL, CANCEL }

const SHOP_ITEM = preload("res://Scenes/UI/Shop/shop_item.tscn");
const SHOP_ITEM_HEIGHT = 16;
const CURSOR_HEIGHT_BOTTOM = 62;
const SHOPPING_DIALOG = 70;
const PURCHASE_DIALOG = 71;
var writing = false;

@onready var CANCEL_ITEM = {
	"id": -1,
	"name": "CANCEL", 
	"description": "CLOSE THE SHOP",
	"image": preload("res://Assets/UI/Bag/back.png")
}

var current_state = State.SELECT;
var can_use_menu = true;
var selected_option = 0;
var options_length = ShopOptions.keys().size();
var shop_number: ENUMS.Shops;
var items: Array;

var is_shopping = false;
var items_size = 0;
var selection_open = false;

func _ready() -> void:
	GLOBAL.on_overlay = true;
	create_items();
	set_marker();
	create_list(items);

func set_data(data: ENUMS.Shops) -> void: shop_number = data;

func _unhandled_input(event: InputEvent) -> void:
	var cant_echo = !event.is_pressed() || event.is_echo();
	if(current_state == State.PURCHASING): cant_echo = false;
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition || 
		cant_echo ||
		GLOBAL.on_battle ||
		!can_use_menu ||
		writing ||
		selection_open
	): return;
	#CLOSE
	if(Input.is_action_just_pressed("backMenu")): handle_close();
	#DOWN
	elif(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		Input.is_action_pressed("moveRight") || 
		Input.is_action_pressed("ui_right")): handle_RIGHT();
	#LEFT
	elif(
		Input.is_action_pressed("moveLeft") || 
		Input.is_action_pressed("ui_left")): handle_LEFT();
	elif(Input.is_action_just_pressed("space")): handle_select();

func handle_DOWN() -> void:
	match current_state:
		State.SELECT: select_DOWN();
		State.SHOPPING: control_shopping.handle_DOWN();
		State.PURCHASING: control_purchasing.handle_DOWN();

func select_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = ShopOptions.BUY;
	update_cursor();

func handle_UP() -> void:
	match current_state:
		State.SELECT: select_UP();
		State.SHOPPING: control_shopping.handle_UP();
		State.PURCHASING: control_purchasing.handle_UP();

func select_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(selected_option == ShopOptions.BUY): 
		selected_option = ShopOptions.CANCEL;
	else: selected_option -= 1;
	update_cursor();

func handle_RIGHT() -> void:
	if(current_state != State.PURCHASING): return;
	control_purchasing.handle_RIGHT();

func handle_LEFT() -> void:
	if(current_state != State.PURCHASING): return;
	control_purchasing.handle_LEFT();

func handle_select() -> void:
	match current_state:
		State.SELECT: select_option();
		State.SHOPPING: control_purchasing.open();
		State.PURCHASING: control_purchasing.purchase_item();

#SELECT LIST
func select_option() -> void:
	match(selected_option):
		ShopOptions.BUY: control_shopping.open();
		ShopOptions.SELL: sell()
		ShopOptions.CANCEL: handle_close();

func sell() -> void:
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	print("Sell");

#CREATE
func create_items() -> void:
	var list = LIBRARIES.SHOPS.get_shop(shop_number);
	var array = [];
	for id in list:
		array.push_back(BAG.get_item_by_id(id));
	items = array;

func create_list(arr: Array) -> void:
	arr.push_back(CANCEL_ITEM);
	for item in arr:
		var node = SHOP_ITEM.instantiate();
		node.set_data(item);
		container.add_child(node);
	items_size = arr.size();

#CLOSING
func handle_close() -> void:
	match current_state:
		State.SELECT: close_menu();
		State.SHOPPING: control_shopping.close();
		State.PURCHASING:
			GLOBAL.close_dialog.emit();
			control_purchasing.close();

func close_menu() -> void:
	can_use_menu = false;
	nine_rect.visible = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await audio.finished;
	GLOBAL.shopping = false;
	GLOBAL.start_dialog.emit(69);
	await GLOBAL.close_dialog;
	GLOBAL.close_shop.emit();
	GLOBAL.on_overlay = false;
	current_state = State.SELECT;

#CURSOR
func update_cursor() -> void:
	var perct = (selected_option % options_length) * 16;
	cursor.position.y = 12 + perct;

#MARKERS
func set_marker() -> void:
	nine_rect.texture = SETTINGS.player_settings.marker;
	item_bag.texture = SETTINGS.player_settings.marker;
	select_amount.texture = SETTINGS.player_settings.marker;

func get_current_item() -> Dictionary: return items[control_shopping.item_selected];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
