extends CanvasLayer

@onready var timer = $Timer;
@onready var label = $RichTextLabel;
@onready var marker = $Marker;
@onready var audio = $AudioStreamPlayer;
@onready var menu_selection: NinePatchRect = $Selection;

signal line_ended();

const oak_prefix = "self:";
var dialog_data: Dictionary;
var current_index: int = 0;
var current_line: int = 1;
var pressed: bool = true;
var dialog_closed = false;
var npc_dialog = false;
var whos_talking: String;
var must_select = false;
var text_size: int = 0;
var end_line = false;

func set_data(id: int) -> void: dialog_data = DIALOG.get_dialog(id);

func create(id: int, array: Array) -> void:
	var data = DIALOG.get_dialog(id);
	dialog_data = {
		"type": data.type,
		"marker": data.marker,
		"arr": array
	}

func _ready() -> void:
	GLOBAL.connect("selection_value_select", _on_selection_value_select);
	marker.visible = false;
	label.text = "";
	var text_string = dialog_data.arr[0][0];
	
	match dialog_data.type:
		DIALOG.Type.NPC: handle_NPC(text_string);
		DIALOG.Type.OBJECT: handle_object(text_string);
	
	text_string = add_prefix(text_string);
	label.text = text_string;
	await write();
	await GLOBAL.timeout(0.2);
	pressed = false;
	marker.visible = dialog_data.marker;
	if("selection" in dialog_data && !dialog_data.marker):
		show_selection();

func write() -> void:
	end_line = false;
	label.visible_characters = 0;
	text_size = get_filtered_length(label.text);
	await line_ended;

func handle_NPC(text_string: String) -> void:
	if(dialog_data.type ==  DIALOG.Type.NPC):
		npc_dialog = true;
		if("npc_name" in dialog_data): whos_talking = dialog_data.npc_name;
		elif(oak_prefix in text_string): whos_talking = "Oak";

func handle_object(text_string: String) -> void:
	if(oak_prefix in text_string): whos_talking = "Oak";

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
		end_line = false;
		handle_accept();
		if current_line >= len(dialog_data.arr[current_index]): 
			handle_continue();
		if current_index >= len(dialog_data.arr): 
			await handle_end();
		else:
			label.text = add_prefix(handle_write());
			await write();
			#SELECTION
			if(dialog_data.arr.size() - 1 == current_index && 
				"selection" in dialog_data):
				show_selection();
				return;
			marker.visible = dialog_data.marker;
			current_line += 1;
		await GLOBAL.timeout(0.2);
		pressed = false;

func handle_accept() -> void:
	marker.visible = false;
	whos_talking = "";
	pressed = true;
	label.text = "";
	play_audio(LIBRARIES.SOUNDS.CONFIRM);

func handle_continue() -> void:
	label.text = "";
	current_index += 1;
	current_line = 0;

func handle_write() -> String:
	var text_string = dialog_data.arr[current_index][current_line];
	#SELF DIALOG
	if(oak_prefix in text_string): whos_talking = "Oak";
	#NPC DIALOG
	if(npc_dialog && "npc_name" in dialog_data): 
		whos_talking = dialog_data.npc_name;
	return text_string;

func handle_end() -> void:
	timer.stop();
	dialog_closed = true;
	await audio.finished;
	if(dialog_data.marker): GLOBAL.emit_signal("close_dialog");

#SHOW
func show_selection() -> void:
	must_select = true;
	marker.visible = false;
	await GLOBAL.timeout(0.1);
	menu_selection.set_visibility(true, dialog_data.selection);

func add_prefix(text: String) -> String:
	if(whos_talking != ""):
		if(text.left(len(oak_prefix)) == oak_prefix): 
			whos_talking = "Oak";
			text = text.replace(oak_prefix, "");
		return "[b]" + whos_talking + "[/b]: " + text;
	return text;

#SELECTION
func _on_selection_value_select(value: int, _id) -> void:
	match_selection_and_close(value);

func match_selection_and_close(value: int) -> void:
	var sound = dialog_data.selection.sound;
	match value:
		int(ENUMS.BinaryOptions.YES): close_selection(value, sound);
		int(ENUMS.BinaryOptions.NO): close_selection(value);

#CLOSE
func close_selection(
	value: int, 
	stream: AudioStream = LIBRARIES.SOUNDS.GUI_MENU_CLOSE
) -> void:
	play_audio(stream);
	await audio.finished;
	GLOBAL.emit_signal("close_dialog");
	check_for_responses(value);

#RESPONSES
func check_for_responses(value: int) -> void:
	if("response" in dialog_data && "selection" in dialog_data):
		var selection_id = dialog_data["selection"].id;
		var current_response = dialog_data["response"][selection_id];
		var dialog_id: int = current_response[value].dialog_id;
		GLOBAL.start_dialog.emit(dialog_id);

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func _on_timer_timeout() -> void:
	if(label.visible_characters >= text_size && !end_line):
		end_line = true;
		emit_signal("line_ended");
		return;
	label.visible_characters += 1;

func get_filtered_length(original: String) -> int:
	var filtered_string = original.replace("[b]", "").replace("[/b]", "")
	return filtered_string.length()
