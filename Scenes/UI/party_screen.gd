extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect
@onready var select: Control = $Select
@onready var cursor: TextureRect = $Select/Cursor;
@onready var label: RichTextLabel = $Background/RichTextLabel;
@onready var shift: RichTextLabel = $Select/VBoxContainer/Shift

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const BACKGROUND_DEAD = preload("res://Assets/UI/standby_pokemon_background_dead.png");
const MAIN_BACKGROUND_DEAD = preload("res://Assets/UI/main_pokemon_background_dead.png");

const party_screen_node =  "CurrentScene/PartyScreen";
const default_sentence = "Choose a POKéMON.";
const selected_sentence = "Do what with this POKéMON?";
const same_pokemon_sentence = "POKéMON is already fighting!";
const exit_sentence = "Close";
const must_sentence = "Must select a POKéMON!";
const default_shift = "SHIFT";

const default_select_position = Vector2(151, 97);
const select_position_upper = Vector2(151, 2);

enum Slots { FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH }
enum State { OFF, ON }
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
var active_pokemon: Object;
var closing = false;

var select_cursor_default_position = [
	Vector2(8, 9), Vector2(8, 25), Vector2(8, 41)
];

func _ready():
	active_pokemon = PARTY.get_active_pokemon();
	label.text = default_sentence;
	select.visible = false;
	process_mode = Node.PROCESS_MODE_INHERIT;
	create_party_list();
	set_all_options();
	set_active_option(State.ON);
	if(SETTINGS.selected_marker):
		nine_rect.texture = SETTINGS.selected_marker; 

func set_all_options() -> void:
	var party = PARTY.current_party;
	for index in current_slots:
		var cancel_slot = index == current_slots.size() - 1;
		if(!cancel_slot):
			var slot = current_slots[index];
			var poke = party[index];
			var anim_player = slot.get_node("AnimationPlayer");
			if(poke.data.death): anim_player.play("Dead");
			else: anim_player.play("Idle");

func set_active_option(value: State) -> void:
	var slot = current_slots[selected_slot];
	slot.get_node("Panel").frame = value;
	var cancel_slot = selected_slot == current_slots_length;
	if(!cancel_slot):
		label.text = default_sentence;
		var anim_player = slot.get_node("AnimationPlayer");
		var anim_name = anim_player.get_assigned_animation();
		if(value == int(State.ON)):
			if(anim_name == "Dead"): return;
			anim_player.play("Selected");
		elif(anim_name != "Dead"): anim_player.play("Idle");
	else:
		if(BATTLE.can_use_next_pokemon):
			label.text = must_sentence;
		else: label.text = exit_sentence;

func _input(event) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		closing
	): return;
	
	if(
		!select_open && 
		!Input.is_action_just_pressed("space") &&
		!Input.is_action_just_pressed("backMenu")
	): 
		set_active_option(State.OFF);
	#CLOSE
	if(
		Input.is_action_just_pressed("backMenu") &&
		!select_open &&
		check_if_can_close()
	): 
		close_party();
		return;
	if(Input.is_action_just_pressed("backMenu") && select_open): 
		close_select();
		label.text = default_sentence;
		return;
	#DOWN
	if(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		(Input.is_action_just_pressed("moveRight") || 
		Input.is_action_just_pressed("ui_right")) && 
		selected_slot == Slots.FIRST): handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_just_pressed("moveLeft") || 
		Input.is_action_just_pressed("ui_left")) && 
		selected_slot != Slots.FIRST): handle_LEFT();
	#SELECT
	elif(Input.is_action_just_pressed("space")): select_slot();
	if(
		!select_open && 
		!Input.is_action_just_pressed("backMenu")
	): set_active_option(State.ON);

func select_slot() -> void:
	if(!select_open):
		match selected_slot:
			Slots.FIRST, Slots.SECOND, Slots.THIRD, Slots.FOURTH, Slots.FIFTH, Slots.SIXTH:
				select_input();
			current_slots_length:
				if(check_if_can_close()): close_party();
	elif(select_open):
		match select_index:
			SelectSlot.FIRST: select_pokemon();
			SelectSlot.THIRD: close_select();

