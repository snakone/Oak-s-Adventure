extends Control

@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var shop: CanvasLayer = $"..";
@onready var shopping: Control = $"../Shopping";
@onready var purchase_price: RichTextLabel = $Select_Amount/Price;
@onready var purchase_node_amount: RichTextLabel = $Select_Amount/Amount;

const SHOPPING_DIALOG = 70;
const PURCHASE_DIALOG = 71;
const NO_MONEY_DIALOG = 73;
const MAX_PURCHASE_AMOUNT = 999;

var purchase_amount = 1;

var dialog_time_map = {
	SETTINGS.TextSpeed.NORMAL: 2.6,
	SETTINGS.TextSpeed.SLOW: 5.2,
	SETTINGS.TextSpeed.FAST: 1.9
}

func _ready() -> void:
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func handle_DOWN() -> void:
	if(purchase_amount == 1): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount -= 1;
	update_purchase_amount(purchase_amount);

func handle_UP() -> void:
	if(purchase_amount == MAX_PURCHASE_AMOUNT): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(check_if_enough_money()): purchase_amount += 1;
	else: purchase_amount = 1;
	update_purchase_amount(purchase_amount);

func handle_RIGHT() -> void:
	if(purchase_amount == MAX_PURCHASE_AMOUNT): return;
	if(purchase_amount >= 990):
		purchase_amount = MAX_PURCHASE_AMOUNT;
		update_purchase_amount(purchase_amount);
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(check_if_enough_money(10)): purchase_amount += 10;
	else: purchase_amount = 1;
	update_purchase_amount(purchase_amount);

func handle_LEFT() -> void:
	if(purchase_amount <= 10):
		purchase_amount = 1;
		update_purchase_amount(purchase_amount);
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	purchase_amount -= 10;
	update_purchase_amount(purchase_amount);

#SELECT SHOP ITEM
func open() -> void:
	var item = shop.get_current_item();
	#CANCEL BUTTON
	if(item.id == -1): 
		shopping.close();
		return;
		
	GLOBAL.shopping = true;
		
	if(!check_if_enough_money(0)):
		await handle_no_money();
		return;
		
	shop.current_state = shop.State.PURCHASING;
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var item_amount = BAG.get_item_amount(item.id);
	shop.amount_in_bag.text = "IN BAG:  " + str(item_amount);
	update_purchase_price(item.shop.price, 1);
	
	GLOBAL.emit_signal(
		"create_dialog", 
		SHOPPING_DIALOG, 
		generate_text(item.name)
	);
	
	shop.writing = true;
	var dialog_wait_time = dialog_time_map[int(SETTINGS.player_settings.text_speed)];
	await GLOBAL.timeout(dialog_wait_time);
	shop.writing = false;
	visible = true;

#PURCHASE
func purchase_item() -> void:
	visible = false;
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var item = shop.get_current_item();
	GLOBAL.emit_signal(
		"create_dialog", 
		PURCHASE_DIALOG, 
		generate_purchase_text(
			item.name, 
			purchase_amount, 
			item.shop.price * purchase_amount)
	);
	shop.selection_open = true;

#CLOSE
func close(sound = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	visible = false;
	purchase_amount = 1;
	update_purchase_amount(purchase_amount);
	await GLOBAL.timeout(0.2);
	shop.selection_open = false;
	shop.current_state = shop.State.SHOPPING;

func _on_selection_value_select(value: int, category) -> void:
	if(category != ENUMS.SelectionCategory.PURCHASE): return;
	match value:
		int(ENUMS.BinaryOptions.YES): handle_purchase();
		int(ENUMS.BinaryOptions.NO): close(false);

func handle_purchase() -> void:
	audio.volume_db = 0;
	play_audio(LIBRARIES.SOUNDS.MART_BUY_ITEM);
	var item = shop.get_current_item();
	GLOBAL.current_money -= (item.shop.price * purchase_amount);
	shop.money_amount.text = '$ ' + str(GLOBAL.current_money);
	BAG.add_item(item.id, purchase_amount);
	GLOBAL.start_dialog.emit(72);
	await GLOBAL.close_dialog;
	audio.volume_db = -10;
	close(false);

func check_if_enough_money(step = 1) -> bool:
	var item = shop.get_current_item();
	var next_amount = purchase_amount + step;
	if((item.shop.price * next_amount) > GLOBAL.current_money):
		return false;
	return true;

func handle_no_money() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_BUZZER);
	shop.writing = true;
	GLOBAL.start_dialog.emit(NO_MONEY_DIALOG);
	await GLOBAL.close_dialog;
	await GLOBAL.timeout(0.2);
	shop.writing = false;

func update_purchase_amount(value: int) -> void:
	purchase_node_amount.text = format_number(value);
	update_purchase_price(shop.get_current_item().shop.price, value);

func update_purchase_price(price: int, amount: int) -> void:
	purchase_price.text = "$ " + str(price * amount);

func generate_text(item_name: String) -> Array:
	return [[item_name + "? Certainly.\nHow many would you like?"]];

func format_number(num: int) -> String:
	if(num < 10): return 'x0' + str(num);
	return "x" + str(num);

func generate_purchase_text(
	item_name: String, 
	amount: int,
	price: int) -> Array:
	return [[item_name + ", and you want " + str(amount) + ".\nThat will be $" + str(price) + ". Okay?"]];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
