extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var anim_player = $Slots/First/AnimationPlayer;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const party_screen_node =  "CurrentScene/PartyScreen";

enum PartySlots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
enum PanelState { OFF, ACTIVE }

var selected_slot = 0;
var last_slot_before_moving_left = 1;

@onready var slots = {
	PartySlots.FIRST: $Slots/First,
	PartySlots.SECOND: $Slots/Second,
	PartySlots.THRID: $Slots/Third,
	PartySlots.FOURTH: $Slots/Fourth,
	PartySlots.FIFTH: $Slots/Fifth,
	PartySlots.SIXTH: $Slots/Sixth
}

var current_slots = {};
var current_slots_length;

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT;
	create_party_list();
	set_active_option(PanelState.ACTIVE);

func set_active_option(value: PanelState) -> void:
	current_slots[selected_slot].get_node("Panel").frame = value;
	if(value == PanelState.ACTIVE && selected_slot == 0):
		anim_player.play("selected");
	else: anim_player.play("Idle");

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
			audio.stream = GUI_SEL_CURSOR;
			audio.play();
			handle_DOWN();
	#UP
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): 
			audio.stream = GUI_SEL_CURSOR;
			audio.play();
			handle_UP();
	#RIGHT
	elif(
		(Input.is_action_pressed("moveRight") || 
		Input.is_action_pressed("ui_right")) && 
		selected_slot == PartySlots.FIRST): 
			audio.stream = GUI_SEL_CURSOR;
			audio.play();
			handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_pressed("moveLeft") || 
		Input.is_action_pressed("ui_left")) && 
		selected_slot != PartySlots.FIRST): 
			audio.stream = GUI_SEL_CURSOR;
			audio.play();
			handle_LEFT();
	#SELECT
	elif(event.is_action_pressed("space")): select_slot();
	set_active_option(PanelState.ACTIVE);

func select_slot() -> void:
	match(selected_slot):
		current_slots_length: close_party()
		

func close_party() -> void:
	audio.stream = GUI_MENU_CLOSE;
	audio.play();
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("party_opened", false);
	process_mode = Node.PROCESS_MODE_DISABLED;

func handle_DOWN():
	selected_slot += 1;
	if(selected_slot > current_slots_length): 
		selected_slot = int(PartySlots.FIRST);

func handle_UP():
	if(selected_slot == 0): selected_slot = current_slots_length;
	else: selected_slot -= 1;

func handle_RIGHT(): 
	selected_slot = int(last_slot_before_moving_left);
	current_slots[PartySlots.FIRST].get_node("Pokemon").position.y = 35;

func handle_LEFT():
	last_slot_before_moving_left = int(selected_slot);
	selected_slot = int(PartySlots.FIRST);

func create_party_list() -> void:
	var party = PARTY.get_party();
	for index in range(0, party.size()):
		slots[index].visible = true;
		current_slots[index] = slots[index];
		var pokemon_node = slots[index].get_node("Pokemon");
		var gender_node = slots[index].get_node("Gender");
		var name_node = slots[index].get_node("Name");
		var level_node = slots[index].get_node("Level");
		var total_hp_node = slots[index].get_node("TotalHP");
		var remain_hp_node = slots[index].get_node("RemainHP");
		#var health_node = slots[foo.slot].get_node("Health");
		
		var poke = party[index];
		pokemon_node.texture = poke.data.party_texture;
		gender_node.frame = poke.data.gender;
		name_node.text = poke.data.name;
		level_node.text = str(poke.data.level);
		total_hp_node.text = str(poke.data.total_hp);
		remain_hp_node.text = str(poke.data.current_hp);
	current_slots_length = current_slots.size();
	current_slots[current_slots_length] = $Background;

