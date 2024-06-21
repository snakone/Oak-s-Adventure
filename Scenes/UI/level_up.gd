extends NinePatchRect;

var stats: Dictionary;
var IVs: Dictionary;

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

@onready var plus_values = {
	"HP": $HBoxContainer/VBoxContainer/HP/Plus,
	"ATK": $HBoxContainer/VBoxContainer/ATK/Plus,
	"DEF": $HBoxContainer/VBoxContainer/DEF/Plus,
	"S.ATK": $HBoxContainer/VBoxContainer2/S_ATK/Plus,
	"S.DEF": $HBoxContainer/VBoxContainer2/S_DEF/Plus,
	"SPD": $HBoxContainer/VBoxContainer2/SPEED/Plus,
}

func show_panel(
	data: Dictionary,
	diff_stats: Dictionary,
) -> void:
	anim_player.play("RESET");
	stats = data.battle_stats;
	IVs = data.IV;
	for key in data.IV.keys():
		plus_values[key].text = "+" + str(diff_stats[key]);
	visible = true;

func show_total_stats() -> void:
	anim_player.play("DefaultColor");
	for key in IVs.keys():
		plus_values[key].text = str(stats[key]);
	BATTLE.can_close_level_up_panel = true;

func close() -> void:
	await GLOBAL.timeout(0.2);
	visible = false;
	BATTLE.level_up_panel_visible = false;
	BATTLE.level_up_stats_end.emit();
