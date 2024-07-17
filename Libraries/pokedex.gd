extends Node

var LIST: Array = [
	{
		"name": "BULBASAUR",
		"number": ENUMS.Pokedex.BULBASAUR,
		"types": [ENUMS.Types.GRASS],
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 64,
		"catch_rate": 45,
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
			"description": "There is a plant seed on its back right from the day this POKéMON is born. By soaking up the sun\'s rays, the seed grows progressively larger. It can go for days without eating a single morsel."
		},
		"search": {
			"category": ENUMS.PokedexOptions.GRASS,
			"color": ENUMS.Colors.GREEN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(0, 5),
					"back": Vector2.ZERO
				},
				"box": Vector2(5, 0),
				"pokedex": Vector2(9, 15),
				"summary": {
					"front": Vector2(14, 18)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 141,
		"catch_rate": 45,
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
			"description": "There is a bud on this POKéMON's back. To support its weight, IVYSAUR's legs and trunk grow thick and strong. If it starts spending more time lying in the sunlight, it's a sign that the bud will bloom into a large flower soon."
		},
		"search": {
			"category": ENUMS.PokedexOptions.GRASS,
			"color": ENUMS.Colors.GREEN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				},
				"box": Vector2(-5, -5),
				"pokedex": Vector2(0, 2),
				"summary": {
					"front": Vector2(4, 6)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 236,
		"catch_rate": 45,
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
			"description": "There is a large flower on VENUSAUR's back. The flower is said to take on vivid colors if it gets plenty of nutrition and sunlight. The flower's aroma soothes the emotions of people. It stays on the move to seek sunlight."
		},
		"search": {
			"category": ENUMS.PokedexOptions.GRASS,
			"color": ENUMS.Colors.GREEN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(1, -4),
					"back": Vector2.ZERO
				},
				"box": Vector2(-16, -12),
				"pokedex": Vector2(-17, -16),
				"summary": { 
					"front": Vector2(-12, -9) 
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.65, 0.65),
				"pokedex": Vector2(0.75, 0.75)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 65,
		"catch_rate": 45,
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
			"description": "The flame that burns at the tip of its tail is an indication of its emotions. The flame wavers when CHARMANDER is enjoying itself. If the POKéMON becomes enraged, the flame burns fiercely. If healthy, its tail burns intensely."
		},
		"search": {
			"category": ENUMS.PokedexOptions.MOUNTAIN,
			"color": ENUMS.Colors.RED
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(1, 3),
					"back": Vector2.ZERO
				},
				"box": Vector2(3, 2),
				"pokedex": Vector2(8, 11),
				"summary": {
					"front": Vector2(12, 13)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 142,
		"catch_rate": 45,
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
			"description": "Without pity, its sharp claws destroy foes. If it encounters a strong enemy, it becomes agitated, and the flame on its tail flares with a bluish white color. When excited, it may breathe out bluish-white flames."
		},
		"search": {
			"category": ENUMS.PokedexOptions.MOUNTAIN,
			"color": ENUMS.Colors.RED
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(12, -2),
					"back": Vector2(-10, 0)
				},
				"box": Vector2(-2, -5),
				"pokedex": Vector2(4, -1),
				"summary": { 
					"front": Vector2(7, 2)
				}
			},
			"scale": {
				"battle": Vector2(0.75, 0.75),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
			},
			"rotation": -5
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 267,
		"catch_rate": 45,
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
			"description": "Charizard flies around the sky in search of powerful opponents. It breathes fire of such great heat that it melts anything. However, it never turns its fiery breath on any opponent weaker than itself."
		},
		"search": {
			"category": ENUMS.PokedexOptions.MOUNTAIN,
			"color": ENUMS.Colors.RED
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(3, -15),
					"back": Vector2(-10, 0)
				},
				"box": Vector2(-14, -26),
				"pokedex": Vector2(-11, -30),
				"summary": { 
					"front": Vector2(-8, -21)
				}
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.65, 0.65),
				"pokedex": Vector2(0.65, 0.65)
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
		"moves": [218],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 63,
		"catch_rate": 45,
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
			"description": "Its shell is not just for protection. Its rounded shape and the grooves on its surface minimize resistance in water, enabling SQUIRTLE to swim at high speeds. Withdraws into its shell when in danger."
		},
		"search": {
			"category": ENUMS.PokedexOptions.WATER,
			"color": ENUMS.Colors.BLUE
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(2, 4),
					"back": Vector2.ZERO
				},
				"box": Vector2(4, 0),
				"pokedex": Vector2(9, 11),
				"summary": { 
					"front": Vector2(8, 2)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 142,
		"catch_rate": 45,
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
			"description": "Its tail is large and covered with a rich, thick fur. The tail becomes increasingly deeper in color as WARTORTLE ages. The scratches on its shell are evidence of this POKéMON's toughness as a battler."
		},
		"search": {
			"category": ENUMS.PokedexOptions.WATER,
			"color": ENUMS.Colors.BLUE
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(2, -3),
					"back": Vector2(0, -4)
				},
				"box": Vector2(-1, -5),
				"pokedex": Vector2(1, 0),
				"summary": { 
					"front": Vector2(0, -3)
				}
			},
			"scale": {
				"battle": Vector2(0.74, 0.74),
				"box": Vector2(0.65, 0.65),
				"pokedex": Vector2(0.65, 0.65)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 239,
		"catch_rate": 45,
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
			"description": "BLASTOISE has water spouts that protrude from its shell. The water spouts are very accurate. They can shoot bullets of water with enough accuracy to strike empty cans from a distance of over 160 feet."
		},
		"search": {
			"category": ENUMS.PokedexOptions.WATER,
			"color": ENUMS.Colors.BLUE
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(-2, -9),
					"back": Vector2(0, -4)
				},
				"box": Vector2(-12, -10),
				"pokedex": Vector2(-14, -17),
				"summary": { 
					"front": Vector2(-10, -9)
				}
			},
			"scale": {
				"battle": Vector2(0.85, 0.85),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.8, 0.8)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 39,
		"catch_rate": 255,
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
			"description": "CATERPIE has a voracious appetite. It can devour leaves bigger than its body right before your eyes. From its antenna, this POKéMON releases a terrifically strong odor. It grows by molting repeatedly."
		},
		"search": {
			"category": ENUMS.PokedexOptions.FOREST,
			"color": ENUMS.Colors.GREEN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(3, 9),
					"back": Vector2(0, 4)
				},
				"box": Vector2(11, 9),
				"pokedex": Vector2(17, 26),
				"summary": { 
					"front": Vector2(17, 13)
				}
			},
			"scale": {
				"battle": Vector2(0.65, 0.65),
				"box": Vector2(0.6, 0.6),
				"pokedex": Vector2(0.6, 0.6)
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
		"moves": [218],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 159,
		"catch_rate": 45,
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
			"shadow": ENUMS.ShadowSize.SMALL,
			"footprint": preload("res://Assets/UI/Pokemon/beedrill/footprint.png"),
			"description": "It can take down any opponent with its powerful poison stingers. It sometimes attacks in swarms."
		},
		"search": {
			"category": ENUMS.PokedexOptions.FOREST,
			"color": ENUMS.Colors.YELLOW
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(-10, -14),
					"back": Vector2(8, -3),
					"shadow": Vector2(11, 0)
				},
				"box": Vector2(-22, -16),
				"pokedex": Vector2(-24, -20),
				"summary": {
					"front": Vector2(-21, -18),
					"shadow": Vector2(16, -1)
				},
				
			},
			"scale": {
				"battle": Vector2(0.85, 0.85),
				"box": Vector2(0.75, 0.75),
				"pokedex": Vector2(0.8, 0.8)
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
		"moves": [218],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 50,
		"catch_rate": 255,
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
			"description": "PIDGEY has an extremely sharp sense of direction. It is capable of unerringly returning home to its nest, however far it may be removed from its familiar surroundings. If disturbed, it can ferociously strike back."
		},
		"search": {
			"category": ENUMS.PokedexOptions.FOREST,
			"color": ENUMS.Colors.BROWN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(2, 3),
					"back": Vector2.ZERO
				},
				"box": Vector2(3, -2),
				"pokedex": Vector2(7, 6),
				"summary": { 
					"front": Vector2(11, 10)
				}
			},
			"scale": {
				"battle": Vector2(0.75, 0.75),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [218],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 51,
		"catch_rate": 255,
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
		"search": {
			"category": ENUMS.PokedexOptions.GRASS,
			"color": ENUMS.Colors.PURPLE
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(1, 6),
					"back": Vector2(-5, 2)
				},
				"box": Vector2(2, 0),
				"pokedex": Vector2(6, 7),
				"summary": { 
					"front": Vector2(6, 1)
				}
			},
			"scale": {
				"battle": Vector2(0.74, 0.74),
				"box": Vector2(0.7, 0.7),
				"pokedex": Vector2(0.75, 0.75)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 82,
		"catch_rate": 190,
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
		"search": {
			"category": ENUMS.PokedexOptions.FOREST,
			"color": ENUMS.Colors.YELLOW
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(5, 5),
					"back": Vector2(-6, 0)
				},
				"box": Vector2(6, 0),
				"pokedex": Vector2(10, 7),
				"summary": {
					"front": Vector2(10, 5)
				}
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.65, 0.65),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 86,
		"catch_rate": 255,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Geodude/geodude.tscn",
		"ability": {
			"default": ENUMS.Ability.ROCK_HEAD,
			"hidden": ENUMS.Ability.SAND_VEIL
		},
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/geodude/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/GEODUDE.ogg"),
			"value": "Rock",
			"height": "1'04\"",
			"weight": "44.1 lbs.",
			"shadow": ENUMS.ShadowSize.SMALL,
			"footprint": preload("res://Assets/UI/Pokemon/geodude/footprint.png"),
			"description": "It climbs mountain paths using only the power of its arms. Because they look just like boulders lining paths, hikers may step on them without noticing."
		},
		"search": {
			"category": ENUMS.PokedexOptions.MOUNTAIN,
			"color": ENUMS.Colors.BROWN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(-1, -10),
					"back": Vector2(1, -5),
					"shadow": Vector2(5, 0)
				},
				"box": Vector2(-9, -9),
				"pokedex": Vector2(-7, -10),
				"summary": {
					"front": Vector2(-2, -7),
					"shadow": Vector2(15, 0)
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.75, 0.75),
				"pokedex": Vector2(0.8, 0.8)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 83,
		"catch_rate": 225,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Horsea/horsea.tscn",
		"ability": {
			"default": ENUMS.Ability.SWIFT_SWIM,
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
		"search": {
			"category": ENUMS.PokedexOptions.SEA,
			"color": ENUMS.Colors.BLUE
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(4, 4),
					"back": Vector2(-2, 1)
				},
				"box": Vector2(11, 2),
				"pokedex": Vector2(15, 9),
				"summary": {
					"front": Vector2(15, 8)
				}
			},
			"scale": {
				"battle": Vector2(0.75, 0.75),
				"box": Vector2(0.65, 0.65),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLOW,
		"base_exp": 220,
		"catch_rate": 3,
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
			"shadow": ENUMS.ShadowSize.SMALL,
			"footprint": preload("res://Assets/UI/Pokemon/ho-oh/footprint.png"),
			"description": "Its feathers--which glow in seven colors depending on the angle at which they are struck by light--are thought to bring joy. It is said to live at the foot of a rainbow.",
		},
		"search": {
			"category": ENUMS.PokedexOptions.LEGENDARY,
			"color": ENUMS.Colors.RED
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(2, -23),
					"back": Vector2(2, -8),
					"shadow": Vector2(4, 0)
				},
				"box": Vector2(-27, -30),
				"pokedex": Vector2(-24, -41),
				"summary": {
					"front": Vector2(-15, -30),
					"shadow": Vector2(14, 2)
				},
				
			},
			"scale": {
				"battle": Vector2(0.7, 0.7),
				"box": Vector2(0.6, 0.6),
				"pokedex": Vector2(0.7, 0.7)
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
		"moves": [309],
		"exp_type": ENUMS.ExpType.SLOW,
		"base_exp": 220,
		"catch_rate": 3,
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
			"shadow": ENUMS.ShadowSize.SMALL,
			"footprint": preload("res://Assets/UI/Pokemon/rayquaza/footprint.png"),
			"description": "RAYQUAZA lived for hundreds of millions of years in the earth's ozone layer, never descending to the ground. This POKéMON appears to feed on water and particles in the atmosphere."
		},
		"search": {
			"category": ENUMS.PokedexOptions.LEGENDARY,
			"color": ENUMS.Colors.GREEN
		},
		"display": {
			"offset": {
				"battle": {
					"front": Vector2(0, -18),
					"back": Vector2(0, -8),
					"shadow": Vector2(9, 3)
				},
				"box": Vector2(-32, -30),
				"pokedex": Vector2(-26, -40),
				"summary": {
					"front": Vector2(-16, -25),
					"shadow": Vector2(19, 0)
				},
				
			},
			"scale": {
				"battle": Vector2(0.75, 0.75),
				"box": Vector2(0.6, 0.6), 
				"pokedex": Vector2(0.7, 0.7),
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
	},
	ENUMS.Ability.OVERGROW: {
		"name": "Overgrow",
		"description": "Powers up Grass-type moves in a pinch.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.TORRENT: {
		"name": "Torrent",
		"description": "Powers up Water-type moves in a pinch.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.SHIELD_DUST: {
		"name": "Shield Dust",
		"description": "Blocks the added effects of attacks taken.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.SWARM: {
		"name": "Swarm",
		"description": "Powers up Bug-type moves in a pinch.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.SWIFT_SWIM: {
		"name": "Swift Swim",
		"description": "Boosts the POKéMON's Speed in rain.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.SNIPER: {
		"name": "Sniper",
		"description": "Powers up moves if they become critical hits.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.ROCK_HEAD: {
		"name": "Rock Head",
		"description": "Protects the POKéMON from recoil damage.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.STURDY: {
		"name": "Sturdy",
		"description": "The POKéMON is protected against 1-hit KO attacks.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.KEEN_EYE: {
		"name": "Keen Eye",
		"description": "Prevents other POKéMON from lowering accuracy.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.TANGLED_FEET: {
		"name": "Tangled Feet",
		"description": "Raises evasion if the POKéMON is confused.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.RUN_AWAY: {
		"name": "Run Away",
		"description": "Enables a sure getaway from wild POKéMON.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.GUTS: {
		"name": "Guts",
		"description": "Boosts Attack if there is a status problem.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.STATIC: {
		"name": "Static",
		"description": "Contact with the POKéMON may cause paralysis.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
	ENUMS.Ability.PRESSURE: {
		"name": "Pressure",
		"description": "The POKéMON raises the foe's PP usage.",
		"apply": func(target: Dictionary): if(target != null): target.can_escape = false
	},
}

var index_options = {
	ENUMS.PokedexOptions.NUMERICAL: {
		"texture": preload("res://Assets/UI/Pokedex/numerical.png"),
		"cursor": Vector2(12, 35.5)
	},
	ENUMS.PokedexOptions.GRASS: {
		"texture": preload("res://Assets/UI/Pokedex/grass.png"),
		"cursor": Vector2(12, 69.5)
	},
	ENUMS.PokedexOptions.FOREST: {
		"texture": preload("res://Assets/UI/Pokedex/forest.png"),
		"cursor": Vector2(12, 84.5)
	},
	ENUMS.PokedexOptions.WATER: {
		"texture": preload("res://Assets/UI/Pokedex/water.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.SEA: {
		"texture": preload("res://Assets/UI/Pokedex/sea.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.CAVE: {
		"texture": preload("res://Assets/UI/Pokedex/cave.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.MOUNTAIN: {
		"texture": preload("res://Assets/UI/Pokedex/mountain.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.ROUGH: {
		"texture": preload("res://Assets/UI/Pokedex/rough.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.SNOW: {
		"texture": preload("res://Assets/UI/Pokedex/snow.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.URBAN: {
		"texture": preload("res://Assets/UI/Pokedex/urban.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.RARE: {
		"texture": preload("res://Assets/UI/Pokedex/rare.png"),
		"cursor": Vector2(12, 99.5)
	},
	ENUMS.PokedexOptions.LEGENDARY: {
		"texture": preload("res://Assets/UI/Pokedex/legendary.png"),
		"cursor": Vector2(12, 93.5)
	},
	ENUMS.PokedexOptions.CLOSE: {
		"texture": preload("res://Assets/UI/Pokedex/close.png"),
		"cursor": Vector2(12, 126.5)
	}
}

var habitat_ground = {
	ENUMS.PokedexOptions.GRASS: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.FOREST: preload("res://Assets/UI/Battle/Backgrounds/forest_base1.png"),
	ENUMS.PokedexOptions.WATER: preload("res://Assets/UI/Battle/Backgrounds/water_base1.png"),
	ENUMS.PokedexOptions.SEA: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.CAVE: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.MOUNTAIN: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.ROUGH: preload("res://Assets/UI/Battle/Backgrounds/field_base1.png"),
	ENUMS.PokedexOptions.SNOW: preload("res://Assets/UI/Battle/Backgrounds/snow_base1.png"),
	ENUMS.PokedexOptions.URBAN: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.RARE: preload("res://Assets/UI/Battle/Backgrounds/grass_base1.png"),
	ENUMS.PokedexOptions.LEGENDARY: preload("res://Assets/UI/Battle/Backgrounds/champion1_base1.png"),
}