func select_input() -> void:
	play_audio(GUI_SEL_DECISION);
	if(selected_slot == int(Slots.FIFTH) || selected_slot == int(Slots.SIXTH)):
		select.position = select_position_upper;
	else: select.position = default_select_position;
	if(BATTLE.can_use_next_pokemon): shift.text = "SEND OUT";
	else: shift.text = default_shift;
	select_open = true;
	select.visible = true;
	label.text = selected_sentence;

func select_pokemon() -> void:
	var poke_name = slots[selected_slot].get_node("Name").text;
	var poke = PARTY.get_pokemon(poke_name);
	#BATTLE
	if(GLOBAL.on_battle):
		play_audio(GUI_SEL_DECISION);
		if(poke.data.death):
			label.text = poke_name + " can't fight!";
			return;
		if(poke_name == active_pokemon.name):
			label.text = same_pokemon_sentence;
			return;
		select_poke_and_switch(poke_name);
		return;
	else: close_select();
	
func select_poke_and_switch(poke_name: String) -> void:
	label.text = selected_sentence;
	closing = true;
	BATTLE.can_use_menu = false;
	PARTY.set_active_pokemon(poke_name);
	close_party(false);
	await GLOBAL.timeout(0.2);
	PARTY.emit_signal("selected_pokemon_party", poke_name);

func close_party(sound = true) -> void:
	closing = true;
	if(sound): play_audio(GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PartyScreen");
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
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func check_if_can_close() -> bool:
	if(BATTLE.can_use_next_pokemon):
		label.text = must_sentence;
		return false;
	return true;

func move_select_arrow() -> void:
	cursor.position = select_cursor_default_position[select_index];

func create_party_list() -> void:
	var party = PARTY.get_party();
	for index in range(0, party.size()):
		var slot = slots[index];
		slot.visible = true;
		current_slots[index] = slot;
		#NODES
		var pokemon_node = slot.get_node("Pokemon");
		var gender_node = slot.get_node("Gender");
		var name_node = slot.get_node("Name");
		var level_node = slot.get_node("Level");
		var total_hp_node = slot.get_node("TotalHP");
		var remain_hp_node = slot.get_node("RemainHP");
		var health_node = slot.get_node("Health");
		var status_node = slot.get_node("Status");
		
		#STATS
		var poke = party[index];
		pokemon_node.texture = poke.data.party_texture;
		gender_node.frame = poke.data.gender;
		name_node.text = poke.data.name;
		level_node.text = str(poke.data.level);
		total_hp_node.text = str(poke.data.battle_stats["HP"]);
		remain_hp_node.text = str(poke.data.current_hp);
		health_node.scale.x = float(poke.data.current_hp) / float(poke.data.battle_stats["HP"]);
		
		#HP COLOR
		var perct = health_node.scale.x;
		if(perct >= BATTLE.GREEN_BAR_PERCT): health_node.texture = BATTLE.GREEN_BAR;
		elif(perct < BATTLE.GREEN_BAR_PERCT && perct > BATTLE.YELLOW_BAR_PERCT): 
			health_node.texture = BATTLE.YELLOW_BAR;
		elif(perct < BATTLE.YELLOW_BAR_PERCT): health_node.texture = BATTLE.RED_BAR;
		
		if(
			active_pokemon && 
			active_pokemon.name == poke.data.name && 
			GLOBAL.on_battle
		): selected_slot = index;
		
		#STATUS
		if(poke.data.death):
			var panel = slot.get_node("Panel");
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_BACKGROUND_DEAD;
			else: panel.texture = BACKGROUND_DEAD;
			status_node.visible = true;
			
	current_slots_length = current_slots.size();
	#CANCEL BUTTON - CHILD PANEL NODE
	current_slots[current_slots_length] = $Background;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
