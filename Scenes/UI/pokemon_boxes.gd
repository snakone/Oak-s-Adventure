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
@onready var remote_transform: RemoteTransform2D = $Node2D/Hand/Sprite2D/RemoteTransform2D;
@onready var previous_pokemon_box: Node2D = $Node2D/Boxes/Previous/Pokemon;
@onready var next_pokemon_box: Node2D = $Node2D/Boxes/Next/Pokemon

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");
const GUI_MENU_CLOSE = preload("res://Assets/Sounds/GUI menu close.ogg");

var current_hand_pos = Vector2.ZERO;
var boxes_length: int;
var changing_box = false;
var picking = false;
var holding = false;

var selected_index = 0;
var current_index = 0;
var selected_box = 1;
var current_box = 1;

var current_poke_node: Node2D;

var boxes_array = [
	[
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
	],
	[
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
	],
	[
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
	],
	[
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
		null, null, null, null, null, null,
	]
];

func _ready() -> void:
	boxes_length = GLOBAL.boxes_background.keys().size();
	update_hand();
	update_box();
	remote_transform.update_position = false;
	var new_enemy = POKEDEX.get_pokemon(2);
	var enemy = Pokemon.new(new_enemy, true);
	var new_enemy2 = POKEDEX.get_pokemon(4);
	var enemy2 = Pokemon.new(new_enemy2, true);
	boxes_array[0][1] = enemy;
	boxes_array[0][5] = enemy2;
	update_ui(pokemon_box, current_box);

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		!GLOBAL.on_boxes ||
		changing_box ||
		picking
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
	#BOX
	if(current_hand_pos.y == -1):
		if(box_anim_player.is_playing()):
			await box_anim_player.animation_finished;
		box_anim_player.play("BoxSelected");
	else: box_anim_player.stop();
	#SHADOW
	if(current_hand_pos.y < 0): hand.get_node("Shadow").visible = false;
	else: hand.get_node("Shadow").visible = true;
	#FLIP
	if(current_hand_pos.y == -2): hand.get_node("Sprite2D").flip_v = true;
	else: hand.get_node("Sprite2D").flip_v = false;
	#CLOSE
	if(current_hand_pos == Vector2(1, -2)): close.frame = 0;
	else: close.frame = 1;

func handle_DOWN() -> void:
	play_audio(GUI_SEL_CURSOR);
	current_hand_pos.y += 1;
	if(current_hand_pos.y > 4): current_hand_pos.y = -2;
	if(current_hand_pos.y == -2): current_hand_pos.x = 0;

func handle_UP() -> void:
	play_audio(GUI_SEL_CURSOR);
	current_hand_pos.y -= 1;
	if(current_hand_pos.y < -2): current_hand_pos.y = 4;
	if(current_hand_pos.y == -2): current_hand_pos.x = 0;

func handle_RIGHT() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(current_hand_pos.y == -1):
		current_box += 1;
		if(current_box > boxes_length): current_box = 1;
		changing_box = true;
		box_anim_player.play("Next");
		await box_anim_player.animation_finished;
		update_box();
		return;
	current_hand_pos.x += 1;
	if(current_hand_pos.y == -2 && current_hand_pos.x >= 2):
		current_hand_pos.x = 0;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x > 5):
		current_hand_pos.x = 0;

func handle_LEFT() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(current_hand_pos.y == -1):
		current_box -= 1;
		if(current_box < 1): current_box = boxes_length;
		changing_box = true;
		box_anim_player.play("Previous");
		await box_anim_player.animation_finished;
		update_box();
		return;
	current_hand_pos.x -= 1;
	if(current_hand_pos.y == -2 && current_hand_pos.x < 0):
		current_hand_pos.x = 1;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x < 0):
		current_hand_pos.x = 5;

func update_box() -> void:
	remove_children();
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
	print("-----------------------------")
	changing_box = false;

func update_ui(box: Node2D, index: int) -> void:
	print(box.get_parent().name, " ", index)
	for i in range(len(boxes_array[index - 1])):
		var poke = boxes_array[index - 1][i];
		if(poke != null):
			var sprite_2d = Sprite2D.new();
			sprite_2d.vframes = 2;
			sprite_2d.centered = false;
			sprite_2d.texture = poke.data.party_texture;
			if(i in GLOBAL.BOXES_SLOTS):
				sprite_2d.position = GLOBAL.BOXES_SLOTS[i];
			box.add_child(sprite_2d);

func update_all_boxes() -> void:
	var previous_index = current_box - 1;
	if(previous_index == 0): previous_index = boxes_length;
	update_ui(previous_pokemon_box, previous_index);
	
	var next_index = current_box + 1;
	if(next_index > boxes_length): next_index = 1;
	update_ui(next_pokemon_box, next_index);
	
	update_ui(pokemon_box, current_box);

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

func remove_children() -> void:
	var childs = pokemon_box.get_children();
	for child in childs:
		pokemon_box.remove_child(child);
	
	var previous = previous_pokemon_box.get_children();
	for prev in previous:
		previous_pokemon_box.remove_child(prev);
	
	var next = next_pokemon_box.get_children();
	for ne in next:
		next_pokemon_box.remove_child(ne);

func select_slot() -> void:
	match hand.position:
		Vector2(192, 2): close_box();
	
	set_index();
	if(current_hand_pos.y >= 0):
		if(!holding && get_pokemon_node()):
			picking = true;
			anim_hand.play("Pick");
			await anim_hand.animation_finished;
			picking = false;
			holding = true;
			selected_index = current_index;
			selected_box = current_box;
		elif(holding):
			picking = true;
			anim_hand.play("Drop");
			await anim_hand.animation_finished;
			picking = false;
			holding = false;
			swap_pokes();
			remove_children();
			update_all_boxes();

func swap_pokes() -> void:
	var copy = boxes_array.duplicate(true);
	var temp = copy[selected_box - 1][selected_index];
	copy[selected_box - 1][selected_index] = copy[current_box - 1][current_index];
	copy[current_box - 1][current_index] = temp;
	boxes_array = copy;

func close_box() -> void:
	play_audio(GUI_MENU_CLOSE);
	await audio.finished;
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokemonBoxes");

func get_pokemon_node() -> bool:
	if(current_hand_pos.y < 0): return false;
	if(boxes_array[current_box - 1][current_index] != null):
		return true;
	return false;

func set_index() -> void:
	var base_y = current_hand_pos.y * 6;
	var base_x = current_hand_pos.x;
	current_index = (base_x + base_y);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
