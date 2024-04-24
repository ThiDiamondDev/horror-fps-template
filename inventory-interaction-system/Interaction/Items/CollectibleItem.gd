extends "res://inventory-interaction-system/Interaction/InteractionBase.gd"

class_name CollectibleItem

@export var item: ItemResource
	
func _ready():
	item.use_item_function = get_script().use_item
	
static func use_item():
	pass
	
func interact(_parameters=null):
	Inventory.collect.emit(item)
	queue_free()

