extends CanvasLayer

@onready var hand: Control = $Node2D/Hand;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var box_anim_player: AnimationPlayer = $Node2D/Boxes/AnimationPlayer;
@onready var close: Sprite2D = $Node2D/Close/Sprite2D;
@onready var anim_hand: AnimationPlayer = $Node2D/Hand/AnimationPlayer;
@onready var boxes: Node2D = $Node2D/Boxes;
@onready var box_sprite: Sprite2D = $Node2D/Boxes/Box/Sprite2D;
@onready var previous_sprite: Sprite2D = $Node2D/Boxes/Previous/Sprite2D;
@onready var next_sprite: Sprite2D = $Node2D/Boxes/Next/Sprite2D;
@onready var box_name: RichTextLabel = $Node2D/Boxes/Box/Name;
@onready var previous_name: RichTextLabel = $Node2D/Boxes/Previous/Name;
@onready var next_name: RichTextLabel = $Node2D/Boxes/Next/Name;
@onready var pokemon_box: Node2D = $Node2D/Boxes/Box/Pokemon;
@onready var previous_pokemon_box: Node2D = $Node2D/Boxes/Previous/Pokemon;
@onready var next_pokemon_box: Node2D = $Node2D/Boxes/Next/Pokemon;
@onready var data_anim_player: AnimationPlayer = $Node2D/Data/AnimationPlayer;
@onready var inactive: Sprite2D = $Node2D/Data/Inactive;
@onready var active: Sprite2D = $Node2D/Data/Active;
@onready var active_sprite: AnimatedSprite2D = $Node2D/Data/Active/Sprite2D;
@onready var active_name: RichTextLabel = $Node2D/Data/Active/Control/Name;
@onready var active_gender: Sprite2D = $Node2D/Data/Active/Control/Gender;
@onready var active_level: RichTextLabel = $Node2D/Data/Active/Control/Level;
@onready var party_panel: Node2D = $Node2D/Party/Panel;
@onready var party_anim_player: AnimationPlayer = $Node2D/Party/AnimationPlayer;

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");
enum Slots { FIRST, SECOND, THIRD, FOURTH, FIFTH, SIXTH }

enum Positions {
	OPTIONS = -2,
	BOX_SWITCH = -1,
	PARTY = 6
}

@onready var party_slots = {
	Slots.FIRST: $Node2D/Party/Panel/First,
	Slots.SECOND: $Node2D/Party/Panel/Second,
	Slots.THIRD: $Node2D/Party/Panel/Third,
	Slots.FOURTH: $Node2D/Party/Panel/Fourth,
	Slots.FIFTH: $Node2D/Party/Panel/Fifth,
	Slots.SIXTH: $Node2D/Party/Panel/Sixth,
}

var current_hand_pos = Vector2.ZERO;
var boxes_length: int;
var changing_box = false;
var picking = false;
var holding = false;
var closing = false;
var selected_index = 0;
var current_index = 0;
var selected_box = 1;
var current_box = 1;

var current_node: Node2D;
var holding_sprite = Sprite2D.new();
var holding_poke: Node;
var selected_hand_pos: Vector2;
var party_panel_opened = false;
var party = null;
var party_length: int;
var position_before_party_left: int = 1;
var current_party_index = 0;
var selected_party_index: int = 0;

func _ready() -> void:
	boxes_length = GLOBAL.boxes_background.keys().size();
	update_hand();
	update_box();
	party = PARTY.get_party().duplicate(true);
	party_length = party.size();
	var new_enemy = POKEDEX.get_pokemon(250);
	var enemy = Pokemon.new(new_enemy, true);
	var new_enemy2 = POKEDEX.get_pokemon(384);
	var enemy2 = Pokemon.new(new_enemy2, true);
	var new_enemy3 = POKEDEX.get_pokemon(7);
	var enemy3 = Pokemon.new(new_enemy3, true);
	GLOBAL.boxes_array[0][1] = enemy;
	GLOBAL.boxes_array[0][5] = enemy2;
	GLOBAL.boxes_array[1][18] = enemy3;
	update_all_boxes();
	set_holding_sprite();
	set_party_panel();

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		!GLOBAL.on_boxes ||
		changing_box ||
		picking ||
		closing
	): return;
	
	if(Input.is_action_just_pressed("backMenu")): close_box();
	#DOWN
	elif(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		(Input.is_action_just_pressed("moveRight") || 
		Input.is_action_just_pressed("ui_right"))): handle_RIGHT();
	#LEFT
	elif(
		(Input.is_action_just_pressed("moveLeft") || 
		Input.is_action_just_pressed("ui_left"))): handle_LEFT();
	#SELECT
	elif(Input.is_action_just_pressed("space")): select_slot();
	update_hand();

