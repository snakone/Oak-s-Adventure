extends HouseController
@onready var poke_shop_door: Area2D = $PokeShopDoor;

func _ready() -> void:
	super();
	check_out_scene();

func check_out_scene() -> void:
	if(self.name in LIBRARIES.MAPS.CONNECTIONS &&
		MAPS.last_map in LIBRARIES.MAPS.CONNECTIONS[self.name]): 
			poke_shop_door.spawn_position = LIBRARIES.MAPS.CONNECTIONS[self.name][MAPS.last_map];
