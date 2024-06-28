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

var nature_strings = {
	ENUMS.Nature.ADAMANT: "ADAMANT",
	ENUMS.Nature.BASHFUL: "BASHFUL",
	ENUMS.Nature.BOLD: "BOLD",
	ENUMS.Nature.BRAVE: "BRAVE",
	ENUMS.Nature.CALM: "CALM",
	ENUMS.Nature.CAREFUL: "CAREFUL",
	ENUMS.Nature.DOCILE: "DOCILE",
	ENUMS.Nature.GENTLE: "GENTLE",
	ENUMS.Nature.HARDY: "HARDY",
	ENUMS.Nature.HASTY: "HASTY",
	ENUMS.Nature.IMPISH: "IMPISH",
	ENUMS.Nature.JOLLY: "JOLLY",
	ENUMS.Nature.LAX: "LAX",
	ENUMS.Nature.LONELY: "LONELY",
	ENUMS.Nature.MILD: "MILD",
	ENUMS.Nature.MODEST: "MODEST",
	ENUMS.Nature.NAIVE: "NAIVE",
	ENUMS.Nature.NAUGHTY: "NAUGHTY",
	ENUMS.Nature.QUIET: "QUIET",
	ENUMS.Nature.QUIRKY: "QUIRKY",
	ENUMS.Nature.RASH: "RASH",
	ENUMS.Nature.RELAXED: "RELAXED",
	ENUMS.Nature.SASSY: "SASSY",
	ENUMS.Nature.SERIOUS: "SERIOUS",
	ENUMS.Nature.TIMID: "TIMID"
}
