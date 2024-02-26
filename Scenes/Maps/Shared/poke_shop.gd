extends HouseController
@onready var poke_shop_door: Area2D = $PokeShopDoor;

func _ready() -> void:
	super();
	check_out_scene();

func check_out_scene() -> void:
	if(self.name in MAPS.CONNECTIONS &&
		MAPS.last_map in MAPS.CONNECTIONS[self.name]): 
			poke_shop_door.spawn_position = MAPS.CONNECTIONS[self.name][MAPS.last_map];
