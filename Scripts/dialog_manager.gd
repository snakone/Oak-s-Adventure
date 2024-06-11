extends CanvasLayer

@onready var timer = $Timer;
@onready var label = $RichTextLabel;
@onready var marker = $Marker;
@onready var audio = $AudioStreamPlayer;
@onready var selection: NinePatchRect = $Selection;

const CONFIRM = preload("res://Assets/Sounds/confirm.wav");
const CLOSE_MENU = preload("res://Assets/Sounds/close menu.mp3");

const oak_prefix = "self:";
var dialog_data: Dictionary;
var current_index: int = 0;
var current_line: int = 2;
var pressed: bool = true;
var dialog_closed = false;
var npc_dialog = false;
var whos_talking: String;
var must_select = false;

func set_data(id: int) -> void: dialog_data = DIALOG.get_dialog(id);

func _ready() -> void:
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
	marker.visible = false;
	label.text = "";
	var text_string = dialog_data.arr[0][0];
	
	#SET NPC NAME
	if(dialog_data.type ==  DIALOG.Type.NPC):
		npc_dialog = true;
		if("npc_name" in dialog_data): whos_talking = dialog_data.npc_name;
		elif(oak_prefix in text_string): whos_talking = "Oak";
		text_string = add_prefix(text_string);
	
	for i in range(1):
		for j in range(len(text_string)):
			await timer.timeout;
			label.text += text_string[j];
	
	await GLOBAL.timeout(0.2);
	pressed = false;
	marker.visible = dialog_data.marker;
	if("selection" in dialog_data && !dialog_data.marker):
		show_selection();

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey || 
		event.is_echo() ||
		!event.is_pressed() ||
		dialog_closed ||
		GLOBAL.menu_open ||
		!dialog_data.marker ||
		must_select
	): return;
	
	if Input.is_action_just_pressed("space") and !pressed:
		marker.visible = false;
		pressed = true;
		label.text = "";
		play_audio(CONFIRM);
		
		#CONTINUE
		if current_line >= len(dialog_data.arr[current_index]):
			label.text = ""
			current_index += 1
			current_line = 0
		
		#END
		if current_index >= len(dialog_data.arr):
			timer.stop();
			dialog_closed = true;
			await audio.finished;
			if(dialog_data.marker): GLOBAL.emit_signal("close_dialog");
		#WRITE
		else:
			label.text = label.text.erase(0, label.text.find("\n") + 1);
			var text_string = dialog_data.arr[current_index][current_line];
			if(oak_prefix in text_string): whos_talking = "Oak";
			if(npc_dialog):
				text_string = add_prefix(text_string);
				if("npc_name" in dialog_data): whos_talking = dialog_data.npc_name;
				
			for j in range(len(text_string)):
				await timer.timeout;
				label.text += text_string[j];
				
			#SELECTION
			if(dialog_data.arr.size() - 1 == current_index && "selection" in dialog_data):
				show_selection();
				return;
			marker.visible = dialog_data.marker;
			current_line += 1;
		await GLOBAL.timeout(0.2);
		pressed = false;

func show_selection() -> void:
	must_select = true;
	marker.visible = false;
	await GLOBAL.timeout(0.1);
	selection.set_visibility(true, dialog_data.selection.category);
	
func add_prefix(text: String) -> String:
	if(whos_talking != ""):
		if(text.left(len(oak_prefix)) == oak_prefix): 
			whos_talking = "Oak";
			text = text.replace(oak_prefix, "");
		label.text += "[b]" + whos_talking + "[/b]: ";
	
	return text;

#SELECTION
func _on_selection_value_select(value: int, _id) -> void:
	match value:
		int(GLOBAL.BinaryOptions.YES): 
			close_selection(dialog_data.selection.sound);
		int(GLOBAL.BinaryOptions.NO): 
			close_selection();

func close_selection(stream: AudioStream = CLOSE_MENU) -> void:
	if(stream != null):
		play_audio(stream);
		await audio.finished;
	GLOBAL.emit_signal("close_dialog");

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
