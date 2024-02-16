extends Node2D

#ATTACKS
@onready var attack_selection_info = $SelectionInfo;
@onready var attack_cursor = $AttackCursor;
@onready var audio: AudioStreamPlayer = $"../AudioPlayer";

@onready var attack_01 = $Attack01;
@onready var attack_02 = $Attack02;
@onready var attack_03 = $Attack03;
@onready var attack_04 = $Attack04;
@onready var player_attacks = [attack_01, attack_02, attack_03, attack_04];

var selected_attack = BATTLE.Moves.FIRST;
var cursor_index = Vector2.ZERO;
var player_moves = [];
var enemy_moves = [];

func _ready() -> void:
	BATTLE.connect("update_attack_ui", update_attack_ui);

func get_player_selected_attack() -> Dictionary:
	return player_moves[selected_attack];

func get_enemy_random_attack() -> Dictionary:
	var randomIndex = randi() % enemy_moves.size();
	return enemy_moves[randomIndex];

func set_pokemon_moves(moves: Array) -> void:
	reset();
	player_moves = moves;
	for i in range(len(player_moves)):
		var move = player_moves[i];
		player_attacks[i].visible = true;
		player_attacks[i].text = move.name.to_upper();

func set_enemy_moves(moves: Array) -> void:
	for move in moves:
		enemy_moves.push_back(MOVES.get_move(move));

#ATTACKS
func input() -> void:
	BATTLE.attack_pressed = false;
	var pre_position = cursor_index;
	if Input.is_action_just_pressed("moveLeft") and cursor_index.x > 0:
		cursor_index.x -= 1;
	elif Input.is_action_just_pressed("moveRight") and cursor_index.x < 1:
		cursor_index.x += 1;
	elif Input.is_action_just_pressed("moveUp") and cursor_index.y > 0:
		cursor_index.y -= 1;
	elif Input.is_action_just_pressed("moveDown") and cursor_index.y < 1:
		cursor_index.y += 1;
	elif Input.is_action_just_pressed("backMenu"):
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
		visible = false;
		BATTLE.state = BATTLE.States.MENU;
	elif Input.is_action_just_pressed("space") and !BATTLE.attack_pressed: 
		BATTLE.start_attack.emit();
		visible = false;
		return;
		
	var new_position = BATTLE.ATTACK_CURSOR[cursor_index.y][cursor_index.x];
	if(!BATTLE.can_move_attack_cursor(new_position, player_attacks)):
		cursor_index = pre_position;
		return;
	attack_cursor.position = new_position;
	if (pre_position != cursor_index): 
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
		set_attack_slot();
	BATTLE.update_attack_ui.emit();

func set_attack_slot() -> void:
	if(cursor_index == Vector2.ZERO): selected_attack = BATTLE.Moves.FIRST;
	elif(cursor_index == Vector2.RIGHT): selected_attack = BATTLE.Moves.SECOND;
	elif(cursor_index == Vector2.DOWN): selected_attack = BATTLE.Moves.THIRD;
	elif(cursor_index == Vector2(1, 1)): selected_attack = BATTLE.Moves.FOURTH;

func update_attack_ui() -> void:
	var current_attack = player_moves[selected_attack];
	var type_node = attack_selection_info.get_node("Type");
	var pp_node = attack_selection_info.get_node("PP/Value");
	type_node.text = MOVES.TYPES[int(current_attack.type + 1)];
	pp_node.text = str(current_attack.pp) + "/" + str(current_attack.total_pp);

func reset() -> void:
	for attack in player_attacks: attack.text = "";
	selected_attack = BATTLE.Moves.FIRST;
	cursor_index = Vector2.ZERO;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
