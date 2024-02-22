extends CanvasLayer

func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if(
		!event is InputEventKey ||
		GLOBAL.on_transition || 
		!event.is_pressed() ||
		event.is_echo() ||
		GLOBAL.on_battle ||
		!GLOBAL.on_boxes
	): return;
	
	if(
		Input.is_action_just_pressed("menu") || 
		Input.is_action_just_pressed("backMenu")): close_box();
		
func close_box() -> void:
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/PokemonBoxes");
