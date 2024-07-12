extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Control/NinePatchRect;
@onready var cursor: TextureRect = $Control/NinePatchRect/Cursor;

enum ShopOptions { BUY, SELL, CANCEL }

var can_use_menu = true;
var selected_option = 0;
var options_length = ShopOptions.keys().size();
var shop: ENUMS.Shops;

func _ready() -> void: set_marker();
func set_data(data: ENUMS.Shops) -> void: shop = data;

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		!can_use_menu
	): return;
	
	if(Input.is_action_just_pressed("backMenu")): close_menu();
	elif(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	elif(Input.is_action_just_pressed("space")): select_option();

func handle_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_option += 1;
	if(selected_option > options_length - 1): 
		selected_option = ShopOptions.BUY;
	update_cursor();

func handle_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(selected_option == ShopOptions.BUY): 
		selected_option = ShopOptions.CANCEL;
	else: selected_option -= 1;
	update_cursor();

func select_option() -> void:
	play_audio(LIBRARIES.SOUNDS.CONFIRM);
	match(selected_option):
		ShopOptions.BUY: buy()
		ShopOptions.SELL: sell()
		ShopOptions.CANCEL: close_menu();

func buy() -> void:
	can_use_menu = false;
	nine_rect.visible = false;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	await audio.finished;
	print("open shop overlay");
	print(shop)
	close_menu();

func sell() -> void:
	print("Sell");

func close_menu() -> void:
	can_use_menu = false;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	nine_rect.visible = false;
	await audio.finished;
	GLOBAL.close_shop.emit();

func update_cursor() -> void:
	var perct = (selected_option % options_length) * 16;
	cursor.position.y = 12 + perct;

#MARKERS
func set_marker() -> void:
	if(SETTINGS.selected_marker):
		nine_rect.texture = SETTINGS.selected_marker;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
