extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $RichTextLabel;
@onready var marker = $Marker;

var text_arr: Array = [];
var current_index: int = 0;
var current_line: int = 2;
var pressed: bool = true;
var self_name: String;
var npc_name: String;
var dialog_closed = false;
var oak_prefix = "self:";
var whos_talking: String;
var dialog_count = 0;

func _ready() -> void:
	marker.visible = false;
	whos_talking = npc_name;
	var first_line: int = 1;
	label.text = "";
	var text_string = add_prefix(text_arr[0][0]);
	
	for i in range(first_line):
		for j in range(len(text_string)):
			await timer.timeout;
			label.text += text_string[j];
	pressed = false;
	whos_talking = npc_name;
	marker.visible = true;

func _input(event: InputEvent) -> void:
	marker.visible = false;
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
			label.text = label.text.erase(0, label.text.find("\n") + 1)
			var text_string = add_prefix(text_arr[current_index][current_line]);
			for j in range(len(text_string)):
				await timer.timeout;
				label.text += text_string[j];
			current_line += 1;
			marker.visible = true;
		pressed = false;
		whos_talking = npc_name;

func set_data(dialog: Array, input_name: String, input_npc: String) -> void: 
	text_arr = dialog;
	self_name = input_name;
	npc_name = input_npc;

func add_prefix(text: String) -> String:
	if(whos_talking != ""):
		if(text.left(len(oak_prefix)) == oak_prefix): 
			whos_talking = self_name;
			text = text.replace(oak_prefix, "");
		label.text += "[b]" + whos_talking + "[/b]: ";
	return text;
