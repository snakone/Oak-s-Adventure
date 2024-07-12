extends Node

func get_shop(id: ENUMS.Shops) -> Array:
	if(id in shop_list):
		return shop_list[id];
	return [];

var shop_list = {
	ENUMS.Shops.CALDEROCK_SHOP: [
		ENUMS.Item.POKEBALL,
		ENUMS.Item.POTION
	]
}
