extends Node2D

@onready var cursor = $MenuCursor;
@onready var label = $Label;
@onready var background = $Background;
@onready var attack_selection: Node2D = $"../Attacks";
@onready var audio: AudioStreamPlayer = $"../BattlePlayer";
@onready var dialog_label: RichTextLabel = $"../Dialog/Label";
@onready var dialog: Node2D = $"../Dialog";

const party_screen_path = "res://Scenes/UI/party_screen.tscn";
const bag_screen_path = "res://Scenes/UI/BAG/bag_screen.tscn";

var cursor_index = Vector2.ZERO;
var scene_manager: Node2D;

func _ready() -> void:
	set_marker();
	connect_signals();
	scene_manager = get_node("/root/SceneManager");

#MENU STATE
func input() -> void:
	if(!BATTLE.can_use_menu || GLOBAL.on_overlay): return;
	if Input.is_action_just_pressed("moveLeft") && cursor_index.x > 0:
		cursor_index.x -= 1;
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveRight") && cursor_index.x < 1:
		cursor_index.x += 1;
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveDown") && cursor_index.y < 1:
		cursor_index.y += 1;
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	elif Input.is_action_just_pressed("moveUp") && cursor_index.y > 0:
		cursor_index.y -= 1;
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_DECISION);
	
	cursor.position = BATTLE.MENU_CURSOR[cursor_index.y][cursor_index.x];
	
	#SELECTION
	if Input.is_action_just_pressed("space"):
		play_audio(LIBRARIES.SOUNDS.CONFIRM);
		match_input();

func match_input() -> void:
	#ATTACK
	if(cursor_index == Vector2.ZERO):
		attack_selection.visible = true;
		BATTLE.state = ENUMS.BattleStates.FIGHT;
		BATTLE.update_attack_ui.emit();
	#BAG
	elif (cursor_index == Vector2.RIGHT): open_bag();
	#PARTY
	elif(cursor_index == Vector2.DOWN): open_party();
	#ESCAPE
	elif(cursor_index == Vector2(1, 1)): check_if_can_run();

func check_if_can_run() -> void:
	if(BATTLE.type == ENUMS.BattleType.TRAINER):
		dialog.quick(["Can\'t escape from a Trainer Battle!"], 1.5);
		await BATTLE.quick_dialog_end;
		dialog.close(0);
		BATTLE.state = ENUMS.BattleStates.MENU;
		return;
	BATTLE.state = ENUMS.BattleStates.NONE;
	BATTLE.check_can_escape.emit();

#MARKERS
func set_marker() -> void:
	var markers = LIBRARIES.BATTLE.get_markers(SETTINGS.selected_type);
	background.texture = markers.menu;

func open_party() -> void:
	BATTLE.state = ENUMS.BattleStates.NONE;
	GLOBAL.on_overlay = true;
	GLOBAL.go_to_scene(party_screen_path, true, false);

func open_bag() -> void:
	BATTLE.state = ENUMS.BattleStates.NONE;
	GLOBAL.on_overlay = true;
	GLOBAL.go_to_scene(bag_screen_path, true, false);

func _on_pokemon_select_party(_name) -> void:
	dialog_label.text = "";
	cursor_index = Vector2.ZERO;
	cursor.position = BATTLE.MENU_CURSOR[0][0];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func connect_signals() -> void:
	PARTY.connect("selected_pokemon_party", _on_pokemon_select_party);
