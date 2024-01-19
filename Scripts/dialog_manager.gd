extends CanvasLayer

@onready var timer = $Timer
@onready var label = $RichTextLabel;
@onready var marker = $Marker;
@onready var audio = $AudioStreamPlayer;

var dialog_data: Dictionary;
var current_index: int = 0;
var current_line: int = 2;
var pressed: bool = true;
var dialog_closed = false;
var oak_prefix = "self:";
var npc_dialog = false;
var whos_talking: String;

func set_data(id: int) -> void: 
	dialog_data = DIALOG.get_dialog(id);

func _ready() -> void:
	marker.visible = false;
	label.text = "";
	var text_string = dialog_data.arr[0][0];
	if(dialog_data.type == DIALOG.DialogType.NPC):
		npc_dialog = true;
		whos_talking = dialog_data.npc_name;
		text_string = add_prefix(text_string);

	for i in range(1):
		for j in range(len(text_string)):
			await timer.timeout;
			label.text += text_string[j];
			
	pressed = false;
	marker.visible = dialog_data.type != DIALOG.DialogType.SYSTEM;
	if(dialog_data.type == DIALOG.DialogType.SYSTEM):
		GLOBAL.emit_signal("system_dialog_finished");

func _input(event: InputEvent) -> void:
	if(dialog_closed || dialog_data.type == DIALOG.DialogType.SYSTEM): return;
	if event.is_action_pressed("space") and !pressed:
		marker.visible = false;
		pressed = true;
		label.text = "";
		audio.play();
		
		if current_line >= len(dialog_data.arr[current_index]):
			label.text = ""
			current_index += 1
			current_line = 0
		
		if current_index >= len(dialog_data.arr):
			await audio.finished;
			dialog_closed = true;
			if(dialog_data.type != DIALOG.DialogType.SYSTEM): 
				GLOBAL.emit_signal("close_dialog");
			timer.stop();
		else:
			label.text = label.text.erase(0, label.text.find("\n") + 1);
			var text_string = dialog_data.arr[current_index][current_line];
			if(npc_dialog):
				text_string = add_prefix(text_string);
				whos_talking = dialog_data.npc_name;
				
			for j in range(len(text_string)):
				await timer.timeout;
				label.text += text_string[j];
			current_line += 1;
			marker.visible = dialog_data.type != DIALOG.DialogType.SYSTEM;
		pressed = false;

func add_prefix(text: String) -> String:
	if(whos_talking != "" && npc_dialog):
		if(text.left(len(oak_prefix)) == oak_prefix): 
			whos_talking = "Oak";
			text = text.replace(oak_prefix, "");
		label.text += "[b]" + whos_talking + "[/b]: ";
	return text;
