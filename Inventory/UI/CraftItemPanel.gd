extends VBoxContainer

class_name CraftItemPanel

@onready var req_container=$HBoxContainer/RequirementsContainer
@onready var title_label = $Separator2/CraftItemTitle
@onready var craft_button: Button = $HBoxContainer/CraftButton

var item
var needed_items = []
static func create(_item):
	var scene = load("res://Inventory/UI/CraftItemPanel.tscn")
	var panel: CraftItemPanel = scene.instantiate()	
	panel.item = _item
	return panel
	
func _ready():
	reload()
	Inventory.add_new_item.connect(update_label)
func update_label(_item: ItemResource):
	if _item.item_name in needed_items:
		for child in req_container.get_children():
			child.queue_free()
		reload()
		 
func reload():
	var scene = load("res://Inventory/UI/CraftItemRequirement.tscn")
	craft_button.disabled = false
	needed_items.clear()
	for item_req in item.itemsNeeded:
		var new_req: CraftReqLabel = scene.instantiate() 
		
		var inventory_quantity = 0
		var _item = Inventory.get_item(item_req.item_name)
		if _item:
			inventory_quantity = _item.quantity
		needed_items.append(item_req.item_name)
		new_req.text = str(inventory_quantity) + "/" 
		new_req.text += str(item_req.quantity)  + " "
		new_req.text += item_req.item_name
		if inventory_quantity < item_req.quantity and not craft_button.disabled:
			craft_button.disabled = true
		req_container.add_child(new_req)
	
	title_label.text = self.item.item_name


func _on_craft_button_pressed():
	for i in item.itemsNeeded:
		Inventory.remove_item(i.item_name,i.quantity,false)
	Inventory.item_removed.emit()
	Inventory.add_item(item)
