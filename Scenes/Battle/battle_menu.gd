extends Node2D

@onready var cursor = $MenuCursor;
@onready var label = $Label;
@onready var background = $Background;
@onready var attack_selection: Node2D = $"../Selection";
@onready var audio: AudioStreamPlayer = $"../AudioPlayer";
@onready var dialog_label: RichTextLabel = $"../Dialog/Label";

const party_screen_path = "res://Scenes/UI/party_screen.tscn";
var cursor_index = Vector2.ZERO;
var scene_manager: Node2D;

func _ready() -> void:
	set_marker();
	connect_signals();
	scene_manager = get_node("/root/SceneManager");

#MENU STATE
func input() -> void:
	#ARROW
	if(!BATTLE.can_use_menu || GLOBAL.party_open): return;
	if Input.is_action_just_pressed("moveLeft") && cursor_index.x > 0:
		cursor_index.x -= 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveRight") && cursor_index.x < 1:
		cursor_index.x += 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveDown") && cursor_index.y < 1:
		cursor_index.y += 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveUp") && cursor_index.y > 0:
		cursor_index.y -= 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	
	cursor.position = BATTLE.menu_cursor_pos[cursor_index.y][cursor_index.x];
	
	#SELECTION
	if Input.is_action_just_pressed("space"):
		play_audio(BATTLE.BATTLE_SOUNDS.CONFIRM);
		match_input();

func match_input() -> void:
	if(cursor_index == Vector2.ZERO):
		attack_selection.visible = true;
		BATTLE.state = BATTLE.States.FIGHT;
		BATTLE.update_attack_ui.emit();
	elif (cursor_index == Vector2.RIGHT): pass
		#bag.visible = true;
		#current_state = States.BAG;
	elif(cursor_index == Vector2.DOWN): open_party();
	elif(cursor_index == Vector2(1, 1)):
		BATTLE.state = BATTLE.States.NONE;
		BATTLE.check_can_escape.emit();

func set_label(text: String) -> void: label.text = text;

#MARKERS
func set_marker() -> void:
	var markers = BATTLE.get_markers(SETTINGS.selected_type);
	background.texture = markers.menu;

func open_party() -> void:
	BATTLE.state = BATTLE.States.NONE;
	GLOBAL.party_open = true;
	scene_manager.transition_to_scene(party_screen_path, true, false)

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func _on_pokemon_select_party(_name) -> void:
	dialog_label.text = "";
	cursor_index = Vector2.ZERO;
	cursor.position = BATTLE.menu_cursor_pos[0][0];

func connect_signals() -> void:
	PARTY.connect("selected_pokemon_party", _on_pokemon_select_party);
