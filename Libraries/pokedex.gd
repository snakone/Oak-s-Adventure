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

var pokedex_showcase = [];

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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/bulbasaur/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/BULBASAUR.ogg"),
			"value": "Seed",
			"height": "2'04\"",
			"weight": "15.2 lbs.",
			"description": "There is a plant seed on its back right from the day this POKéMON is born. The seed slowly grows larger."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(5, 3),
					"back": Vector2(7, 3)
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/ivysaur/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/IVYSAUR.ogg"),
			"value": "Seed",
			"height": "3'03\"",
			"weight": "28.7 lbs.",
			"description": "There is a plant bulb on its back. When it absorbs nutrients, the bulb is said to blossom into a large flower."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(-7, -6),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.75, 0.75),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
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
		"name": "CHARMANDER",
		"number": ENUMS.Pokedex.CHARMANDER,
		"types": [ENUMS.Types.FIRE],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 65,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Charmander/charmander.tscn",
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/charmander/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/CHARMANDER.ogg"),
			"value": "Lizard",
			"height": "2'00\"",
			"weight": "18.7 lbs.",
			"description": "From the time it is born, a flame burns at the tip of its tail. Its life would end if the flame were to go out."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2.ZERO,
				"pokedex": {
					"front": Vector2(0, 4),
					"back": Vector2(0, 1)
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
		"name": "SQUIRTLE",
		"number": ENUMS.Pokedex.SQUIRTLE,
		"types": [ENUMS.Types.WATER],
		"moves": [1],
		"exp_type": ENUMS.ExpType.SLACK,
		"base_exp": 66,
		"category": ENUMS.PokemonCategory.STARTER,
		"sprites": "res://Sprites/Animated/Squirtle/squirtle.tscn",
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/squirtle/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/SQUIRTLE.ogg"),
			"value": "Tiny Turle",
			"height": "1'08\"",
			"weight": "19.8 lbs.",
			"description": "Its shell is not just for protection. Its rounded shape and the grooves on its surface minimize resistance in water, enabling SQUIRTLE to swim at high speeds."
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
		"name": "BEEDRILL",
		"number": ENUMS.Pokedex.BEEDRILL,
		"types": [ENUMS.Types.BUG, ENUMS.Types.POISON],
		"moves": [1],
		"exp_type": ENUMS.ExpType.MEDIUM,
		"base_exp": 159,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Beedrill/beedrill.tscn",
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/beedrill/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/BEEDRILL.ogg"),
			"value": "Poison Bee",
			"height": "3'03\"",
			"weight": "65.0 lbs.",
			"description": "It can take down any opponent with its powerful poison stingers. It sometimes attacks in swarms."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(-22, -18),
				"pokedex": {
					"front": Vector2(-20, -11),
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
		"base_exp": 2000,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Pidgey/pidgey.tscn",
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/pidgey/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/PIDGEY.ogg"),
			"value": "Tiny Bird",
			"height": "1'00\"",
			"weight": "4.0 lbs.",
			"description": "It has an extremely sharp sense of direction. It can unerringly return home to its nest, however far it may be removed from its familiar surroundings."
		},
		"display": {
			"offset": {
				"battle": Vector2.ZERO,
				"box": Vector2(1, 0),
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
		"base_exp": 2000,
		"category": ENUMS.PokemonCategory.NORMAL,
		"sprites": "res://Sprites/Animated/Rattata/rattata.tscn",
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/rattata/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/RATTATA.ogg"),
			"value": "Mouse",
			"height": "1'00\"",
			"weight": "7.7 lbs.",
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/pikachu/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/PIKACHU.ogg"),
			"value": "Mouse",
			"height": "1'04\"",
			"weight": "13.2 lbs.",
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/geodude/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/GEODUDE.ogg"),
			"value": "Rock",
			"height": "1'04\"",
			"weight": "44.1 lbs.",
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/horsea/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/HORSEA.ogg"),
			"value": "Dragon",
			"height": "1'04\"",
			"weight": "17.6 lbs.",
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/ho-oh/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/HOOH.ogg"),
			"value": "Rainbow",
			"height": "12'06\"",
			"weight": "438.7 lbs.",
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
		"specie": {
			"party_texture": preload("res://Assets/UI/Pokemon/rayquaza/icon.png"),
			"shout": preload("res://Assets/Sounds/Pokemon/RAYQUAZA.ogg"),
			"value": "Sky High",
			"height": "23'00\"",
			"weight": "455.3 lbs.",
			"description": "A POKéMON that flies endlessly in the ozone layer. It is said it would descend to the ground if KYOGRE and GROUDON were to fight."
		},
		"display": {
			"offset": {
				"battle": Vector2(0, -10),
				"box": Vector2(-30, -30),
				"pokedex": {
					"front": Vector2.ZERO,
					"back": Vector2.ZERO
				}
			},
			"scale": {
				"battle": Vector2(0.8, 0.8),
				"box": Vector2(0.6, 0.6),
				"pokedex": {
					"front": Vector2(0.8, 0.8),
					"back": Vector2(0.8, 0.8)
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
