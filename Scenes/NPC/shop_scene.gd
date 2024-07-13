extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect;
@onready var cursor: TextureRect = $Select/NinePatchRect/Cursor;
@onready var control_shopping: Control = $Shopping;
@onready var container: VBoxContainer = $Shopping/ScrollContainer/VBoxContainer;
@onready var money_amount: RichTextLabel = $Shopping/Money/Amount;
@onready var scroll_container: ScrollContainer = $Shopping/ScrollContainer;
@onready var shopping_cursor: TextureRect = $Shopping/Cursor;
@onready var item_description: RichTextLabel = $Shopping/Description/Text;
@onready var sprite_2d: Sprite2D = $Shopping/Description/Sprite2D;
@onready var control_buying: Control = $Buying;
@onready var amount_in_bag: RichTextLabel = $Buying/Item_Bag/Title
@onready var purchase_price: RichTextLabel = $Buying/Select_Amount/Price;
@onready var purchase_node_amount: RichTextLabel = $Buying/Select_Amount/Amount;

const SHOP_ITEM = preload("res://Scripts/shop_item.tscn");
const SHOP_ITEM_HEIGHT = 16;
const CURSOR_HEIGHT_BOTTOM = 62;
const SHOPPING_DIALOG = 70;
const PURCHASE_DIALOG = 71;
var camera: Camera2D;
var writing = false;

@onready var CANCEL_ITEM = {
	"id": -1,
	"name": "CANCEL", 
	"description": "CLOSE THE SHOP",
	"image": preload("res://Assets/UI/Bag/back.png")
}

enum ShopOptions { BUY, SELL, CANCEL }

var can_use_menu = true;
var selected_option = 0;
var options_length = ShopOptions.keys().size();
var shop: ENUMS.Shops;
var items: Array;

var is_shopping = false;
var shop_purchase_open = false;
var item_selected = 0;
var items_size = 0;
var purchase_amount = 1;
var selection_open = false;

func _ready() -> void:
	GLOBAL.on_overlay = true;
	create_items();
	set_marker();
	create_list(items);
	camera = get_tree().get_nodes_in_group("camera")[0];
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func set_data(data: ENUMS.Shops) -> void: shop = data;

func _unhandled_input(event: InputEvent) -> void:
	var cant_echo = !event.is_pressed() || event.is_echo();
	if(shop_purchase_open): cant_echo = false;
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
	if(Input.is_action_just_pressed("backMenu")): close_menu();
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
	elif(Input.is_action_just_pressed("space")): select_option();

func handle_DOWN() -> void:
	if(shop_purchase_open):
		handle_purchase_DOWN();
		return;
	elif(is_shopping): 
		handle_list_DOWN();
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = ShopOptions.BUY;
	update_cursor();

func handle_UP() -> void:
	if(shop_purchase_open):
		handle_purchase_UP();
		return;
	elif(is_shopping):
		handle_list_UP();
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(selected_option == ShopOptions.BUY): 
		selected_option = ShopOptions.CANCEL;
	else: selected_option -= 1;
	update_cursor();

