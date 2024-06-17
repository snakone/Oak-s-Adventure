extends Node

var ZONES_ARRAY = [
	{
		"background": preload("res://Assets/UI/Battle/Backgrounds/field_bg.png"),
		"enemy_ground": preload("res://Assets/UI/Battle/Backgrounds/field_base1.png"),
		"player_ground": preload("res://Assets/UI/Battle/Backgrounds/field_base0.png")
	},
	{
		"background": preload("res://Assets/UI/Battle/Backgrounds/grass_01.png"),
		"enemy_ground": preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
		"player_ground": preload("res://Assets/UI/Battle/Backgrounds/grass_base0.png")
	},
	{
		"background": preload("res://Assets/UI/Battle/Backgrounds/snow_bg.png"),
		"enemy_ground": preload("res://Assets/UI/Battle/Backgrounds/snow_base1.png"),
		"player_ground": preload("res://Assets/UI/Battle/Backgrounds/snow_base0.png")
	},
];

func get_markers(marker_type: SETTINGS.Markers):
	match marker_type:
		SETTINGS.Markers.ORANGE:
			return {
				"menu": LIBRARIES.IMAGES.MAIN_MENU_ORANGE,
				"attack": LIBRARIES.IMAGES.BACKGROUND_ORANGE
			}
		SETTINGS.Markers.BLUE:
			return {
				"menu": LIBRARIES.IMAGES.MAIN_MENU_BLUE,
				"attack": LIBRARIES.IMAGES.BACKGROUND_BLUE
			}
		SETTINGS.Markers.GREEN:
			return {
				"menu": LIBRARIES.IMAGES.MAIN_MENU_GREEN,
				"attack": LIBRARIES.IMAGES.BACKGROUND_GREEN
			}