func update_hand() -> void:
	hand.position = GLOBAL.HAND_POSITIONS[current_hand_pos];
	set_index();
	if(!party_panel_opened):
		#BOX
		if(current_hand_pos.y == int(Positions.BOX_SWITCH)):
			if(box_anim_player.is_playing()):
				await box_anim_player.animation_finished;
			box_anim_player.play("BoxSelected");
		else: box_anim_player.stop();
		#SHADOW
		if(current_hand_pos.y < 0): hand.get_node("Shadow").visible = false;
		else: hand.get_node("Shadow").visible = true;
		#FLIP
		if(current_hand_pos.y == int(Positions.OPTIONS)): 
			hand.get_node("Sprite2D").flip_v = true;
		else: hand.get_node("Sprite2D").flip_v = false;
		#CLOSE
		if(current_hand_pos == Vector2(1, -2)): close.frame = 0;
		else: close.frame = 1;
		if(!holding && is_pokemon_in_box()):
			var poke = GLOBAL.boxes_array[current_box - 1][current_index];
			set_active(poke);
		elif(!holding): remove_active();
	else:
		if(!holding && is_pokemon_in_party()):
			var poke = party[current_party_index];
			set_active(poke);
		elif(!holding): remove_active();

#UPDATE
func update_box() -> void:
	set_current_box();
	if(current_box == 1):
		set_next_box();
		previous_sprite.texture = GLOBAL.boxes_background[boxes_length].texture;
		previous_name.text = GLOBAL.boxes_background[boxes_length].name;
	elif(current_box == boxes_length):
		next_sprite.texture = GLOBAL.boxes_background[1].texture;
		next_name.text = GLOBAL.boxes_background[1].name;
		set_previous_box();
	else:
		set_next_box();
		set_previous_box();
	
	update_all_boxes();
	changing_box = false;

func update_ui(box: Node2D, box_index: int) -> void:
	for i in range(len(GLOBAL.boxes_array[box_index - 1])):
		var poke = GLOBAL.boxes_array[box_index - 1][i];
		if(poke != null):
			var sprite = Sprite2D.new();
			sprite.vframes = 2;
			sprite.centered = false;
			sprite.texture = poke.data.party_texture;
			sprite.name = poke.data.uuid;
			if(i in GLOBAL.BOXES_SLOTS):
				sprite.position = GLOBAL.BOXES_SLOTS[i];
			box.add_child(sprite);

#SELECT
func select_slot() -> void:
	if(!party_panel_opened):
		if(current_hand_pos.y >= 0):
			play_audio(GUI_SEL_CURSOR);
			if(!holding && is_pokemon_in_box()): pick_poke();
			elif(holding): drop_poke();
		else:
			match hand.position:
				Vector2(104, 2): open_party_panel();
				Vector2(192, 2): close_box();
	else:
		play_audio(GUI_SEL_CURSOR);
		if(!holding && is_pokemon_in_party()): pick_party_poke();
		elif(holding && current_hand_pos.y != int(Positions.PARTY)): drop_poke_party();
		match hand.position:
			Vector2(137, 115): close_party_panel();

#PICK
func pick_poke() -> void:
	picking = true;
	save_data_before_pick();
	anim_hand.play("Pick");
	await anim_hand.animation_finished;
	holding = true;
	picking = false;

func pick_party_poke() -> void:
	picking = true;
	save_data_before_pick_party();
	anim_hand.play("PickParty");
	await anim_hand.animation_finished;
	holding = true;
	picking = false;

#DROP
func drop_poke() -> void:
	picking = true;
	anim_hand.play("Drop");
	await anim_hand.animation_finished;
	picking = false;
	holding = false;
	anim_hand.play("Idle");
	holding_poke = null;
	holding_sprite.texture = null;
	current_node = null;

func drop_poke_party() -> void:
	picking = true;
	anim_hand.play("DropParty");
	await anim_hand.animation_finished;
	picking = false;
	holding = false;
	anim_hand.play("Idle");
	holding_poke = null;
	holding_sprite.texture = null;
	current_node = null;

#SPRITES
func add_sprite() -> void:
	holding_sprite.scale = Vector2(1, 1);
	holding_sprite.offset.y = 6;
	hand.get_node("Sprite2D").add_child(holding_sprite);
	current_node.queue_free();
	GLOBAL.boxes_array[current_box - 1][selected_index] = null;

func remove_sprite() -> void:
	hand.get_node("Sprite2D").remove_child(holding_sprite);
	holding_sprite.offset.y = 0;
	swap_pokes();
	update_all_boxes();
	
