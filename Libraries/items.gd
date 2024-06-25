extends Node

var LIST = [
	{
		"id": ENUMS.Item.POKEBALL,
		"name": "POKé BALL",
		"description": "A BALL thrown to catch a wild POKéMON. It is designed in a capsule style.",
		"image": preload("res://Assets/UI/Items/POKEBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH
	},
	{
		"id": ENUMS.Item.GREATBALL,
		"name": "GREAT BALL",
		"description": "A good, quality BALL that offers a higher POKéMON catch rate then a standard POKéBALL.",
		"image": preload("res://Assets/UI/Items/GREATBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH
	},
	{
		"id": ENUMS.Item.ULTRABALL,
		"name": "ULTRA BALL",
		"description": "A very high-grade BALL that offers a higher POKéMON catch rate than a GREAT BALL.",
		"image": preload("res://Assets/UI/Items/ULTRABALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH
	},
	{
		"id": ENUMS.Item.MASTERBALL,
		"name": "MASTER BALL",
		"description": "The best BALL with the ultimate performance. It will catch any wild POKéMON without fail.",
		"image": preload("res://Assets/UI/Items/MASTERBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH
	},
	{
		"id": ENUMS.Item.POTION,
		"name": "POTION",
		"description": "A spray-type wound medicine. It restores the HP of one POKéMON by 20 points.",
		"image": preload("res://Assets/UI/Items/POTION.png"),
		"type": ENUMS.BagScreen.ITEMS,
		"effect": ENUMS.ItemEffect.HEAL,
		"action": Callable(self, "potion")
	},
	{
		"id": ENUMS.Item.SUPER_POTION,
		"name": "SUPER POTION",
		"description": "A spray-type wound medicine. It resotres the HP of one POKéMON by 50 points.",
		"image": preload("res://Assets/UI/Items/SUPERPOTION.png"),
		"type": ENUMS.BagScreen.ITEMS,
		"effect": ENUMS.ItemEffect.HEAL,
		"action": Callable(self, "super_potion")
	}
];

func potion(data: Dictionary) -> Variant:
	data.current_hp += 20;
	return 20;

func super_potion(data: Dictionary) -> Variant:
	data.current_hp += 50;
	return 50;
