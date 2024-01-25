extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var anim_player = $Slots/First/AnimationPlayer;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const party_screen_node =  "CurrentScene/PartyScreen";

enum Slots { FIRST, SECOND, THRID, FOURTH, FIFTH, SIXTH }
enum State { OFF, ACTIVE }

@onready var slots = {
	Slots.FIRST: $Slots/First,
	Slots.SECOND: $Slots/Second,
	Slots.THRID: $Slots/Third,
	Slots.FOURTH: $Slots/Fourth,
	Slots.FIFTH: $Slots/Fifth,
	Slots.SIXTH: $Slots/Sixth
}

var selected_slot = 0;
var last_slot_before_moving_left = 1;
var current_slots = {};
var current_slots_length;

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT;
	create_party_list();
	set_active_option(State.ACTIVE);

func set_active_option(value: State) -> void:
	current_slots[selected_slot].get_node("Panel").frame = value;
	if(value == State.ACTIVE && selected_slot == 0): anim_player.play("selected");
	else: anim_player.play("Idle");

func _unhandled_input(event) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open
	): return;
	
	set_active_option(State.OFF);
	#CLOSE
	if(
		Input.is_action_pressed("menu") || 
		Input.is_action_pressed("backMenu") ||
		Input.is_action_pressed("escape")): close_party();
	#DOWN
	if(
		Input.is_action_pressed("moveDown") || 
		Input.is_action_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_pressed("moveUp") || 
		Input.is_action_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		(Input.is_action_pressed("moveRight") || 
		Input.is_action_pressed("ui_right")) && 
		selected_slot == Slots.FIRST): handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_pressed("moveLeft") || 
		Input.is_action_pressed("ui_left")) && 
		selected_slot != Slots.FIRST): handle_LEFT();
	#SELECT
	elif(event.is_action_pressed("space")): select_slot();
	set_active_option(State.ACTIVE);

func select_slot() -> void:
	match(selected_slot):
		current_slots_length: close_party();
		

func close_party() -> void:
	play_audio(GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("party_opened", false);
	process_mode = Node.PROCESS_MODE_DISABLED;

func handle_DOWN():
	play_audio(GUI_SEL_CURSOR);
	selected_slot += 1;
	if(selected_slot > current_slots_length): selected_slot = int(Slots.FIRST);

func handle_UP():
	play_audio(GUI_SEL_CURSOR);
	if(selected_slot == 0): selected_slot = current_slots_length;
	else: selected_slot -= 1;

func handle_RIGHT():
	play_audio(GUI_SEL_CURSOR);
	selected_slot = int(last_slot_before_moving_left);
	current_slots[Slots.FIRST].get_node("Pokemon").position.y = 35;

func handle_LEFT():
	play_audio(GUI_SEL_CURSOR);
	last_slot_before_moving_left = int(selected_slot);
	selected_slot = int(Slots.FIRST);

func create_party_list() -> void:
	var party = PARTY.get_party();
	for index in range(0, party.size()):
		slots[index].visible = true;
		current_slots[index] = slots[index];
		#NODES
		var pokemon_node = slots[index].get_node("Pokemon");
		var gender_node = slots[index].get_node("Gender");
		var name_node = slots[index].get_node("Name");
		var level_node = slots[index].get_node("Level");
		var total_hp_node = slots[index].get_node("TotalHP");
		var remain_hp_node = slots[index].get_node("RemainHP");
		#var health_node = slots[foo.slot].get_node("Health");
		
		#STATS
		var poke = party[index];
		pokemon_node.texture = poke.data.party_texture;
		gender_node.frame = poke.data.gender;
		name_node.text = poke.data.name;
		level_node.text = str(poke.data.level);
		total_hp_node.text = str(poke.data.total_hp);
		remain_hp_node.text = str(poke.data.current_hp);
		
	current_slots_length = current_slots.size();
	current_slots[current_slots_length] = $Background;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