func add_sprite_party() -> void:
	holding_sprite.offset = Vector2(2.5, 12.4);
	if(current_hand_pos.y == 0):
		holding_sprite.offset.x = 3.8;
	hand.get_node("Sprite2D").add_child(holding_sprite);
	party[selected_party_index] = null;
	var slot = party_slots[int(selected_party_index)];
	slot.visible = false;

func remove_sprite_party() -> void:
	hand.get_node("Sprite2D").remove_child(holding_sprite);
	holding_sprite.offset = Vector2(-1, 0);
	swap_pokes_party();
	set_party_panel();

func swap_pokes() -> void:
	if(selected_index == current_index && selected_box != current_box):
		GLOBAL.boxes_array[selected_box - 1][selected_index] = holding_poke;
		return;
	var copy = GLOBAL.boxes_array.duplicate(true);
	copy[selected_box - 1][selected_index] = copy[current_box - 1][current_index];
	copy[current_box - 1][current_index] = holding_poke;
	GLOBAL.boxes_array = copy;

func swap_pokes_party() -> void:
	if(selected_party_index == current_party_index):
		party[selected_party_index] = holding_poke;
		return;
	var copy = party.duplicate(true);
	copy[selected_party_index] = copy[current_party_index];
	copy[current_party_index] = holding_poke;
	party = copy;

#PARTY
func open_party_panel() -> void:
	if(party_panel_opened): return;
	play_audio(GUI_SEL_CURSOR);
	party_panel_opened = true;
	party_anim_player.play("Show");
	await party_anim_player.animation_finished;
	hand.get_node("Sprite2D").flip_v = false;
	current_hand_pos = Vector2(6, 0);
	update_hand();
	if(holding): 
		holding_sprite.scale = Vector2(0.8, 0.8);
		holding_sprite.offset = Vector2(3.8, 12.4);

func close_party_panel() -> void:
	if(!party_panel_opened): return;
	play_audio(GUI_SEL_CURSOR);
	party_anim_player.play("Hide");
	await party_anim_player.animation_finished;
	party_panel_opened = false;
	current_party_index = 0;
	current_hand_pos = Vector2(0, 0);
	update_hand();
	if(holding): 
		holding_sprite.scale = Vector2(1, 1);
		holding_sprite.offset = Vector2(-1, 6);

func close_box() -> void:
	if(party_panel_opened): 
		close_party_panel();
		return;
	if(holding):
		GLOBAL.boxes_array[selected_box - 1][selected_index] = holding_poke;
		if(selected_box != current_box):
			update_all_boxes();
			drop_poke();
			return;
		current_hand_pos = selected_hand_pos;
		update_hand();
		drop_poke();
		return;
	closing = true;
	party = party.filter(func (poke): return poke != null);
	PARTY.set_party(party);
	PARTY.reset_all_active(true);
	play_audio(GUI_MENU_CLOSE);
	await audio.finished;
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokemonBoxes");

#INPUTS
func handle_DOWN() -> void:
	play_audio(GUI_SEL_CURSOR);
	current_hand_pos.y += 1;
	if(party_panel_opened):
		if(current_hand_pos.y > int(Positions.PARTY)): 
			current_hand_pos.y = 0;
		return;
	if(current_hand_pos.y > 4):
		current_hand_pos.y = int(Positions.OPTIONS);
	if(current_hand_pos.y == int(Positions.OPTIONS)): current_hand_pos.x = 0;

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	current_hand_pos.y -= 1;
	if(party_panel_opened):
		if(current_hand_pos.y < 0): 
			current_hand_pos.y = int(Positions.PARTY);
		return;
	if(current_hand_pos.y < int(Positions.OPTIONS)): current_hand_pos.y = 4;
	elif(current_hand_pos.y == int(Positions.OPTIONS)): 
		current_hand_pos.x = 0;

func handle_RIGHT() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(party_panel_opened):
		if(current_hand_pos.y == 0): 
			current_hand_pos.y = position_before_party_left;
		else: close_party_panel();
		return;
	if(current_hand_pos.y == int(Positions.BOX_SWITCH)):
		current_box += 1;
		if(current_box > boxes_length): current_box = 1;
		changing_box = true;
		box_anim_player.play("Next");
		await box_anim_player.animation_finished;
		update_box();
		return;
	current_hand_pos.x += 1;
	if(current_hand_pos.y == int(Positions.OPTIONS)):
		if(current_hand_pos.x >= 2 && !holding):
			current_hand_pos.x = 0;
		if(holding): 
			current_hand_pos.x -= 1;
			return;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x > 5):
		current_hand_pos.x = 0;

