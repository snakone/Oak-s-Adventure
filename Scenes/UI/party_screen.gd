extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect;
@onready var select: Control = $Select;
@onready var cursor: TextureRect = $Select/Cursor;
@onready var label: RichTextLabel = $Background/RichTextLabel;

@onready var v_box_container: VBoxContainer = $Select/VBoxContainer;
@onready var shift: RichTextLabel = $Select/VBoxContainer/Shift;
@onready var item: RichTextLabel = $Select/VBoxContainer/Item;
@onready var summary: RichTextLabel = $Select/VBoxContainer/Summary;

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const GUI_PARTY_SWITCH = preload("res://Assets/Sounds/GUI party switch.ogg");

const POKEMON_BACKGROUND = preload("res://Assets/UI/standby_pokemon_background.png");
const MAIN_POKEMON_BACKGROUND = preload("res://Assets/UI/main_pokemon_background.png");
const BACKGROUND_DEAD = preload("res://Assets/UI/standby_pokemon_background_dead.png");
const MAIN_BACKGROUND_DEAD = preload("res://Assets/UI/main_pokemon_background_dead.png");
const BACKGROUND_SWITCH = preload("res://Assets/UI/standby_pokemon_background_switch.png");
const MAIN_BACKGROUND_SWITCH = preload("res://Assets/UI/main_pokemon_background_switch.png");

const party_screen_node =  "CurrentScene/PartyScreen";
const default_sentence = "Choose a POKéMON.";
const selected_sentence = "Do what with this POKéMON?";
const same_pokemon_sentence = "POKéMON is already fighting!";
const exit_sentence = "Close";
const must_sentence = "Must select a POKéMON!";
const default_shift = "SHIFT";
const move_where_sentence = "Move to where?";
const cancel_switch_sentence = "Cancel Switch";

const default_select_position = Vector2(151, 97);
const select_position_upper_on_battle = Vector2(151, 2);
const select_position_upper = Vector2(151, 19);
const switch_anim_duration = 0.5;

enum Slots { FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH }
enum State { OFF, ON }
enum SelectSlot { FIRST, SECOND, THIRD, FOURTH }

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
var switching = false;
var switch_mode = false;
var current_switch_slot;

var select_cursor_default_position = [
	Vector2(8, -6), Vector2(8, 10), Vector2(8, 26), Vector2(8, 42)
];

func _ready():
	process_mode = Node.PROCESS_MODE_INHERIT;
	active_pokemon = PARTY.get_active_pokemon();
	label.text = default_sentence;
	select.visible = false;
	item.visible = false;
	create_select_panel();
	create_party_list();
	set_all_options();
	set_active_option(State.ON);
	if(GLOBAL.on_battle): select_cursor_default_position.pop_front();
	move_select_arrow();
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
	var panel = slot.get_node("Panel");
	panel.frame = value;
	
	var cancel_slot = selected_slot == current_slots_length;
	if(!cancel_slot):
		label.text = default_sentence;
		if(switch_mode):
			if(selected_slot == Slots.FIRST): 
				panel.texture = MAIN_BACKGROUND_SWITCH;
			else: panel.texture = BACKGROUND_SWITCH;
			label.text = move_where_sentence;
		var anim_player = slot.get_node("AnimationPlayer");
		var anim_name = anim_player.get_assigned_animation();
		#ACTIVE
		if(value == int(State.ON)):
			if(anim_name == "Dead"): return;
			anim_player.play("Selected");
		#DESACTIVE
		else:
			if(anim_name == "Dead"):
				if(selected_slot == Slots.FIRST): 
					panel.texture = MAIN_BACKGROUND_DEAD;
				else: panel.texture = BACKGROUND_DEAD;
			else: 
				if(selected_slot == Slots.FIRST): 
					panel.texture = MAIN_POKEMON_BACKGROUND;
				else: panel.texture = POKEMON_BACKGROUND;
				anim_player.play("Idle");
		#KEEP SWITCH ACTIVE
		if(current_switch_slot != null):
			var switch_panel = current_slots[current_switch_slot].get_node("Panel"); 
			if(current_switch_slot == Slots.FIRST): 
				switch_panel.texture = MAIN_BACKGROUND_SWITCH;
			else: switch_panel.texture = BACKGROUND_SWITCH;
	#CANCEL
	else:
		if(BATTLE.can_use_next_pokemon):
			label.text = must_sentence;
		else: 
			if(switch_mode): label.text = cancel_switch_sentence;
			else: label.text = exit_sentence;

func _input(event) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		closing ||
		switching
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

#SELECT SLOT
func select_slot() -> void:
	if(!select_open):
		match selected_slot:
			#POKEMON
			Slots.FIRST, Slots.SECOND, Slots.THIRD, Slots.FOURTH, Slots.FIFTH, Slots.SIXTH:
				select_input();
			#CANCEL
			current_slots_length:
				if(check_if_can_close()): close_party();
	#ON BATTLE
	elif(select_open && GLOBAL.on_battle):
		match select_index:
			SelectSlot.FIRST: select_pokemon();
			SelectSlot.THIRD: close_select();
	#NORMAL PARTY
	elif(select_open && !GLOBAL.on_battle):
		match select_index:
			SelectSlot.SECOND: switch_slot();
			SelectSlot.FOURTH: close_select();

