extends Node

signal update_power_cells
signal collect(item: ItemResource)
signal update_item(item: ItemResource)
signal add_new_item(item: ItemResource)
signal item_removed()
signal unselect_item()

var items: Dictionary = {}
var player: Player

func display_interaction_info(text):
	player.inventory.display_interaction_info(text)
func get_selected_item():
	return player.inventory.get_selected_item()
func _ready():
	collect.connect(add_item)
	
func add_item(item: ItemResource):
	var item_to_update = items.get(item.item_name)
	if item_to_update:
		item_to_update.quantity += item.quantity
		update_item.emit(item_to_update)
		return
	items[item.item_name] = ItemResource.create_new_item(item)
	add_new_item.emit(item)
			
func get_item(item_name) -> ItemResource:
	return items.get(item_name)

func remove_item(item_name,quantity=0, _emit_signal=true):
	if quantity == 0:
		items.erase(item_name)
	else:
		var item = items.get(item_name)
		if not item: return
		
		var new_quantity = item.quantity - quantity
		if new_quantity > 0:
			item.quantity = new_quantity
		else:
			items.erase(item_name)
	if _emit_signal:
		item_removed.emit()
		return
	
