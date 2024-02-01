extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var anim_player = $Slots/First/AnimationPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect
@onready var select: Control = $Select
@onready var cursor: TextureRect = $Select/Cursor;
@onready var label: RichTextLabel = $Background/RichTextLabel

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const party_screen_node =  "CurrentScene/PartyScreen";
const default_sentence = "Choose a POKéMON.";
const selected_sentence = "Do what with this POKéMON?";

enum Slots { FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH }
enum State { OFF, ACTIVE }
enum SelectSlot { FIRST, SECOND, THIRD }

@onready var slots = {
	Slots.FIRST: $Slots/First,
	Slots.SECOND: $Slots/Second,
	Slots.THIRD: $Slots/Third,
	Slots.FOURTH: $Slots/Fourth,
	Slots.FIFTH: $Slots/Fifth,
	Slots.SIXTH: $Slots/Sixth
}

var selected_slot = int(Slots.FIRST);
var last_slot_before_moving_left = int(Slots.SECOND);
var current_slots = {};
var current_slots_length;
var select_open = false;
var select_index = int(SelectSlot.FIRST);

var select_cursor_default_position = [
	Vector2(8, 9), Vector2(8, 25), Vector2(8, 41)
];

func _ready():
	label.text = default_sentence;
	select.visible = false;
	process_mode = Node.PROCESS_MODE_INHERIT;
	create_party_list();
	set_active_option(State.ACTIVE);
	if(SETTINGS.selected_marker):
		nine_rect.texture = SETTINGS.selected_marker;

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
	
	if(!select_open && !event.is_action_pressed("space")): set_active_option(State.OFF);
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
	if(!select_open): set_active_option(State.ACTIVE);

func select_slot() -> void:
	if(!select_open):
		match selected_slot:
			Slots.FIRST, Slots.SECOND, Slots.THIRD, Slots.FOURTH, Slots.FIFTH, Slots.SIXTH:
				select_input();
			current_slots_length: close_party();
	elif(select_open):
		match select_index:
			SelectSlot.FIRST: select_pokemon();
			SelectSlot.THIRD: close_party();

func select_input() -> void:
	play_audio(GUI_SEL_DECISION);
	select_open = true;
	select.visible = true;
	label.text = selected_sentence;

func select_pokemon() -> void:
	var poke_name = slots[selected_slot].get_node("Name").text;
	if(GLOBAL.on_battle):
		PARTY.set_active_pokemon(poke_name);
		close_select(false);
		close_party();
	else:
		close_select();
	await GLOBAL.timeout(0.2);
	GLOBAL.emit_signal("selected_pokemon_party", poke_name);

func close_party() -> void:
	if(select_open): 
		close_select();
		return;
	play_audio(GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("party_opened", false);
	if(GLOBAL.on_battle): BATTLE.state = BATTLE.States.MENU;
	process_mode = Node.PROCESS_MODE_DISABLED;

func handle_DOWN() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(select_open):
		select_DOWN();
		return;
	selected_slot += 1;
	if(selected_slot > current_slots_length): 
		selected_slot = int(Slots.FIRST);

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(select_open): 
		select_UP();
		return;
	if(selected_slot == 0): selected_slot = current_slots_length;
	else: selected_slot -= 1;

func handle_RIGHT() -> void:
	if(select_open): return;
	play_audio(GUI_SEL_CURSOR);
	selected_slot = int(last_slot_before_moving_left);
	current_slots[Slots.FIRST].get_node("Pokemon").position.y = 35;

func handle_LEFT() -> void:
	if(select_open): return;
	play_audio(GUI_SEL_CURSOR);
	last_slot_before_moving_left = int(selected_slot);
	selected_slot = int(Slots.FIRST);

#SELECT
func select_DOWN() -> void:
	select_index += 1;
	if(select_index > SelectSlot.THIRD): 
		select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func select_UP() -> void:
	if(select_index == SelectSlot.FIRST): 
		select_index = int(SelectSlot.THIRD);
	else: select_index -= 1;
	move_select_arrow();

func close_select(sound = true) -> void:
	if(sound): play_audio(GUI_SEL_CURSOR);
	select_open = false;
	select.visible = false;
	label.text = default_sentence;
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func move_select_arrow() -> void:
	cursor.position = select_cursor_default_position[select_index];

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
		var health_node = slots[index].get_node("Health");
		
		#STATS
		var poke = party[index];
		pokemon_node.texture = poke.data.party_texture;
		gender_node.frame = poke.data.gender;
		name_node.text = poke.data.name;
		level_node.text = str(poke.data.level);
		total_hp_node.text = str(poke.data.battle_stats["HP"]);
		remain_hp_node.text = str(poke.data.current_hp);
		health_node.scale.x = float(poke.data.current_hp) / float(poke.data.battle_stats["HP"]);
		
		if(health_node.scale.x <= 0.74 && health_node.scale.x > 0.28): 
			health_node.texture = YELLOW_BAR;
		elif(health_node.scale.x <= 0.28): health_node.texture = RED_BAR;
		
	current_slots_length = current_slots.size();
	current_slots[current_slots_length] = $Background; #CANCEL BUTTON

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

