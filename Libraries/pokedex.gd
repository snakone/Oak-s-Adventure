extends Node

var index_options = {
	ENUMS.PokedexIndexOptions.NUMERICAL: {
		"texture": preload("res://Assets/UI/Pokedex/numerical.png"),
		"cursor": Vector2(12, 35.5)
	},
	ENUMS.PokedexIndexOptions.GRASS: {
		"texture": preload("res://Assets/UI/Pokedex/grass.png"),
		"cursor": Vector2(12, 69.5)
	},
	ENUMS.PokedexIndexOptions.WATER: {
		"texture": preload("res://Assets/UI/Pokedex/water.png"),
		"cursor": Vector2(12, 84.5)
	},
	ENUMS.PokedexIndexOptions.SEA: {
		"texture": preload("res://Assets/UI/Pokedex/sea.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.CAVE: {
		"texture": preload("res://Assets/UI/Pokedex/cave.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.MOUNTAIN: {
		"texture": preload("res://Assets/UI/Pokedex/mountain.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.ROUGH: {
		"texture": preload("res://Assets/UI/Pokedex/rough.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.URBAN: {
		"texture": preload("res://Assets/UI/Pokedex/urban.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.RARE: {
		"texture": preload("res://Assets/UI/Pokedex/rare.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexIndexOptions.LEGENDARY: {
		"texture": preload("res://Assets/UI/Pokedex/legendary.png"),
		"cursor": Vector2(12, 93.5)
	},
	ENUMS.PokedexIndexOptions.CLOSE: {
		"texture": preload("res://Assets/UI/Pokedex/close.png"),
		"cursor": Vector2(12, 126.5)
	}
}

var LIST: Array = [
	{
		"name": "BULBASAUR",
		"number": ENUMS.Pokedex.BULBASAUR,
		"types": [ENUMS.Types.GRASS],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 64,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Bulbasaur/bulbasaur.tscn",
		"ability": {
			"default": ENUMS.Ability.OVERGROW,
			"hidden": ENUMS.Ability.CHLOROPHYLL
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
			"value": "Seed",
			"height": "2'04\"",
			"weight": "15.2 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/bulbasaur/footprint.png"),
			"description": "There is a plant seed on its back right from the day this POKéMON is born. The seed slowly grows larger."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(11, 3),
					"back": Vector2(15, 3)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 45,
			"ATK": 49,
			"DEF": 49,
			"S.ATK": 65,
			"S.DEF": 65,
			"SPD": 45,
			"TOTAL": 318
		},
		"move_set": {
			14: 3
		}
	},
	{
		"name": "IVYSAUR",
		"number": ENUMS.Pokedex.IVYSAUR,
		"types": [ENUMS.Types.GRASS, ENUMS.Types.POISON],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 141,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Ivysaur/ivysaur.tscn",
		"ability": {
			"default": ENUMS.Ability.OVERGROW,
			"hidden": ENUMS.Ability.CHLOROPHYLL
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
			"value": "Seed",
			"height": "3'03\"",
			"weight": "28.7 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/ivysaur/footprint.png"),
			"description": "There is a plant bulb on its back. When it absorbs nutrients, the bulb is said to blossom into a large flower."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(-7, -6),
				"pokedex": {
					"front": Vector2(0, -1),
					"back": Vector2(4, 3)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.75, 0.75),
				"pokedex": {
					"front": Vector2(0.7, 0.7),
					"back": Vector2(0.7, 0.7)
				}
			}
		},
		"stats": {
			"HP": 60,
			"ATK": 62,
			"DEF": 63,
			"S.ATK": 80,
			"S.DEF": 80,
			"SPD": 60,
			"TOTAL": 405
		},
		"move_set": {}
	},
{
		"name": "VENUSAUR",
		"number": ENUMS.Pokedex.VENUSAUR,
		"types": [ENUMS.Types.GRASS, ENUMS.Types.POISON],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 236,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Venusaur/venusaur.tscn",
		"ability": {
			"default": ENUMS.Ability.OVERGROW,
			"hidden": ENUMS.Ability.CHLOROPHYLL
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/venusaur/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/VENUSAUR.ogg"),
			"value": "Seed",
			"height": "6'07\"",
			"weight": "220.5 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/venusaur/footprint.png"),
			"description": "VENUSAUR’s flower is said to take on vivid colors if it gets plenty of nutrition and sunlight. The flower’s aroma soothes the emotions of people."
		},
		"display": {
			"offset": {
				"battle": Vector2(0, -4),
				"box": Vector2(-7, -6),
				"pokedex": {
					"front": Vector2(-18, -3),
					"back": Vector2(-4, -1)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.75, 0.75),
				"pokedex": {
					"front": Vector2(0.6, 0.6),
					"back": Vector2(0.6, 0.6)
				}
			}
		},
		"stats": {
			"HP": 80,
			"ATK": 82,
			"DEF": 83,
			"S.ATK": 1000,
			"S.DEF": 100,
			"SPD": 80,
			"TOTAL": 525
		},
		"move_set": {}
	},
	{
		"name": "CHARMANDER",
		"number": ENUMS.Pokedex.CHARMANDER,
		"types": [ENUMS.Types.FIRE],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 65,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Charmander/charmander.tscn",
		"ability": {
			"default": ENUMS.Ability.BLAZE,
			"hidden": ENUMS.Ability.SOLAR_POWER
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
			"value": "Lizard",
			"height": "2'00\"",
			"weight": "18.7 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/charmander/footprint.png"),
			"description": "From the time it is born, a flame burns at the tip of its tail. Its life would end if the flame were to go out."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(6, 4),
					"back": Vector2(6, 1)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 39,
			"ATK": 52,
			"DEF": 43,
			"S.ATK": 60,
			"S.DEF": 50,
			"SPD": 65,
			"TOTAL": 309
		},
		"move_set": {}
	}, 
{
		"name": "CHARMELEON",
		"number": ENUMS.Pokedex.CHARMELEON,
		"types": [ENUMS.Types.FIRE],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 142,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Charmeleon/charmeleon.tscn",
		"ability": {
			"default": ENUMS.Ability.BLAZE,
			"hidden": ENUMS.Ability.SOLAR_POWER
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/charmeleon/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/CHARMELEON.ogg"),
			"value": "Flame",
			"height": "3'07\"",
			"weight": "41.9 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/charmeleon/footprint.png"),
			"description": "Without pity, its sharp claws destroy foes. If it encounters a strong enemy, it becomes agitated, and the flame on its tail flares with a bluish white color."
		},
		"display": {
			"offset": {
				"battle": Vector2(9, -4),
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(4, -1),
					"back": Vector2(-2, -4)
				}
			},
			"scale": {
				"battle": Vector2(0.75, 0.75),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.7, 0.7),
					"back": Vector2(0.68, 0.68)
				}
			}
		},
		"stats": {
			"HP": 58,
			"ATK": 64,
			"DEF": 58,
			"S.ATK": 80,
			"S.DEF": 65,
			"SPD": 80,
			"TOTAL": 405
		},
		"move_set": {}
	},
	{
		"name": "CHARIZARD",
		"number": ENUMS.Pokedex.CHARIZARD,
		"types": [ENUMS.Types.FIRE, ENUMS.Types.FLYING],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 267,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Charizard/charizard.tscn",
		"ability": {
			"default": ENUMS.Ability.BLAZE,
			"hidden": ENUMS.Ability.SOLAR_POWER
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/charizard/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/CHARIZARD.ogg"),
			"value": "Flame",
			"height": "5'07\"",
			"weight": "199.5 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/charizard/footprint.png"),
			"description": "A CHARIZARD flies about in search of strong opponents. It breathes intense flames that can melt any material. However, it will never torch a weaker foe."
		},
		"display": {
			"offset": {
				"battle": Vector2(2, -15),
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(-14, -16),
					"back": Vector2(-12, -12)
				}
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.65, 0.65),
					"back": Vector2(0.65, 0.65)
				}
			}
		},
		"stats": {
			"HP": 78,
			"ATK": 84,
			"DEF": 78,
			"S.ATK": 109,
			"S.DEF": 85,
			"SPD": 100,
			"TOTAL": 534
		},
		"move_set": {}
	},
	{
		"name": "SQUIRTLE",
		"number": ENUMS.Pokedex.SQUIRTLE,
		"types": [ENUMS.Types.WATER],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 63,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Squirtle/squirtle.tscn",
		"ability": {
			"default": ENUMS.Ability.TORRENT,
			"hidden": ENUMS.Ability.RAIN_DISH
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
			"value": "Tiny Turle",
			"height": "1'08\"",
			"weight": "19.8 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/squirtle/footprint.png"),
			"description": "Its shell is not just for protection. Its rounded shape and the grooves on its surface minimize resistance in water, enabling SQUIRTLE to swim at high speeds."
		},
		"display": {
			"offset": {
				"battle": Vector2(1, 0),
				"box": Vector2(3, 0),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 44,
			"ATK": 48,
			"DEF": 65,
			"S.ATK": 50,
			"S.DEF": 64,
			"SPD": 43,
			"TOTAL": 314
		},
		"move_set": {
			4: 3
		}
	},
	{
		"name": "WARTORTLE",
		"number": ENUMS.Pokedex.WARTORTLE,
		"types": [ENUMS.Types.WATER],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 142,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Wartortle/wartortle.tscn",
		"ability": {
			"default": ENUMS.Ability.TORRENT,
			"hidden": ENUMS.Ability.RAIN_DISH
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/wartortle/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/WARTORTLE.ogg"),
			"value": "Turle",
			"height": "3'03\"",
			"weight": "49.6 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/wartortle/footprint.png"),
			"description": "Its large tail is covered with rich, thick fur that deepens in color with age. The scratches on its shell are evidence of this POKéMON’s toughness in battle."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(3, 0),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 59,
			"ATK": 63,
			"DEF": 80,
			"S.ATK": 65,
			"S.DEF": 80,
			"SPD": 58,
			"TOTAL": 405
		},
		"move_set": {
			4: 3
		}
	},
	{
		"name": "BLASTOISE",
		"number": ENUMS.Pokedex.BLASTOISE,
		"types": [ENUMS.Types.WATER],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 239,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Blastoise/blastoise.tscn",
		"ability": {
			"default": ENUMS.Ability.TORRENT,
			"hidden": ENUMS.Ability.RAIN_DISH
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/blastoise/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/BLASTOISE.ogg"),
			"value": "Shellfish",
			"height": "5'03\"",
			"weight": "188.5 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/blastoise/footprint.png"),
			"description": "The waterspouts that protrude from its shell are highly accurate. Their bullets of water can precisely nail tin cans from a distance of over 160 feet."
		},
		"display": {
			"offset": {
				"battle": Vector2(-1, -7),
				"box": Vector2(3, 0),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 79,
			"ATK": 83,
			"DEF": 100,
			"S.ATK": 85,
			"S.DEF": 105,
			"SPD": 78,
			"TOTAL": 530
		},
		"move_set": {
			4: 3
		}
	},
	{
		"name": "CATERPIE",
		"number": ENUMS.Pokedex.CATERPIE,
		"types": [ENUMS.Types.BUG],
		"moves": [1],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 39,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Caterpie/caterpie.tscn",
		"ability": {
			"default": ENUMS.Ability.SHIELD_DUST,
			"hidden": ENUMS.Ability.RUN_AWAY
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/caterpie/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/CATERPIE.ogg"),
			"value": "Worm",
			"height": "1'00\"",
			"weight": "6.4 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/caterpie/footprint.png"),
			"description": "Its voracious appetite compels it to devour leaves bigger than itself without hesitation. It releases a terribly strong odor from its antennae."
		},
		"display": {
			"offset": {
				"battle": Vector2(1, 0),
				"box": Vector2(3, 0),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.7, 0.7),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 45,
			"ATK": 30,
			"DEF": 35,
			"S.ATK": 20,
			"S.DEF": 20,
			"SPD": 45,
			"TOTAL": 195
		},
		"move_set": {
			4: 3
		}
	},
	{
		"name": "BEEDRILL",
		"number": ENUMS.Pokedex.BEEDRILL,
		"types": [ENUMS.Types.BUG, ENUMS.Types.POISON],
		"moves": [1],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 159,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Beedrill/beedrill.tscn",
		"ability": {
			"default": ENUMS.Ability.SWARM,
			"hidden": ENUMS.Ability.SNIPER
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
			"value": "Poison Bee",
			"height": "3'03\"",
			"weight": "65.0 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/beedrill/footprint.png"),
			"description": "It can take down any opponent with its powerful poison stingers. It sometimes attacks in swarms."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(-22, -18),
				"pokedex": {
					"front": Vector2(-21, -11),
					"back": Vector2(-3, -11)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 65,
			"ATK": 90,
			"DEF": 40,
			"S.ATK": 45,
			"S.DEF": 80,
			"SPD": 75,
			"TOTAL": 395
		},
		"move_set": {}
	},
	{
		"name": "PIDGEY",
		"number": ENUMS.Pokedex.PIDGEY,
		"types": [ENUMS.Types.NORMAL, ENUMS.Types.FLYING],
		"moves": [3],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 50,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Pidgey/pidgey.tscn",
		"ability": {
			"default": ENUMS.Ability.KEEN_EYE,
			"hidden": ENUMS.Ability.BIG_PECKS
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
			"value": "Tiny Bird",
			"height": "1'00\"",
			"weight": "4.0 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/pidgey/footprint.png"),
			"description": "It has an extremely sharp sense of direction. It can unerringly return home to its nest, however far it may be removed from its familiar surroundings."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(2, -1),
				"pokedex": {
					"front": Vector2(2, 0),
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 40,
			"ATK": 45,
			"DEF": 40,
			"S.ATK": 35,
			"S.DEF": 35,
			"SPD": 56,
			"TOTAL": 251
		},
		"move_set": {}
	},
	{
		"name": "RATTATA",
		"number": ENUMS.Pokedex.RATTATA,
		"types": [ENUMS.Types.NORMAL],
		"moves": [3],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 51,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Rattata/rattata.tscn",
		"ability": {
			"default": ENUMS.Ability.RUN_AWAY,
			"hidden": ENUMS.Ability.HUSTLE
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
			"value": "Mouse",
			"height": "1'00\"",
			"weight": "7.7 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/rattata/footprint.png"),
			"description": "Living wherever there is food available, it ceaselessly scavenges for edibles the entire day."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2(-3, 0)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 30,
			"ATK": 56,
			"DEF": 35,
			"S.ATK": 25,
			"S.DEF": 35,
			"SPD": 72,
			"TOTAL": 253
		},
		"move_set": {}
	},
	{
		"name": "PIKACHU",
		"number": ENUMS.Pokedex.PIKACHU,
		"types": [ENUMS.Types.ELECTRIC],
		"moves": [1],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 82,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Pikachu/pikachu.tscn",
		"ability": {
			"default": ENUMS.Ability.STATIC,
			"hidden": ENUMS.Ability.LIGHTING_ROD
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
			"value": "Mouse",
			"height": "1'04\"",
			"weight": "13.2 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/pikachu/footprint.png"),
			"description": "It stores electricity in the electric sacs on its cheeks. When it releases pent-up energy in a burst, the electric power is equal to a lightning bolt."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 35,
			"ATK": 55,
			"DEF": 40,
			"S.ATK": 50,
			"S.DEF": 50,
			"SPD": 90,
			"TOTAL": 320
		},
		"move_set": {}
	},
	{
		"name": "GEODUDE",
		"number": ENUMS.Pokedex.GEODUDE,
		"types": [ENUMS.Types.ROCK, ENUMS.Types.GROUND],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 86,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Geodude/geodude.tscn",
		"ability": {
			"default": ENUMS.Ability.STATIC,
			"hidden": ENUMS.Ability.LIGHTING_ROD
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/geodude/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/GEODUDE.ogg"),
			"value": "Rock",
			"height": "1'04\"",
			"weight": "44.1 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/geodude/footprint.png"),
			"description": "It climbs mountain paths using only the power of its arms. Because they look just like boulders lining paths, hikers may step on them without noticing."
		},
		"display": {
			"offset": {
				"battle": Vector2(-1, -3),
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 40,
			"ATK": 80,
			"DEF": 100,
			"S.ATK": 30,
			"S.DEF": 30,
			"SPD": 20,
			"TOTAL": 300
		},
		"move_set": {}
	},
	{
		"name": "HORSEA",
		"number": ENUMS.Pokedex.HORSEA,
		"types": [ENUMS.Types.WATER],
		"moves": [1],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 83,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Horsea/horsea.tscn",
		"ability": {
			"default": ENUMS.Ability.SWITH_SWIM,
			"hidden": ENUMS.Ability.DAMP
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
			"value": "Dragon",
			"height": "1'04\"",
			"weight": "17.6 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/horsea/footprint.png"),
			"description": "By cleverly flicking the fins on its back side to side, it moves in any direction while facing forward. It spits ink to escape if it senses danger.",
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.8, 0.8),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 30,
			"ATK": 40,
			"DEF": 70,
			"S.ATK": 70,
			"S.DEF": 25,
			"SPD": 60,
			"TOTAL": 295
		},
		"move_set": {}
	},
	{
		"name": "HO-OH",
		"number": ENUMS.Pokedex.HOOH,
		"types": [ENUMS.Types.FIRE, ENUMS.Types.FLYING],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLOW,
		"base_exp": 220,
		"category": ENUMS.PokemonCategory.LEGENDARY,
		"sprites": "res://Sprites/Animated/Ho-oh/ho-oh.tscn",
		"ability": {
			"default": ENUMS.Ability.PRESSURE,
			"hidden": ENUMS.Ability.REGENERATOR
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/ho-oh/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/HOOH.ogg"),
			"value": "Rainbow",
			"height": "12'06\"",
			"weight": "438.7 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/ho-oh/footprint.png"),
			"description": "Its feathers--which glow in seven colors depending on the angle at which they are struck by light--are thought to bring joy. It is said to live at the foot of a rainbow.",
		},
		"display": {
			"offset": {
				"battle": Vector2(0, -16),
				"box": Vector2(-28, -28),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.6, 0.6),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
				}
			}
		},
		"stats": {
			"HP": 106,
			"ATK": 130,
			"DEF": 90,
			"S.ATK": 110,
			"S.DEF": 154,
			"SPD": 90,
			"TOTAL": 680
		},
		"move_set": {}
	},
	{
		"name": "RAYQUAZA",
		"number": ENUMS.Pokedex.RAYQUAZA,
		"types": [ENUMS.Types.DRAGON, ENUMS.Types.FLYING],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLOW,
		"base_exp": 220,
		"category": ENUMS.PokemonCategory.LEGENDARY,
		"sprites": "res://Sprites/Animated/Rayquaza/rayquaza.tscn",
		"ability": {
			"default": ENUMS.Ability.AIR_LOCK,
			"hidden": null
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/rayquaza/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/RAYQUAZA.ogg"),
			"value": "Sky High",
			"height": "23'00\"",
			"weight": "455.3 lbs.",
			"footprint": preload("res://Assets/UI/Pokemon/rayquaza/footprint.png"),
			"description": "A POKéMON that flies endlessly in the ozone layer. It is said it would descend to the ground if KYOGRE and GROUDON were to fight."
		},
		"display": {
			"offset": {
				"battle": Vector2(0, -10),
				"box": Vector2(-30, -30),
				"pokedex": {
					"front": Vector2(-34, -18),
					"back": Vector2(-12, -23)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.6, 0.6),
				"pokedex": {
					"front": Vector2(0.6, 0.6),
					"back": Vector2(0.58, 0.58)
				}
			}
		},
		"stats": {
			"HP": 105,
			"ATK": 150,
			"DEF": 90,
			"S.ATK": 150,
			"S.DEF": 90,
			"SPD": 95,
			"TOTAL": 680
		},
		"move_set": {}
	},
];

var ABILITIES = {
	ENUMS.Ability.AIR_LOCK: {
		"name": "Air Lock",
		"description": "Eliminates the effects of the weather.",
		"apply": func(): BATTLE.current_weather = BATTLE.Weather.NONE
	},
	ENUMS.Ability.ARENA_TRAP: {
		"name": "Arena Trap",
		"description": "Prevents the foe from fleeing.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.BATTLE_ARMOR: {
		"name": "Battle Armor",
		"description": "The POKéMON is protected against critical hits.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.BLAZE: {
		"name": "Blaze",
		"description": "Powers up Fire-type moves in a pinch.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	}
}
