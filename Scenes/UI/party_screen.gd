extends CanvasLayer

@onready var audio = $AudioStreamPlayer;
@onready var nine_rect: NinePatchRect = $Select/NinePatchRect;
@onready var select: Control = $Select;
@onready var item_select: Control = $ItemSelect;
@onready var cursor: TextureRect = $Select/Cursor;
@onready var label: RichTextLabel = $Background/RichTextLabel;
@onready var item_cursor: TextureRect = $ItemSelect/Cursor

@onready var v_box_container: VBoxContainer = $Select/VBoxContainer;
@onready var shift: RichTextLabel = $Select/VBoxContainer/Shift;
@onready var item: RichTextLabel = $Select/VBoxContainer/Item;
@onready var summary: RichTextLabel = $Select/VBoxContainer/Summary;

const party_screen_node =  "CurrentScene/PartyScreen";
const default_sentence = "Choose a POKéMON.";
const selected_sentence = "Do what with this POKéMON?";
const same_pokemon_sentence = "POKéMON is already fighting!";
const exit_sentence = "Close";
const must_sentence = "Must select a POKéMON!";
const default_shift = "SHIFT";
const move_where_sentence = "Move to where?";
const cancel_switch_sentence = "Cancel Switch";

const summary_screen_path = "res://Scenes/UI/summary_screen.tscn";
const bag_screen_path = "res://Scenes/UI/Bag/bag_screen.tscn";

const default_select_position = Vector2(151, 97);
const select_position_upper_on_battle = Vector2(151, 2);
const select_position_upper = Vector2(151, 19);
const switch_anim_duration = 0.5;
const ITEM_DIALOG = 74;

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
var selected_pokemon: Object;
var in_item_mode = false;
var current_held_item = null;
var current_item = null;
var can_use_select = true;

var select_cursor_default_position = [
	Vector2(8, -5.5), Vector2(8, 10), Vector2(8, 26), Vector2(8, 42)
];

var select_item_cursor_default_position = [
	Vector2(23, 10.5), Vector2(23, 26), Vector2(23, 42)
];

func _ready():
	GLOBAL.party_open = true;
	process_mode = Node.PROCESS_MODE_INHERIT;
	connect_signals();
	active_pokemon = PARTY.get_active_pokemon();
	label.text = default_sentence;
	select.visible = false;
	item.visible = false;
	create_select_panel();
	create_party_list();
	set_all_options();
	set_active_option(State.ON);
	if(GLOBAL.on_battle): 
		select_cursor_default_position.pop_front();
		BATTLE.party_pokemon_selected = false;
	move_select_arrow();
	check_for_held_items();
	nine_rect.texture = SETTINGS.player_settings.marker; 

func set_all_options() -> void:
	var party = PARTY.current_party;
	for index in current_slots:
		var cancel_slot = index == current_slots.size() - 1;
		if(!cancel_slot):
			var slot = current_slots[index];
			var poke = party[index];
			var anim_player = slot.get_node("AnimationPlayer");
			if(poke.data.death): anim_player.play("Dead");
			else:
				if(index == selected_slot): anim_player.play("Selected");
				else: anim_player.play("Idle");

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.dialog_open ||
		closing ||
		switching ||
		Input.is_action_just_pressed("menu") ||
		PARTY.must_select_item
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

func set_active_option(value: State) -> void:
	var slot = current_slots[selected_slot];
	var panel = slot.get_node("Panel");
	panel.frame = value;
	
	var cancel_slot = selected_slot == current_slots_length;
	if(!cancel_slot):
		label.text = default_sentence;
		if(switch_mode):
			if(selected_slot == Slots.FIRST): 
				panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_SWITCH;
			else: panel.texture = LIBRARIES.IMAGES.BACKGROUND_SWITCH;
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
					panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_DEAD;
				else: panel.texture = LIBRARIES.IMAGES.BACKGROUND_DEAD;
			else: 
				if(selected_slot == Slots.FIRST): 
					panel.texture = LIBRARIES.IMAGES.MAIN_POKEMON_BACKGROUND;
				else: panel.texture = LIBRARIES.IMAGES.POKEMON_BACKGROUND;
				anim_player.play("Idle");
		#KEEP SWITCH ACTIVE
		if(current_switch_slot != null):
			var switch_panel = current_slots[current_switch_slot].get_node("Panel"); 
			if(current_switch_slot == Slots.FIRST): 
				switch_panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_SWITCH;
			else: switch_panel.texture = LIBRARIES.IMAGES.BACKGROUND_SWITCH;
	#CANCEL
	else:
		if(BATTLE.can_use_next_pokemon):
			label.text = must_sentence;
		else: 
			if(switch_mode): label.text = cancel_switch_sentence;
			else: label.text = exit_sentence;