func select_input() -> void:
	if(selected_slot == current_switch_slot && switch_mode):
		close_party();
		return;
	elif(switch_mode):
		switch_pokemon();
		return;
	play_audio(GUI_SEL_DECISION);
	
	#OPEN SELECT
	if(
		selected_slot == int(Slots.FIFTH) || 
		selected_slot == int(Slots.SIXTH)
	):
		if(GLOBAL.on_battle):
			select.position = select_position_upper_on_battle;
		else: select.position = select_position_upper;
	else: select.position = default_select_position;
	if(BATTLE.can_use_next_pokemon): shift.text = "SEND OUT";
	elif(GLOBAL.on_battle): shift.text = default_shift;
	select_open = true;
	select.visible = true;
	label.text = selected_sentence;

#SWITCH
func switch_pokemon() -> void:
	switching = true;
	play_audio(GUI_SEL_DECISION);
	
	var slots_array = [
		slots[selected_slot].get_node("Switch"),
		slots[current_switch_slot].get_node("Switch")
	];
	
	#OUT
	play_audio(GUI_PARTY_SWITCH);
	for anim_player in slots_array:
		anim_player.play("SwitchOut");
	await GLOBAL.timeout(switch_anim_duration);
	
	#SET NEW PARTY
	PARTY.swap_party_pokemon(current_switch_slot, selected_slot);
	current_slots = {};
	current_slots_length = 0;
	create_party_list();
	set_all_options();
	await GLOBAL.timeout(0.1);
	
	#IN
	play_audio(GUI_PARTY_SWITCH);
	for anim_player in slots_array:
		anim_player.play("SwitchIn");
	await GLOBAL.timeout(switch_anim_duration);
	close_party(false, false);
	if(selected_slot == Slots.FIRST):
		PARTY.reset_all_active(true);
	await GLOBAL.timeout(0.2);
	switching = false;

#SELECT POKEMON
func select_pokemon() -> void:
	var poke_name = slots[selected_slot].get_node("Name").text;
	var poke = PARTY.get_pokemon(poke_name);
	#BATTLE
	if(GLOBAL.on_battle):
		play_audio(GUI_SEL_DECISION);
		if(poke.data.death):
			label.text = poke_name + " can't fight!";
			return;
		if(active_pokemon && poke_name == active_pokemon.name):
			label.text = same_pokemon_sentence;
			return;
		select_poke_and_change(poke_name);
		return;
	else: close_select();

#CHANGE POKEMON
func select_poke_and_change(poke_name: String) -> void:
	label.text = selected_sentence;
	closing = true;
	BATTLE.can_use_menu = false;
	PARTY.reset_all_active();
	PARTY.set_active_pokemon(poke_name);
	await GLOBAL.timeout(0.2);
	close_party(false);
	PARTY.emit_signal("selected_pokemon_party", poke_name);

#CLOSE
func close_party(sound = true, reset_list = true) -> void:
	if(switch_mode):
		if(sound): play_audio(GUI_SEL_DECISION);
		label.text = default_sentence;
		switch_mode = false;
		current_switch_slot = null;
		if(reset_list): reset();
		return;
	closing = true;
	GLOBAL.party_open = false;
	if(sound): play_audio(GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PartyScreen");
	if(GLOBAL.on_battle): BATTLE.state = BATTLE.States.MENU;
	process_mode = Node.PROCESS_MODE_DISABLED;

#SWITCH SLOT
func switch_slot() -> void:
	close_select();
	switch_mode = true;
	label.text = move_where_sentence;
	var slot = current_slots[selected_slot];
	var panel = slot.get_node("Panel");
	current_switch_slot = selected_slot;
	if(selected_slot == Slots.FIRST): panel.texture = MAIN_BACKGROUND_SWITCH;
	else: panel.texture = BACKGROUND_SWITCH;

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
	if(GLOBAL.on_battle):
		if(select_index > SelectSlot.THIRD): 
			select_index = int(SelectSlot.FIRST);
	else:
		if(select_index > SelectSlot.FOURTH): 
			select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func select_UP() -> void:
	if(GLOBAL.on_battle):
		if(select_index == SelectSlot.FIRST): 
			select_index = int(SelectSlot.THIRD);
		else: select_index -= 1;
	else:
		if(select_index == SelectSlot.FIRST): 
			select_index = int(SelectSlot.FOURTH);
		else: select_index -= 1;
	move_select_arrow();

#CLOSE SELECT
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

#CREATE SELECT
func create_select_panel() -> void:
	if(!GLOBAL.on_battle):
		v_box_container.move_child(summary, 0);
		v_box_container.move_child(shift, 1);
		v_box_container.position = Vector2(17, 3);
		shift.text = "SWITCH";
		item.visible = true;
		nine_rect.position = Vector2(0, -15);
		nine_rect.set_deferred("size", Vector2(87, 76));

#CREATE PARTY
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
		
		status_node.visible = false;
		
		#STATS
		var poke = party[index];
		pokemon_node.texture = poke.data.party_texture;
		if("gender" in poke.data):
			gender_node.visible = true;
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
		var panel = slot.get_node("Panel");
		if(poke.data.death):
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_BACKGROUND_DEAD;
			else: panel.texture = BACKGROUND_DEAD;
			status_node.visible = true;
		else:
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_POKEMON_BACKGROUND;
			else: panel.texture = POKEMON_BACKGROUND;
			
	current_slots_length = current_slots.size();
	#CANCEL BUTTON - CHILD PANEL NODE
	current_slots[current_slots_length] = $Background;
	if(!switch_mode): label.text = default_sentence;

func reset() -> void:
	var party = PARTY.get_party();
	for index in range(0, party.size()):
		var slot = slots[index];
		var panel = slot.get_node("Panel");
		var poke = party[index];
		if(poke.data.death):
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_BACKGROUND_DEAD;
			else: panel.texture = BACKGROUND_DEAD;
		else:
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_POKEMON_BACKGROUND;
			else: panel.texture = POKEMON_BACKGROUND;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
