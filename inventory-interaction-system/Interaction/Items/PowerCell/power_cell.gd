extends "res://inventory-interaction-system/Interaction/Items/CollectibleItem.gd"

class_name PowerCell

func _ready():
	item.use_item_function = PowerCell.use_item
	
func interact(_parameters=null):
	Inventory.collect.emit(item)
	Inventory.update_power_cells.emit()
	queue_free()
	
static func use_item():
	Inventory.player.get_node("Head/Camcorder").try_to_recharge()
