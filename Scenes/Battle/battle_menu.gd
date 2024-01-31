extends Node2D

@onready var cursor = $MenuCursor;
@onready var label = $Label;
@onready var background = $Background;
@onready var attack_selection: Node2D = $"../Selection";
@onready var audio: AudioStreamPlayer = $"../AudioStreamPlayer";

var cursor_index = Vector2.ZERO;

func _ready() -> void:
	set_marker();

#MENU STATE
func input(event: InputEvent) -> void:
	#ARROW
	if(!BATTLE.can_use_menu): return;
	if event.is_action_pressed("moveLeft") && cursor_index.x > 0:
		cursor_index.x -= 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif event.is_action_pressed("moveRight") && cursor_index.x < 1:
		cursor_index.x += 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif event.is_action_pressed("moveDown") && cursor_index.y < 1:
		cursor_index.y += 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	elif event.is_action_pressed("moveUp") && cursor_index.y > 0:
		cursor_index.y -= 1;
		play_audio(BATTLE.BATTLE_SOUNDS.GUI_SEL_DECISION);
	
	cursor.position = BATTLE.menu_cursor_pos[cursor_index.y][cursor_index.x];
	
	#SELECTION
	if event.is_action_pressed("space"):
		play_audio(BATTLE.BATTLE_SOUNDS.CONFIRM);
		match_input();

func match_input() -> void:
	if cursor_index == Vector2.ZERO:
		attack_selection.visible = true;
		BATTLE.state = BATTLE.States.FIGHT;
		BATTLE.update_attack_ui.emit();
	elif cursor_index == Vector2.RIGHT: pass
		#bag.visible = true;
		#current_state = States.BAG;
	elif cursor_index == Vector2.DOWN: pass
		#pokemon.visible = true
		#current_state = States.PARTY;
	elif cursor_index == Vector2(1, 1): BATTLE.end_battle.emit();

func set_label(text: String) -> void: label.text = text;

#MARKERS
func set_marker() -> void:
	var markers = BATTLE.get_markers(SETTINGS.selected_type);
	background.texture = markers.menu;

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
