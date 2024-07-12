extends Node

var LIST = [
	{
		"id": ENUMS.Item.POKEBALL,
		"name": "POKé BALL",
		"description": "A BALL thrown to catch a wild POKéMON. It is designed in a capsule style.",
		"image": preload("res://Assets/UI/Items/POKEBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH,
		"rate": 1.0,
		"shop": {
			"price": 200,
			"badges": 0
		}
	},
	{
		"id": ENUMS.Item.GREATBALL,
		"name": "GREAT BALL",
		"description": "A good, quality BALL that offers a higher POKéMON catch rate then a standard POKéBALL.",
		"image": preload("res://Assets/UI/Items/GREATBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH,
		"rate": 1.5,
		"shop": {
			"price": 600,
			"badges": 3
		}
	},
	{
		"id": ENUMS.Item.ULTRABALL,
		"name": "ULTRA BALL",
		"description": "A very high-grade BALL that offers a higher POKéMON catch rate than a GREAT BALL.",
		"image": preload("res://Assets/UI/Items/ULTRABALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH,
		"rate": 2.0,
		"shop": {
			"price": 1200,
			"badges": 5
		}
	},
	{
		"id": ENUMS.Item.MASTERBALL,
		"name": "MASTER BALL",
		"description": "The best BALL with the ultimate performance. It will catch any wild POKéMON without fail.",
		"image": preload("res://Assets/UI/Items/MASTERBALL.png"),
		"type": ENUMS.BagScreen.POKEBALL,
		"effect": ENUMS.ItemEffect.CATCH,
		"rate": 255.0
	},
	{
		"id": ENUMS.Item.POTION,
		"name": "POTION",
		"description": "A spray-type wound medicine. It restores the HP of one POKéMON by 20 points.",
		"image": preload("res://Assets/UI/Items/POTION.png"),
		"type": ENUMS.BagScreen.ITEMS,
		"effect": ENUMS.ItemEffect.HEAL,
		"action": Callable(self, "potion"),
		"shop": {
			"price": 300,
			"badges": 0
		}
	},
	{
		"id": ENUMS.Item.SUPER_POTION,
		"name": "SUPER POTION",
		"description": "A spray-type wound medicine. It restores the HP of one POKéMON by 50 points.",
		"image": preload("res://Assets/UI/Items/SUPERPOTION.png"),
		"type": ENUMS.BagScreen.ITEMS,
		"effect": ENUMS.ItemEffect.HEAL,
		"action": Callable(self, "super_potion"),
		"shop": {
			"price": 700,
			"badges": 1
		}
	}
];

func potion(data: Dictionary) -> Variant:
	var value = 20;
	data.current_hp = min(data.battle_stats["HP"], data.current_hp + value);
	return value;

func super_potion(data: Dictionary) -> Variant:
	var value = 50;
	data.current_hp = min(data.battle_stats["HP"], data.current_hp + value);
	return value;
