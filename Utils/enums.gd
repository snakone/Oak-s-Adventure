extends Node

enum PokedexIndexOptions {
	NUMERICAL,
	GRASS,
	WATER,
	SEA,
	CAVE,
	MOUNTAIN,
	ROUGH,
	URBAN,
	RARE,
	LEGENDARY,
	CLOSE
}

enum Directions { LEFT, RIGHT, UP, DOWN, NONE, ALL }
enum FacingDirection { DOWN, UP, LEFT, RIGHT };
enum Genders { MALE, FEMALE }
enum SaveType { PLAYER, SCENE, PARTY, BOXES, NPC, POKEDEX, BAG, TRAINERS }
enum DoorType { IN, OUT }
enum BinaryOptions { YES, NO }
enum DoorCategory { DOOR, TUNNEL }
enum NPCStates { MOVING, IDLE }
enum Climate { DAY, NIGHT, ANY }

enum SelectionCategory { 
	BINARY,
	HEAL,
	SLEEP,
	SWITCH_TRAINER,
	NEXT_POKEMON,
	PURCHASE 
}

enum Locations {
	PRAIRE_TOWN,
	OAK_HOUSE,
	ROUTE_00,
	OAK_FARMER_HOUSE,
	ROUTE_01,
	CALDEROCK_VILLAGE,
	POKE_CENTER,
	POKE_SHOP,
	HOUSE_01,
	ROUTE_02,
	JULIETA_HOUSE,
	JULIETA_UNDERGROUND
}

enum Types {
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISON,
	GROUND,
	FLYING,
	PSYCHIC,
	BUG,
	ROCK,
	GHOST,
	DRAGON,
	DARK,
	STEEL,
	FAIRY
}

enum AttackCategory { PHYSIC, SPECIAL, STATUS, NONE }

enum MoveNames {
	TACKLE,
	QUICK_ATTACK
}

enum Pokedex {
	BULBASAUR = 1,
	IVYSAUR = 2,
	VENUSAUR = 3,
	CHARMANDER = 4,
	CHARMELEON = 5,
	CHARIZARD = 6,
	SQUIRTLE = 7,
	WARTORTLE = 8,
	BLASTOISE = 9,
	CATERPIE = 10,
	BEEDRILL = 15,
	PIDGEY = 16,
	RATTATA = 19,
	PIKACHU = 25,
	GEODUDE = 74,
	HORSEA = 116,
	HOOH = 250,
	RAYQUAZA = 384
}

enum PokemonCategory { NORMAL, LEGENDARY, SINGULAR, SPECIAL, NONE, STARTER }

enum AttackResult { 
	NORMAL, 
	CRITICAL, 
	EFFECTIVE,
	LOW, 
	MISS, 
	NONE, 
	FULMINATE, 
	AWFULL
}

enum BattleStates {
	MENU = 0, 
	FIGHT = 1,
	DIALOG = 2, 
	ATTACKING = 3,
	LEVELLING = 4,
	SWITCHING = 5,
	ESCAPING = 6,
	NONE = 7, 
}

enum BattleType { WILD, TRAINER, ELITE, SPECIAL, NONE }
enum BattleZones { FIELD = 0, GRASS = 1, SNOW = 2 }
enum ExpType { ERRATIC, FAST, MEDIUM, SLOW, SLACK, FLUCTUATING }

#MEDIUM FAST = MEDIUM
#MEDIUM SLOW = SLACK

enum NPCDirections { 
	WALK_LEFT, WALK_RIGHT, WALK_UP, WALK_DOWN, 
	LOOK_LEFT, LOOK_RIGHT, LOOK_UP, LOOK_DOWN, NONE
}

enum AbilityType {
	SPAWN,
	AFTER_SELF_TURN,
	AFTER_ENEMY_TURN,
	AFTER_HIT,
	BEFORE_HIT
}

enum Ability {
	AIR_LOCK,
	ARENA_TRAP,
	BATTLE_ARMOR,
	BIG_PECKS,
	BLAZE,
	CHLOROPHYLL,
	CLEAR_BODY,
	CLOUD_NINE,
	COLOR_CHANGE,
	COMPOUND_EYES,
	CUTE_CHARM,
	DAMP,
	DRIZZLE,
	DROUGHT,
	EARLY_BIRD,
	EFFECT_SPORE,
	FLAME_BODY,
	FLASH_FIRE,
	FORECAST,
	GUTS,
	HUGE_POWER,
	HUSTLE,
	HYPER_CUTTER,
	ILLUMINATE,
	IMMUNITY,
	INNER_FOCUS,
	INSOMNIA,
	INTIMIDATE,
	KEEN_EYE,
	LEVITATE,
	LIGHTING_ROD,
	LIMBER,
	LIQUID_OOZE,
	MAGMA_ARMOR,
	MAGNET_PULL,
	MARVEL_SCALE,
	NATURAL_CURE,
	OBLIVIOUS,
	OVERGROW,
	OWN_TEMPO,
	PICKUP,
	PLUS,
	POISON_POINT,
	PRESSURE,
	PURE_POWER,
	RAIN_DISH,
	REGENERATOR,
	ROCK_HEAD,
	ROUGH_SKIN,
	RUN_AWAY,
	SAND_STREAM,
	SAND_VEIL,
	SERENE_GRACE,
	SHADOW_TAG,
	SHED_SKIN,
	SHELL_ARMOR,
	SHIELD_DUST,
	SNIPER,
	SOLAR_POWER,
	SOUNDPROFF,
	SPEED_BOOST,
	STATIC,
	STENCH,
	STURDY,
	SUCTION_CUPS,
	SWARM,
	SWIFT_SWIM,
	SYNCHRONIZE,
	TANGLED_FEET,
	THICK_FAT,
	TORRENT,
	TRACE,
	VITAL_SPIRIT,
	VOLT_ABSORD,
	WATER_ABSORD,
	WATER_VEIL,
	WHITE_SMOKE,
	WONDER_GUARD
}

enum BagScreen { ITEMS, POKEBALL, KEY }

enum Item {
	POKEBALL,
	GREATBALL,
	ULTRABALL,
	MASTERBALL,
	POTION,
	SUPER_POTION
}

enum ItemEffect {
	HEAL,
	STATUS,
	CATCH,
	REVIVE
}

enum Nature {
	ADAMANT,
	BASHFUL,
	BOLD,
	BRAVE,
	CALM,
	CAREFUL,
	DOCILE,
	GENTLE,
	HARDY,
	HASTY,
	IMPISH,
	JOLLY,
	LAX,
	LONELY,
	MILD,
	MODEST,
	NAIVE,
	NAUGHTY,
	QUIET,
	QUIRKY,
	RASH,
	RELAXED,
	SASSY,
	SERIOUS,
	TIMID
}

enum NPCType {
	DEFAULT,
	TRAINER,
	SHOP,
	ELITE,
	LEADER
}

enum Trainer {
	NONE,
	GREEN_GUY,
	BLUE_GUY,
	RED_GUY
}

enum Shops {
	CALDEROCK_SHOP
}
