extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $RichTextLabel;

var text_arr: Array = []
var current_index: int = 0
var current_line: int = 2
var pressed: bool = true
var process_md: bool = false;
var self_name: String;
var npc_name: String;
var dialog_closed = false;
var oak_prefix = "self:";
var who_talking: String;

func _ready() -> void:
	who_talking = npc_name;
	var first_line: int = 1
	label.text = "";
	
	var text_string = text_arr[0][0];
	if(text_string.left(len(oak_prefix)) == oak_prefix): 
		who_talking = self_name;
		text_string = text_string.replace(oak_prefix, "");
	label.text += "[b]" + who_talking + "[/b]: ";
	
	for i in range(first_line):
		for j in range(len(text_arr[0][i])):
			await timer.timeout;
			label.text += text_arr[0][i][j]
	pressed = false
	who_talking = npc_name;

func _input(event: InputEvent) -> void:
	if(dialog_closed): return;
	if event.is_action_pressed("space") and !pressed:
		pressed = true;
		label.text = "";
		
		if current_line >= len(text_arr[current_index]):
			label.text = ""
			current_index += 1
			current_line = 0
		
		if current_index >= len(text_arr):
			dialog_closed = true;
			GLOBAL.emit_signal("close_dialog");
			timer.stop();
		else:
			var text_string = text_arr[current_index][current_line];
			label.text = label.text.erase(0, label.text.find("\n") + 1)
			if(text_string.left(len(oak_prefix)) == oak_prefix): 
				who_talking = self_name;
				text_string = text_string.replace(oak_prefix, "");
			label.text += "[b]" + who_talking + "[/b]: ";
			for j in range(len(text_string)):
				await timer.timeout;
				label.text += text_string[j]
			current_line += 1
		pressed = false
		who_talking = npc_name;

func set_data(dialog: Array, input_name: String, input_npc: String) -> void: 
	text_arr = dialog;
	self_name = input_name;
	npc_name = input_npc;
