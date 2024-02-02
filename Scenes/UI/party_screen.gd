extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect
@onready var select: Control = $Select
@onready var cursor: TextureRect = $Select/Cursor;
@onready var label: RichTextLabel = $Background/RichTextLabel;

const RED_BAR = preload("res://Assets/UI/red_bar.png");
const YELLOW_BAR = preload("res://Assets/UI/yellow_bar.png");
const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg")
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
const GUI_SEL_DECISION = preload("res://Assets/Sounds/GUI sel decision.ogg");
const party_screen_node =  "CurrentScene/PartyScreen";
const default_sentence = "Choose a POKéMON.";
const selected_sentence = "Do what with this POKéMON?";
const same_pokemon_sentence = "POKéMON is already fighting!";
const BACKGROUND_DEAD = preload("res://Assets/UI/standby_pokemon_background_dead.png");
const MAIN_BACKGROUND_DEAD = preload("res://Assets/UI/main_pokemon_background_dead.png")
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
	var cancel_slot = selected_slot == current_slots.size() - 1;
	if(!cancel_slot):
		var anim_player = slot.get_node("AnimationPlayer");
		var anim_name = anim_player.get_assigned_animation();
		if(value == int(State.ON)):
			if(anim_name == "Dead"): return;
			anim_player.play("Selected");
		elif(anim_name != "Dead"): anim_player.play("Idle");

func _input(event) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		closing
	): return;
	
	if(!select_open && !Input.is_action_just_pressed("space")): set_active_option(State.OFF);
	#CLOSE
	if(
		Input.is_action_just_pressed("menu") || 
		Input.is_action_just_pressed("backMenu") ||
		Input.is_action_just_pressed("escape")): close_party();
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
	if(!select_open): set_active_option(State.ON);

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
	if(selected_slot == int(Slots.FIFTH) || selected_slot == int(Slots.SIXTH)):
		select.position = select_position_upper;
	else: select.position = default_select_position;
	select_open = true;
	select.visible = true;
	label.text = selected_sentence;

func select_pokemon() -> void:
	var poke_name = slots[selected_slot].get_node("Name").text;
	if(GLOBAL.on_battle):
		var poke = PARTY.get_pokemon(poke_name);
		if(poke.data.death):
			label.text = "";
			await GLOBAL.timeout(0.1);
			label.text = poke_name + " can't fight!";
			return;
	if(GLOBAL.on_battle && poke_name == active_pokemon.name):
		label.text = "";
		await GLOBAL.timeout(0.1);
		label.text = same_pokemon_sentence;
		return;
	if(GLOBAL.on_battle):
		closing = true;
		PARTY.set_active_pokemon(poke_name);
		close_select(false);
		close_party();
		await GLOBAL.timeout(0.2);
		GLOBAL.emit_signal("selected_pokemon_party", poke_name);
		return;
	else: close_select();

func close_party() -> void:
	if(select_open): 
		close_select();
		return;
	closing = true;
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
		
		if(health_node.scale.x <= 0.74 && health_node.scale.x > 0.28): 
			health_node.texture = YELLOW_BAR;
		elif(health_node.scale.x <= 0.28): health_node.texture = RED_BAR;
		
		#STATUS
		if(poke.data.death):
			var panel = slot.get_node("Panel");
			if(index == int(Slots.FIRST)):
				panel.texture = MAIN_BACKGROUND_DEAD;
			else: panel.texture = BACKGROUND_DEAD;
			status_node.visible = true;
			
	current_slots_length = current_slots.size();
	current_slots[current_slots_length] = $Background; #CANCEL BUTTON

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
