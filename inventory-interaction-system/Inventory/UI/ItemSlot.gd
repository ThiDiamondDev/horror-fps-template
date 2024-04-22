extends ColorRect

class_name InventorySlot

@onready var button = $Slot
@onready var quantity_label = $Slot/QuantityLabel

var item: ItemResource
var selected: bool = false
var index: int
var empty: bool = true

func set_item(new_item: ItemResource):
	empty = false
	item = ItemResource.create_new_item(new_item)
	button.texture_normal = new_item.texture
	quantity_label.text = str(new_item.quantity)

func clear_slot():
	selected = false
	empty = true
	item = null
	button.texture_normal = null
	quantity_label.text = ""
	color = Color.BLACK
func unselect():
	selected = false	
	color = Color.BLACK
func _on_mouse_entered():
	if empty or selected:
		return
	color = Color.WHITE


func _on_mouse_exited():
	if empty or selected:
		return
	color = Color.BLACK