#SELECT SLOT
func select_slot() -> void:
	if(!select_open):
		match selected_slot:
			#CANCEL
			current_slots_length:
				if(check_if_can_close()): close_party();
			#POKEMON
			Slots.FIRST, Slots.SECOND, Slots.THIRD, Slots.FOURTH, Slots.FIFTH, Slots.SIXTH:
				select_input();
		
	#ON BATTLE
	elif(select_open && GLOBAL.on_battle):
		match select_index:
			SelectSlot.FIRST: select_pokemon();
			SelectSlot.SECOND: open_summary();
			SelectSlot.THIRD: close_select();
	#NORMAL PARTY
	elif(select_open && !GLOBAL.on_battle && !in_item_mode):
		match select_index:
			SelectSlot.FIRST: open_summary();
			SelectSlot.SECOND: switch_slot();
			SelectSlot.THIRD: item_mode();
			SelectSlot.FOURTH: close_select();
	#ITEM MODE
	elif(select_open && !GLOBAL.on_battle && in_item_mode && can_use_select):
		match select_index:
			SelectSlot.FIRST: give_item();
			SelectSlot.SECOND: take_item();
			SelectSlot.THIRD: close_select();

func give_item() -> void:
	PARTY.must_select_item = true;
	GLOBAL.on_overlay = true;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	GLOBAL.go_to_scene(bag_screen_path, false, false);

func take_item() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	close_all_panels();
	if(selected_pokemon.data.held_item == null):
		GLOBAL.emit_signal(
			"create_dialog", ITEM_DIALOG, 
			[[selected_pokemon.name + " isn't holding anything."]]);
		await GLOBAL.close_dialog;
		return;
	#GIVE ITEM BACK
	BAG.add_item(selected_pokemon.data.held_item, 1);
	var item_data = BAG.get_item_by_id(selected_pokemon.data.held_item);
	if(item_data != null):
		GLOBAL.emit_signal(
			"create_dialog", ITEM_DIALOG, 
			[["Received the " + item_data.name + " from " + selected_pokemon.name + "."]]);
		await GLOBAL.close_dialog;
		selected_pokemon.data.held_item = null;
		check_for_held_items();

func select_input() -> void:
	if(selected_slot == current_switch_slot && switch_mode):
		reset_switch_mode();
		return;
	elif(switch_mode):
		switch_pokemon();
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	selected_pokemon = PARTY.get_party()[selected_slot];
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
	label.text = selected_sentence;
	select_open = true;
	select.visible = true;

func item_mode() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	select.visible = false;
	in_item_mode = true;
	can_use_select = false;
	await GLOBAL.timeout(0.1);
	item_select.visible = true;
	label.text = "Do what with an item?";
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();
	await GLOBAL.timeout(0.2);
	can_use_select = true;

#SWITCH
func switch_pokemon() -> void:
	switching = true;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	
	var slots_array = [
		slots[selected_slot].get_node("Switch"),
		slots[current_switch_slot].get_node("Switch")
	];
	
	#OUT
	play_audio(LIBRARIES.SOUNDS.GUI_PARTY_SWITCH);
	for anim_player in slots_array:
		anim_player.play("SwitchOut");
	await GLOBAL.timeout(switch_anim_duration);
	
	#SET NEW PARTY
	PARTY.swap_party_pokemon(current_switch_slot, selected_slot);
	current_slots = {};
	current_slots_length = 0;
	create_party_list();
	set_all_options();
	check_for_held_items();
	await GLOBAL.timeout(0.1);
	
	#IN
	play_audio(LIBRARIES.SOUNDS.GUI_PARTY_SWITCH);
	for anim_player in slots_array:
		anim_player.play("SwitchIn");
	await GLOBAL.timeout(switch_anim_duration);
	reset_switch_mode(false, false);
	PARTY.reset_all_active(true);
	await GLOBAL.timeout(0.2);
	switching = false;

#SELECT POKEMON
func select_pokemon() -> void:
	#BATTLE
	if(GLOBAL.on_battle):
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
		if(selected_pokemon.data.death):
			label.text = selected_pokemon.name + " can't fight!";
			return;
		if(active_pokemon && selected_pokemon.data.uuid == active_pokemon.data.uuid):
			label.text = same_pokemon_sentence;
			return;
		select_poke_and_change(selected_pokemon.data.uuid);
		return;
	else: close_select();

