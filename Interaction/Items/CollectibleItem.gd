extends InteractionBase

class_name CollectibleItem

@export var item: ItemResource
	
func _ready():
	var script: Script = get_script()
	if script.has_method("use_item"):
		item.use_item_function = get_script().use_item

func interact(_parameters=null):
	Inventory.collect.emit(item)
	on_collect()
	queue_free()

func on_collect():
	pass
