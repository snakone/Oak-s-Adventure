extends Node2D

@onready var anim_player = $AnimationPlayer;
@onready var rich_text_label = $Panel/RichTextLabel;

var current_map_name;
var panel_on = false;

func get_map_name_and_show_visit(location_name: String) -> void:
	anim_player.stop();
	if(panel_on): return;
	current_map_name = LIBRARIES.MAPS.location_string[location_name];
	rich_text_label.text = current_map_name;
	anim_player.play("Visit");
	panel_on = true;

func _on_animation_player_animation_finished(anim_name):
	panel_on = false;
