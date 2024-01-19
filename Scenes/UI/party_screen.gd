extends CanvasLayer

@onready var audio_player = $AudioStreamPlayer;
const GUI_SEL_CURSOR = preload("res://Assets/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/GUI menu close.ogg");

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH, CANCEL }
enum PanelState { OFF, ACTIVE }
var selected_slot = 0;
var slots_length;
var last_slot_before_moving_left = 1;
var party_screen_node =  "CurrentScene/PartyScreen";
@onready var animation_player = $Slots/First/AnimationPlayer

@onready var slot_switch = {
	Slots.FIRST: $Slots/First,
	Slots.SECOND: $Slots/Second,
	Slots.THRID: $Slots/Third,
	Slots.FOURTH: $Slots/Fourth,
	Slots.FIFTH: $Slots/Fifth,
	Slots.SIXTH: $Slots/Sixth,
	Slots.CANCEL: $Cancel
}

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT;
	set_active_option(PanelState.ACTIVE);
	slots_length = slot_switch.size();
	create_party_list();

func set_active_option(value: PanelState) -> void:
	slot_switch[selected_slot].get_node("Panel").frame = value;
	if(value == PanelState.ACTIVE && selected_slot == 0):
		animation_player.play("selected");
	else: animation_player.play("Idle");

func _unhandled_input(event) -> void:
	if(
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open
	): return;
	
	set_active_option(PanelState.OFF);
	#CLOSE
	if(
		Input.is_action_pressed("menu") || 
		Input.is_action_pressed("backMenu") ||
		Input.is_action_pressed("escape")): close_party();
	#DOWN
	if(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")):
			audio_player.stream = GUI_SEL_CURSOR;
			audio_player.play();
			handle_DOWN();
	#UP
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): 
			audio_player.stream = GUI_SEL_CURSOR;
			audio_player.play();
			handle_UP();
	#RIGHT
	elif(
		(Input.is_action_pressed("moveRight") || 
		Input.is_action_pressed("ui_right")) && 
		selected_slot == Slots.FIRST): 
			audio_player.stream = GUI_SEL_CURSOR;
			audio_player.play();
			handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_pressed("moveLeft") || 
		Input.is_action_pressed("ui_left")) && 
		selected_slot != Slots.FIRST): 
			audio_player.stream = GUI_SEL_CURSOR;
			audio_player.play();
			handle_LEFT();
	#SELECT
	elif(event.is_action_pressed("space")): select_slot();
	
	set_active_option(PanelState.ACTIVE);

func select_slot() -> void:
	match(selected_slot):
		Slots.CANCEL: close_party()
		

func close_party() -> void:
	audio_player.stream = GUI_MENU_CLOSE;
	audio_player.play();
	await get_tree().create_timer(.2).timeout;
	GLOBAL.emit_signal("party_opened", false);
	process_mode = Node.PROCESS_MODE_DISABLED;

func handle_DOWN():
	selected_slot = selected_slot + 1;
	if(selected_slot > slots_length - 1): selected_slot = int(Slots.FIRST);

func handle_UP():
	if(selected_slot == 0): selected_slot = int(Slots.CANCEL);
	else: selected_slot = selected_slot - 1;

func handle_RIGHT(): selected_slot = int(last_slot_before_moving_left);

func handle_LEFT():
	last_slot_before_moving_left = int(selected_slot);
	selected_slot = int(Slots.FIRST);

func create_party_list() -> void:
	for poke in PARTY.get_party():
		var pokemon_node = slot_switch[poke.slot].get_node("Pokemon");
		var gender_node = slot_switch[poke.slot].get_node("Gender");
		var name_node = slot_switch[poke.slot].get_node("Name");
		var level_node = slot_switch[poke.slot].get_node("Level");
		var total_hp_node = slot_switch[poke.slot].get_node("TotalHP");
		var remain_hp_node = slot_switch[poke.slot].get_node("RemainHP");
		#var health_node = slot_switch[foo.slot].get_node("Health");
		
		pokemon_node.texture = poke.party_texture;
		gender_node.frame = int(poke.gender);
		name_node.text = poke.name;
		level_node.text = str(poke.level);
		total_hp_node.text = str(poke.total_hp);
		remain_hp_node.text = str(poke.current_hp);

