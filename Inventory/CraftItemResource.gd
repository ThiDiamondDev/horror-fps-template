extends ItemResource

class_name CraftItem

@export var itemsNeeded: Array[ItemResource]

func _init(p_itemsNeeded=[ItemResource.new()] as Array[ItemResource]):
	itemsNeeded = p_itemsNeeded
