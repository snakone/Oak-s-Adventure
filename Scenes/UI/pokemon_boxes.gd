extends CanvasLayer

@onready var hand: Control = $Node2D/Hand;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var box1_anim_player: AnimationPlayer = $Node2D/Boxes/Box/AnimationPlayer

const GUI_SEL_CURSOR = preload("res://Assets/Sounds/GUI sel cursor.ogg");

var current_hand_pos = Vector2.ZERO;

var boxes = [
	[],
	[],
	[]
];

var hand_pos_map = {
	#SELECTION ROW
	Vector2(0, -2): Vector2(104, 2),
	Vector2(1, -2): Vector2(192, 2),
	#BOX ROW
	Vector2(0, -1): Vector2(145, -4),
	Vector2(1, -1): Vector2(145, -4),
	Vector2(2, -1): Vector2(145, -4),
	Vector2(3, -1): Vector2(145, -4),
	Vector2(4, -1): Vector2(145, -4),
	Vector2(5, -1): Vector2(145, -4),
	#FIRST ROW
	Vector2.ZERO: Vector2(84, 20),
	Vector2(1, 0): Vector2(108, 20),
	Vector2(2, 0): Vector2(132, 20),
	Vector2(3, 0): Vector2(156, 20),
	Vector2(4, 0): Vector2(180, 20),
	Vector2(5, 0): Vector2(204, 20),
	#SECOND ROW
	Vector2(0, 1): Vector2(84, 42),
	Vector2(1, 1): Vector2(108, 42),
	Vector2(2, 1): Vector2(132, 42),
	Vector2(3, 1): Vector2(156, 42),
	Vector2(4, 1): Vector2(180, 42),
	Vector2(5, 1): Vector2(204, 42),
	#THIRD ROW
	Vector2(0, 2): Vector2(84, 64),
	Vector2(1, 2): Vector2(108, 64),
	Vector2(2, 2): Vector2(132, 64),
	Vector2(3, 2): Vector2(156, 64),
	Vector2(4, 2): Vector2(180, 64),
	Vector2(5, 2): Vector2(204, 64),
	#FOURTH ROW
	Vector2(0, 3): Vector2(84, 86),
	Vector2(1, 3): Vector2(108, 86),
	Vector2(2, 3): Vector2(132, 86),
	Vector2(3, 3): Vector2(156, 86),
	Vector2(4, 3): Vector2(180, 86),
	Vector2(5, 3): Vector2(204, 86),
	#FIFTH ROW
	Vector2(0, 4): Vector2(84, 108),
	Vector2(1, 4): Vector2(108, 108),
	Vector2(2, 4): Vector2(132, 108),
	Vector2(3, 4): Vector2(156, 108),
	Vector2(4, 4): Vector2(180, 108),
	Vector2(5, 4): Vector2(204, 108),
}

func _ready() -> void:
	update_hand();

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		!GLOBAL.on_boxes
	): return;
	
	if(
		Input.is_action_just_pressed("menu") || 
		Input.is_action_just_pressed("backMenu")): close_box();
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
	print(current_hand_pos);
	hand.position = hand_pos_map[current_hand_pos];
	if(current_hand_pos.y == -1): box1_anim_player.play("BoxSelected");
	else: box1_anim_player.stop();
	if(current_hand_pos.y < 0): hand.get_node("Shadow").visible = false;
	else: hand.get_node("Shadow").visible = true;
	if(current_hand_pos.y == -2): hand.get_node("Sprite2D").flip_v = true;
	else: hand.get_node("Sprite2D").flip_v = false;

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
	if(current_hand_pos.y == -1): return;
	current_hand_pos.x += 1;
	if(current_hand_pos.y == -2 && current_hand_pos.x >= 2):
		current_hand_pos.x = 0;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x > 5):
		current_hand_pos.x = 0;

func handle_LEFT() -> void:
	play_audio(GUI_SEL_CURSOR);
	if(current_hand_pos.y == -1): return;
	current_hand_pos.x -= 1;
	if(current_hand_pos.y == -2 && current_hand_pos.x < 0):
		current_hand_pos.x = 1;
	elif(current_hand_pos.y >= 0 && current_hand_pos.x < 0):
		current_hand_pos.x = 5;

func select_slot() -> void:
	pass

func close_box() -> void:
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokemonBoxes");

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