func handle_list_DOWN() -> void:
	if(item_selected == items_size - 1 || items_size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	item_selected += 1;
	update_shop_cursor();
	update_item();
	update_scroll();

func handle_list_UP() -> void:
	if(item_selected == 0 || items_size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	item_selected -= 1;
	update_shop_cursor();
	update_item();
	update_scroll();

func handle_purchase_DOWN() -> void:
	if(purchase_amount == 1): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount -= 1;
	update_purchase_amount(purchase_amount);

func handle_purchase_UP() -> void:
	if(purchase_amount == 999): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount += 1;
	update_purchase_amount(purchase_amount);

func handle_RIGHT() -> void:
	if(!shop_purchase_open): return;
	if(purchase_amount >= 990):
		purchase_amount = 999;
		update_purchase_amount(purchase_amount);
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount += 10;
	update_purchase_amount(purchase_amount);

func handle_LEFT() -> void:
	if(!shop_purchase_open): return;
	if(purchase_amount <= 10):
		purchase_amount = 1;
		update_purchase_amount(purchase_amount);
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount -= 10;
	update_purchase_amount(purchase_amount);

func update_purchase_amount(value: int) -> void:
	purchase_node_amount.text = format_number(value);
	update_purchase_price(get_current_item().shop.price, value);

#SELECT LIST
func select_option() -> void:
	if(shop_purchase_open):
		purchase_item();
		return;
	elif(is_shopping): 
		open_purchase_panel();
		return;
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	match(selected_option):
		ShopOptions.BUY: open_shop_list()
		ShopOptions.SELL: sell()
		ShopOptions.CANCEL: close_menu();

#PURCHASE
func purchase_item() -> void:
	control_buying.visible = false;
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var item = get_current_item();
	GLOBAL.emit_signal(
		"create_dialog", 
		PURCHASE_DIALOG, 
		generate_purchase_text(item.name, purchase_amount, item.shop.price * purchase_amount)
	);
	selection_open = true;

func handle_purchase() -> void:
	audio.volume_db = 0;
	play_audio(LIBRARIES.SOUNDS.MART_BUY_ITEM);
	var item = get_current_item();
	GLOBAL.current_money -= (item.shop.price * purchase_amount);
	money_amount.text = '$ ' + str(GLOBAL.current_money);
	BAG.add_item(item.id, purchase_amount);
	GLOBAL.start_dialog.emit(72);
	await GLOBAL.close_dialog;
	audio.volume_db = -10;
	close_purchase_panel(false);

#SELECT SHOP ITEM
func open_purchase_panel() -> void:
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var item = get_current_item();
	if(item.id == -1): 
		close_shop_list();
		return;
	var item_amount = BAG.get_item_amount(item.id);
	amount_in_bag.text = "IN BAG:  " + str(item_amount);
	update_purchase_price(item.shop.price, 1);
	
	GLOBAL.emit_signal(
		"create_dialog", 
		SHOPPING_DIALOG, 
		generate_text(item.name)
	);
	
	writing = true;
	await GLOBAL.timeout(2.6);
	writing = false;
	control_buying.visible = true;
	shop_purchase_open = true;
	GLOBAL.shopping = true;

func open_shop_list() -> void:
	item_selected = 0;
	update_shop_cursor();
	update_item();
	is_shopping = true;
	money_amount.text = '$ ' + str(GLOBAL.current_money);
	nine_rect.visible = false;
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.tween_property(camera, "offset:x", 74, 0.2);
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	control_shopping.visible = true;

func sell() -> void:
	print("Sell");

#CREATE
func create_items() -> void:
	var list = LIBRARIES.SHOPS.get_shop(shop);
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

func update_item() -> void:
	var item = get_current_item();
	if(item != null):
		sprite_2d.texture = item.image;
		item_description.text = item.description;

#CLOSING
func close_menu() -> void:
	if(shop_purchase_open):
		GLOBAL.close_dialog.emit();
		close_purchase_panel();
		return;
	elif(is_shopping):
		close_shop_list();
		return;
	can_use_menu = false;
	nine_rect.visible = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await audio.finished;
	GLOBAL.shopping = false;
	GLOBAL.start_dialog.emit(69);
	await GLOBAL.close_dialog;
	GLOBAL.close_shop.emit();
	GLOBAL.on_overlay = false;

func close_purchase_panel(sound = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	control_buying.visible = false;
	shop_purchase_open = false;
	purchase_amount = 1;
	update_purchase_amount(purchase_amount);
	await GLOBAL.timeout(0.2);
	selection_open = false;

func close_shop_list() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	nine_rect.visible = true;
	control_shopping.visible = false;
	is_shopping = false;
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.tween_property(camera, "offset", camera.current_offset, 0.2);

func _on_selection_value_select(value: int, category) -> void:
	if(category != ENUMS.SelectionCategory.PURCHASE): return;
	match value:
		int(ENUMS.BinaryOptions.YES): handle_purchase();
		int(ENUMS.BinaryOptions.NO): close_purchase_panel(false);

#CURSOR
func update_cursor() -> void:
	var perct = (selected_option % options_length) * 16;
	cursor.position.y = 12 + perct;

func update_shop_cursor() -> void:
	var y_position = get_cursor_y(item_selected, items_size);
	if(y_position != 0.0): shopping_cursor.position = Vector2(91, y_position);

func get_cursor_y(option: int, size: int) -> float:
	if(option == 0): return 14;
	elif(size != 0):
		if(option < 4):
			return (option % size) * SHOP_ITEM_HEIGHT + 14;
		elif(
			option + 2 < size - 1 || 
			option + 2 == size - 1 || 
			option + 1 == size - 1
		): return CURSOR_HEIGHT_BOTTOM;
		elif option == size - 1: 
			return CURSOR_HEIGHT_BOTTOM + SHOP_ITEM_HEIGHT;
	return 0.0;

#SCROLL
func get_scroll() -> int:
	if(item_selected < 4): return 0;
	return (item_selected - 3) * SHOP_ITEM_HEIGHT;

func update_scroll() -> void:
	var scroll = get_scroll();
	if(item_selected + 2 > items_size): return;
	scroll_container.scroll_vertical = scroll;

#MARKERS
func set_marker() -> void:
	if(SETTINGS.selected_marker):
		nine_rect.texture = SETTINGS.selected_marker;

func format_number(num: int) -> String:
	if(num < 10): return 'x0' + str(num);
	return "x" + str(num);

func generate_text(item_name: String) -> Array:
	return [[item_name + "? Certainly.\nHow many would you like?"]];

func generate_purchase_text(
	item_name: String, 
	amount: int,
	price: int) -> Array:
	return [[item_name + ", and you want " + str(amount) + ".\nThat will be $" + str(price) + ". Okay?"]];

func get_current_item() -> Dictionary: return items[item_selected];

func update_purchase_price(price: int, amount: int) -> void:
	purchase_price.text = "$ " + str(price * amount);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
