extends Node2D

@onready var anim_player = $AnimationPlayer;
@onready var label: RichTextLabel = $CanvasLayer/Panel/RichTextLabel;
@onready var panel: NinePatchRect = $CanvasLayer/Panel;

const TEXT_PADDING = 23.5;
var map_name: String;
var last_map: String;

func _ready() -> void:
	GLOBAL.connect("visit_panel", _on_visit_panel);

func _on_visit_panel(map: String, delay: float) -> void:
	map_name = LIBRARIES.MAPS.location_string[map];
	await GLOBAL.timeout(delay);
	if(last_map == map_name || MAPS.on_shared_scene): return;
	last_map = map_name;
	anim_player.stop();
	label.text = map_name.to_upper();
	panel.size.x = label.get_content_width() + TEXT_PADDING;
	anim_player.play("Visit");
