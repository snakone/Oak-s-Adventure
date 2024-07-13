extends Control

@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var shop: CanvasLayer = $"..";
@onready var shopping: Control = $"../Shopping";

const SHOPPING_DIALOG = 70;
const PURCHASE_DIALOG = 71;

func _ready() -> void:
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func handle_DOWN() -> void:
	if(shop.purchase_amount == 1): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	shop.purchase_amount -= 1;
	shop.update_purchase_amount(shop.purchase_amount);

func handle_UP() -> void:
	if(shop.purchase_amount == 999): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	shop.purchase_amount += 1;
	shop.update_purchase_amount(shop.purchase_amount);

#SELECT SHOP ITEM
func open() -> void:
	shop.current_state = shop.State.PURCHASING;
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	var item = shop.get_current_item();
	if(item.id == -1): 
		shopping.close();
		return;
	var item_amount = BAG.get_item_amount(item.id);
	shop.amount_in_bag.text = "IN BAG:  " + str(item_amount);
	shop.update_purchase_price(item.shop.price, 1);
	
	GLOBAL.emit_signal(
		"create_dialog", 
		SHOPPING_DIALOG, 
		generate_text(item.name)
	);
	
	shop.writing = true;
	await GLOBAL.timeout(2.6);
	shop.writing = false;
	visible = true;
	GLOBAL.shopping = true;

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
			shop.purchase_amount, 
			item.shop.price * shop.purchase_amount)
	);
	shop.selection_open = true;

#CLOSE
func close(sound = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	visible = false;
	shop.purchase_amount = 1;
	shop.update_purchase_amount(shop.purchase_amount);
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
	GLOBAL.current_money -= (item.shop.price * shop.purchase_amount);
	shop.money_amount.text = '$ ' + str(GLOBAL.current_money);
	BAG.add_item(item.id, shop.purchase_amount);
	GLOBAL.start_dialog.emit(72);
	await GLOBAL.close_dialog;
	audio.volume_db = -10;
	close(false);

func generate_text(item_name: String) -> Array:
	return [[item_name + "? Certainly.\nHow many would you like?"]];

func generate_purchase_text(
	item_name: String, 
	amount: int,
	price: int) -> Array:
	return [[item_name + ", and you want " + str(amount) + ".\nThat will be $" + str(price) + ". Okay?"]];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
