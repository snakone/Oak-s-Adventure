extends NinePatchRect;

var stats: Dictionary;

@onready var hp_plus: RichTextLabel = $HBoxContainer/VBoxContainer/HP/Plus;
@onready var attack_plus: RichTextLabel = $HBoxContainer/VBoxContainer/ATK/Plus;
@onready var def_plus: RichTextLabel = $HBoxContainer/VBoxContainer/DEF/Plus;
@onready var s_atk_plus: RichTextLabel = $HBoxContainer/VBoxContainer2/S_ATK/Plus;
@onready var s_def_plus: RichTextLabel = $HBoxContainer/VBoxContainer2/S_DEF/Plus;
@onready var speed_plus: RichTextLabel = $HBoxContainer/VBoxContainer2/SPEED/Plus;

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var plus_dict = {
	"HP": hp_plus,
	"ATK": attack_plus,
	"DEF": def_plus,
	"S.ATK": s_atk_plus,
	"S.DEF": s_def_plus,
	"SPD": speed_plus,
}

var dialog_marker: Sprite2D;

func _ready() -> void:
	visible = false;

func show_panel(
	battle_stats: Dictionary,
	battle_diff_stats: Dictionary,
	marker: Sprite2D
) -> void:
	BATTLE.can_close_level_up_panel = false;
	anim_player.play("RESET");
	dialog_marker = marker;
	stats = battle_stats;
	for key in battle_diff_stats.keys():
		plus_dict[key].text = "+" + str(battle_diff_stats[key]);
	visible = true;
	BATTLE.level_up_panel_visible = true;
	marker.visible = true;

func show_stats_panel() -> void:
	anim_player.play("DefaultColor");
	for key in stats.keys():
		plus_dict[key].text = str(stats[key]);
	BATTLE.can_close_level_up_panel = true;

func close() -> void:
	await GLOBAL.timeout(0.2);
	BATTLE.level_up_panel_visible = false;
	visible = false;
	BATTLE.level_up_stats_end.emit();
