extends Node2D

@onready var anim_player = $AnimationPlayer;
@onready var label: RichTextLabel = $CanvasLayer/Panel/RichTextLabel
@onready var panel: NinePatchRect = $CanvasLayer/Panel;

const TEXT_PADDING = 23.5;
var map_name: String;

func _ready() -> void:
	GLOBAL.connect("visit_panel", _on_visit_panel);

func _on_visit_panel(map: String, delay: float) -> void:
	anim_player.stop();
	map_name = LIBRARIES.MAPS.location_string[map];
	label.text = map_name.to_upper();
	panel.size.x = label.get_content_width() + TEXT_PADDING;
	await GLOBAL.timeout(delay);
	anim_player.play("Visit");