func handle_LEFT() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(party_panel_opened):
		if(current_hand_pos.y != 0):
			position_before_party_left = current_hand_pos.y;
			current_hand_pos.y = 0;
		return;
	if(current_hand_pos.y == int(Positions.BOX_SWITCH)):
		current_box -= 1;
		if(current_box < 1): current_box = boxes_length;
		changing_box = true;
		box_anim_player.play("Previous");
		await box_anim_player.animation_finished;
		update_box();
		return;
	current_hand_pos.x -= 1;
	if(current_hand_pos.y == int(Positions.OPTIONS)):
		if(current_hand_pos.x < 0 && !holding):
			current_hand_pos.x = 1;
		if(holding):
			current_hand_pos.x += 1;
			return;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x < 0):
		current_hand_pos.x = 5;

#CHECKERS
func is_pokemon_in_box() -> bool:
	if(current_hand_pos.y < 0): return false;
	if(GLOBAL.boxes_array[current_box - 1][current_index] != null):
		return true;
	return false;

func is_pokemon_in_party() -> bool:
	if(
		current_hand_pos.x != int(Positions.PARTY) || 
		current_hand_pos.y == int(Positions.PARTY)
	): return false;
	if(party[current_party_index] != null): return true;
	return false;

#SETTERS
func save_data_before_pick() -> void:
	selected_index = current_index;
	selected_box = current_box;
	selected_hand_pos = current_hand_pos;
	var copy = GLOBAL.boxes_array.duplicate();
	holding_poke = copy[current_box - 1][selected_index];
	current_node = pokemon_box.get_node(holding_poke.data.uuid);
	holding_sprite.texture = holding_poke.data.party_texture;

func save_data_before_pick_party() -> void:
	selected_party_index = current_hand_pos.y;
	var copy = party.duplicate();
	holding_poke = copy[selected_party_index];
	current_node = party_panel.get_child(selected_party_index + 1).get_node("Poke");
	holding_sprite.texture = holding_poke.data.party_texture;
	holding_sprite.scale = Vector2(0.8, 0.8);

func set_index() -> void:
	var base_y = current_hand_pos.y * 6;
	var base_x = current_hand_pos.x;
	current_index = (base_x + base_y);
	if(party_panel_opened): current_party_index = current_hand_pos.y;

func set_holding_sprite() -> void:
	holding_sprite.vframes = 2;
	holding_sprite.centered = false;
	holding_sprite.z_index = 0;
	holding_sprite.offset.x = -1;
	holding_sprite.show_behind_parent = true;

func set_current_box() -> void:
	boxes.position = Vector2.ZERO;
	box_sprite.texture = GLOBAL.boxes_background[current_box].texture;
	box_name.text = GLOBAL.boxes_background[current_box].name;

func set_next_box() -> void:
	var next_index = current_box + 1;
	next_sprite.texture = GLOBAL.boxes_background[next_index].texture;
	next_name.text = GLOBAL.boxes_background[next_index].name;

func set_previous_box() -> void:
	var previous_index = current_box - 1;
	previous_sprite.texture = GLOBAL.boxes_background[previous_index].texture;
	previous_name.text = GLOBAL.boxes_background[previous_index].name;

func set_active(poke: Node) -> void:
	active_name.text = poke.name;
	active_sprite.sprite_frames = poke.data.sprites.sprite_frames;
	active_level.text = "Lv" + str(poke.data.level);
	active_sprite.play("Front");
	active_sprite.scale = poke.data.box_scale;
	active_sprite.offset = poke.data.box_offset;
	if("gender" in poke.data):
		active_gender.frame = poke.data.gender;
		active_level.position.x = 20;
		active_gender.visible = true;
	else: 
		active_level.position.x = 6;
		active_gender.visible = false;
	inactive.visible = false;
	active.visible = true;

func set_party_panel() -> void:
	for index in range(0, party_length):
		var slot = party_slots[index];
		slot.visible = true;
		var square_node = slot.get_node("Sprite2D");
		var poke_node = slot.get_node("Poke");
		square_node.frame = 0;
		
		var poke = party[index];
		poke_node.texture = poke.data.party_texture;

func update_all_boxes() -> void:
	remove_children();
	var previous_index = current_box - 1;
	if(previous_index == 0): previous_index = boxes_length;
	var next_index = current_box + 1;
	if(next_index > boxes_length): next_index = 1;
	update_ui(previous_pokemon_box, previous_index);
	update_ui(next_pokemon_box, next_index);
	update_ui(pokemon_box, current_box);

func remove_children() -> void:
	var poke_boxes = [pokemon_box, previous_pokemon_box, next_pokemon_box];
	for box in poke_boxes:
		var childs = box.get_children();
		for child in childs: box.remove_child(child);

func remove_active() -> void:
	active.visible = false;
	inactive.visible = true;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
