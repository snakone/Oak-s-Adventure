extends Control

@onready var shop: CanvasLayer = $"..";
@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer";

const SHOP_ITEM_HEIGHT = 16;
const CURSOR_HEIGHT_BOTTOM = 62;
var camera: Camera2D;

var item_selected = 0;

func _ready() -> void:
	camera = get_tree().get_nodes_in_group("camera")[0];

func handle_DOWN() -> void:
	if(item_selected == shop.items_size - 1 || shop.items_size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	item_selected += 1;
	update_cursor();
	update_item();
	update_scroll();

func handle_UP() -> void:
	if(item_selected == 0 || shop.items_size == 0): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	item_selected -= 1;
	update_cursor();
	update_item();
	update_scroll();

#OPEN
func open() -> void:
	shop.current_state = shop.State.SHOPPING;
	item_selected = 0;
	update_cursor();
	update_item();
	shop.is_shopping = true;
	shop.money_amount.text = '$ ' + str(GLOBAL.current_money);
	shop.nine_rect.visible = false;
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.tween_property(camera, "offset:x", 74, 0.2);
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	visible = true;

func update_item() -> void:
	var item = shop.get_current_item();
	if(item != null):
		shop.sprite_2d.texture = item.image;
		shop.item_description.text = item.description;

#CLOSE
func close() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	shop.nine_rect.visible = true;
	visible = false;
	shop.is_shopping = false;
	var tween = get_tree().create_tween();
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.tween_property(camera, "offset", camera.current_offset, 0.2);
	shop.current_state = shop.State.SELECT;

#CURSOR
func update_cursor() -> void:
	var y_position = get_cursor_y(item_selected, shop.items_size);
	if(y_position != 0.0): shop.shopping_cursor.position = Vector2(91, y_position);

func get_cursor_y(option: int, arr_size: int) -> float:
	if(option == 0): return 14;
	elif(arr_size != 0):
		if(option < 4):
			return (option % arr_size) * SHOP_ITEM_HEIGHT + 14;
		elif(
			option + 2 < arr_size - 1 || 
			option + 2 == arr_size - 1 || 
			option + 1 == arr_size - 1
		): return CURSOR_HEIGHT_BOTTOM;
		elif option == arr_size - 1: 
			return CURSOR_HEIGHT_BOTTOM + SHOP_ITEM_HEIGHT;
	return 0.0;

#SCROLL
func get_scroll() -> int:
	if(item_selected < 4): return 0;
	return (item_selected - 3) * SHOP_ITEM_HEIGHT;

func update_scroll() -> void:
	var scroll = get_scroll();
	if(item_selected + 2 > shop.items_size): return;
	shop.scroll_container.scroll_vertical = scroll;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
