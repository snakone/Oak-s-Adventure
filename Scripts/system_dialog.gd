extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $DialogLabel;
@onready var marker = $Marker;
@onready var audio = $AudioStreamPlayer
@onready var nine_patch_rect = $DialogBox;

var text_arr: Array = [];
var current_index: int = 0;
var current_line: int = 2;
var pressed: bool = true;
var dialog_closed = false;
var dialog_options = false;

func _ready() -> void:
	if(SETTINGS.selected_marker):
		nine_patch_rect.texture = SETTINGS.selected_marker;
	marker.visible = false;
	var first_line: int = 1;
	label.text = "";
	var text_string = text_arr[0][0];
	
	for i in range(first_line):
		for j in range(len(text_string)):
			await timer.timeout;
			label.text += text_string[j];
	pressed = false;
	marker.visible = !dialog_options;

func _input(event: InputEvent) -> void:
	if(dialog_closed): return;
	if event.is_action_pressed("space") and !pressed:
		marker.visible = false;
		pressed = true;
		label.text = "";
		audio.play();
		
		if current_line >= len(text_arr[current_index]):
			label.text = ""
			current_index += 1
			current_line = 0
		
		if current_index >= len(text_arr):
			await audio.finished;
			dialog_closed = true;
			GLOBAL.emit_signal("close_system_dialog");
			timer.stop();
		else:
			label.text = label.text.erase(0, label.text.find("\n") + 1)
			var text_string = text_arr[current_index][current_line];
			for j in range(len(text_string)):
				await timer.timeout;
				label.text += text_string[j];
			current_line += 1;
			marker.visible = !dialog_options;
		pressed = false;

func set_data(dialog: Array, options: bool) -> void: 
	text_arr = dialog;
	dialog_options = options;
