extends "res://inventory-interaction-system/Interaction/Items/CollectibleItem.gd"

func interact(_parameters=null):
	Inventory.collect.emit(item)
	Inventory.update_power_cells.emit()
	queue_free()
	
static func use_item():
	Inventory.player.get_node("Head/Camcorder").try_to_recharge()
