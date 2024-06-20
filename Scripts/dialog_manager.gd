extends CanvasLayer

@onready var timer = $Timer;
@onready var label = $RichTextLabel;
@onready var marker = $Marker;
@onready var audio = $AudioStreamPlayer;
@onready var menu_selection: NinePatchRect = $Selection;

const oak_prefix = "self:";
var dialog_data: Dictionary;
var current_index: int = 0;
var current_line: int = 1;
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
	
	match dialog_data.type:
		DIALOG.Type.NPC: handle_NPC(text_string);
		DIALOG.Type.OBJECT: handle_object(text_string)
	
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
		handle_accept();
		if current_line >= len(dialog_data.arr[current_index]): 
			handle_continue();
		if current_index >= len(dialog_data.arr): 
			await handle_end();
		else: 
			var text = add_prefix(handle_write());
			for j in range(len(text)):
				await timer.timeout;
				label.text += text[j];
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
	label.text = label.text.erase(0, label.text.find("\n") + 1);
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
		label.text += "[b]" + whos_talking + "[/b]: ";
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