#CHANGE POKEMON
func select_poke_and_change(uuid: String) -> void:
	label.text = selected_sentence;
	closing = true;
	PARTY.reset_all_active();
	PARTY.set_active_pokemon(uuid);
	if(GLOBAL.on_battle): 
		BATTLE.party_pokemon_selected = true;
		BATTLE.can_use_menu = false;
	await GLOBAL.timeout(0.2);
	close_party(false);
	PARTY.emit_signal("selected_pokemon_party", uuid);

#CLOSE
func close_party(sound = true, reset_list = true) -> void:
	if(switch_mode): 
		reset_switch_mode(sound, reset_list);
		return;
	closing = true;
	GLOBAL.on_overlay = false;
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PartyScreen");
	if(GLOBAL.on_battle): BATTLE.state = ENUMS.BattleStates.MENU;
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.party_open = false;

func reset_switch_mode(sound = true, reset_list = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	label.text = default_sentence;
	switch_mode = false;
	current_switch_slot = null;
	if(reset_list): reset();

#SWITCH SLOT
func switch_slot() -> void:
	close_select();
	switch_mode = true;
	label.text = move_where_sentence;
	var slot = current_slots[selected_slot];
	var panel = slot.get_node("Panel");
	current_switch_slot = selected_slot;
	if(selected_slot == Slots.FIRST): 
		panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_SWITCH;
	else: panel.texture = LIBRARIES.IMAGES.BACKGROUND_SWITCH;

func handle_DOWN() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(select_open):
		select_DOWN();
		return;
	selected_slot += 1;
	if(selected_slot > current_slots_length): 
		selected_slot = int(Slots.FIRST);

func handle_UP() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	if(select_open): 
		select_UP();
		return;
	if(selected_slot == 0): selected_slot = current_slots_length;
	else: selected_slot -= 1;

func handle_RIGHT() -> void:
	if(select_open): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	selected_slot = int(last_slot_before_moving_left);

func handle_LEFT() -> void:
	if(select_open): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	last_slot_before_moving_left = int(selected_slot);
	selected_slot = int(Slots.FIRST);

#SELECT
func select_DOWN() -> void:
	select_index += 1;
	if(GLOBAL.on_battle || in_item_mode):
		if(select_index > SelectSlot.THIRD): 
			select_index = int(SelectSlot.FIRST);
	elif(!in_item_mode):
		if(select_index > SelectSlot.FOURTH): 
			select_index = int(SelectSlot.FIRST);
	move_select_arrow();

func select_UP() -> void:
	if(GLOBAL.on_battle || in_item_mode):
		if(select_index == SelectSlot.FIRST): 
			select_index = int(SelectSlot.THIRD);
		else: select_index -= 1;
	elif(!in_item_mode):
		if(select_index == SelectSlot.FIRST): 
			select_index = int(SelectSlot.FOURTH);
		else: select_index -= 1;
	move_select_arrow();

#SUMMARY
func open_summary() -> void:
	closing = true;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	await audio.finished;
	GLOBAL.summary_pokemon = selected_pokemon;
	GLOBAL.summary_index = selected_slot;
	process_mode = Node.PROCESS_MODE_DISABLED;
	GLOBAL.go_to_scene(summary_screen_path, false, false);

#CLOSE SELECT
func close_select(sound = true) -> void:
	if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();
	if(in_item_mode):
		in_item_mode = false;
		item_select.visible = false;
		await GLOBAL.timeout(0.1);
		label.text = selected_sentence;
		select.visible = true;
		return;
	select_open = false;
	select.visible = false;

func check_if_can_close() -> bool:
	if(BATTLE.can_use_next_pokemon):
		label.text = must_sentence;
		return false;
	return true;

func move_select_arrow() -> void:
	if(in_item_mode):
		item_cursor.position = select_item_cursor_default_position[select_index];
	cursor.position = select_cursor_default_position[select_index];

#ON ITEM SELECT
func _on_item_select(selected_item: Dictionary):
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();
	close_all_panels();
	await GLOBAL.timeout(0.2);
	if(selected_pokemon.data.held_item != null):
		var item_name = BAG.get_item_by_id(selected_pokemon.data.held_item).name;
		GLOBAL.emit_signal("create_dialog", ITEM_DIALOG, [[
		selected_pokemon.name + ' is already holding\none ' + item_name + "."
	  ]]);
		await GLOBAL.close_dialog;
		switching = true;
		current_held_item = selected_pokemon.data.held_item;
		current_item = selected_item.id;
		GLOBAL.start_dialog.emit(75);
		await GLOBAL.close_dialog;
		return;
	selected_pokemon.data.held_item = selected_item.id;
	GLOBAL.emit_signal("create_dialog", ITEM_DIALOG, [[
		selected_pokemon.name + ' was given\nthe ' + selected_item.name + " to hold."
	]]);
	await GLOBAL.close_dialog;
	label.text = default_sentence;
	PARTY.must_select_item = false;
	check_for_held_items();

func switch_pokemon_item() -> void:
	if(current_held_item != null && current_item != null):
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
		var item_name = BAG.get_item_by_id(current_held_item).name;
		var current_item_name = BAG.get_item_by_id(current_item).name;
		BAG.add_item(current_held_item, 1);
		selected_pokemon.data.held_item = current_item;
		GLOBAL.emit_signal("create_dialog", ITEM_DIALOG, [[
		"The " + item_name + ' was taken and\nreplaced with ' + current_item_name + "."
		]]);
		await GLOBAL.close_dialog;
		switching = false;
		current_held_item = null;
		current_item = null;
		check_for_held_items();

func close_all_panels() -> void:
	in_item_mode = false;
	item_select.visible = false;
	select_open = false;
	select.visible = false;
	select_index = int(SelectSlot.FIRST);
	move_select_arrow();

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
		pokemon_node.texture = poke.data.specie.party_texture;
		if("gender" in poke.data):
			gender_node.visible = true;
			gender_node.frame = poke.data.gender;
		else: gender_node.visible = false;
		name_node.text = poke.data.name;
		level_node.text = str(poke.data.level);
		total_hp_node.text = str(poke.data.battle_stats["HP"]);
		remain_hp_node.text = str(poke.data.current_hp);
		health_node.scale.x = min(float(poke.data.current_hp) / float(poke.data.battle_stats["HP"]), 1);
		
		#HP COLOR
		var perct = health_node.scale.x;
		if(perct >= BATTLE.GREEN_BAR_PERCT): 
			health_node.texture = LIBRARIES.IMAGES.GREEN_BAR;
		elif(perct < BATTLE.GREEN_BAR_PERCT && perct > BATTLE.YELLOW_BAR_PERCT): 
			health_node.texture = LIBRARIES.IMAGES.YELLOW_BAR;
		elif(perct < BATTLE.YELLOW_BAR_PERCT): 
			health_node.texture = LIBRARIES.IMAGES.RED_BAR;
		
		if(
			active_pokemon && 
			active_pokemon.name == poke.data.name && 
			GLOBAL.on_battle
		): selected_slot = index;
		
		#STATUS
		var panel = slot.get_node("Panel");
		if(poke.data.death):
			if(index == int(Slots.FIRST)):
				panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_DEAD;
			else: panel.texture = LIBRARIES.IMAGES.BACKGROUND_DEAD;
			status_node.visible = true;
		else:
			if(index == int(Slots.FIRST)):
				panel.texture = LIBRARIES.IMAGES.MAIN_POKEMON_BACKGROUND;
			else: panel.texture = LIBRARIES.IMAGES.POKEMON_BACKGROUND;
			
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
				panel.texture = LIBRARIES.IMAGES.MAIN_BACKGROUND_DEAD;
			else: panel.texture = LIBRARIES.IMAGES.BACKGROUND_DEAD;
		else:
			if(index == int(Slots.FIRST)):
				panel.texture = LIBRARIES.IMAGES.MAIN_POKEMON_BACKGROUND;
			else: panel.texture = LIBRARIES.IMAGES.POKEMON_BACKGROUND;

func _on_selection_value_select(
	value: int,
	category: ENUMS.SelectionCategory
	):
		if(category != ENUMS.SelectionCategory.BINARY): return;
		match value:
			ENUMS.BinaryOptions.YES: switch_pokemon_item();

func check_for_held_items() -> void:
	var party = PARTY.get_party();
	for index in range(0, party.size()):
		var slot = slots[index];
		var poke = party[index];
		var held_item_slot = slot.get_node("Held_Item");
		if(poke.data.held_item != null && held_item_slot):
			held_item_slot.visible = true;
		else: held_item_slot.visible = false;

func _on_scene_opened(value: bool, _node_name: String) -> void:
	if(value): return;
	closing = false;
	process_mode = Node.PROCESS_MODE_INHERIT;

func connect_signals() -> void:
	GLOBAL.connect("scene_opened", _on_scene_opened);
	PARTY.connect("selected_item_for_pokemon", _on_item_select);
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
