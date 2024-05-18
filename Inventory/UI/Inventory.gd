extends CenterContainer

@onready var use_item_button: Button= $MarginContainer/FlowContainer/MarginContainer/MarginContainer/VBoxContainer/UseItemButton
@onready var drop_button: Button = $MarginContainer/FlowContainer/MarginContainer/MarginContainer/VBoxContainer/DropItemContainer/DropItemButton
@onready var drop_spin:SpinBox = $MarginContainer/FlowContainer/MarginContainer/MarginContainer/VBoxContainer/DropItemContainer/DropSpinBox
@onready var craft_container = $MarginContainer/FlowContainer/MarginContainer/MarginContainer/VBoxContainer/ScrollContainer/FlowContainer
@onready var title_label = $MarginContainer/FlowContainer/MarginContainer2/ColorRect/MarginContainer/ItemName
@onready var description_label = $MarginContainer/FlowContainer/MarginContainer2/ColorRect/MarginContainer2/ItemDescription
@onready var selected_item_texture: TextureRect = $MarginContainer2/SelectedItem
@onready var container: MarginContainer = $MarginContainer
@onready var interaction_info: Label = $CenterContainer2/InteractionInfoLabel
@onready var interaction_anim_player: AnimationPlayer = $InteractionAnimPlayer

var slots = []
var selected_slot 
var used_slots = {}

func _ready():
	Inventory.add_new_item.connect(on_new_item_collected)
	Inventory.update_item.connect(on_item_updated)
	Inventory.item_removed.connect(reload_items)
	Inventory.unselect_item.connect(unselect_item)
	container.visible = false
	selected_item_texture.visible = true
	title_label.text = ""
	description_label.text = ""
	var slots_group = get_tree().get_nodes_in_group("slots")
	toggle_use_item_button()
	for index in slots_group.size():
		var slot = slots_group[index]
		slots.append(slot)
		slot.index = index
		
		var params = slots[index]

		slot.button.connect("pressed", Callable(self, "on_slot_pressed").bind(params))
	
func reload_items():
	clear_ui()
	selected_item_texture.texture = null
	for craft_item in craft_container.get_children():
		craft_item.queue_free()
	for slot in slots:
		slot.clear_slot()
	var keys = Inventory.items.keys()
	for index in range(keys.size()):
		if index >= slots.size():
			return
		var item = Inventory.items.get(keys[index])
		slots[index].set_item(item)
func clear_ui():
	title_label.text = ""
	description_label.text = ""
	use_item_button.disabled = true
	drop_button.disabled = true
	drop_spin.editable = false	
	
func unselect_item():
	if selected_slot:
		unselect(selected_slot)
func on_item_updated(item: ItemResource):
	var slot = used_slots.get(item.item_name)
	slot.set_item(item)
	return
	
			
func on_new_item_collected(item: ItemResource):
	for slot in slots:
		if slot.empty:
			slot.set_item(item)
			used_slots[item.item_name] = slot
			return
		
		
func unselect(slot):
	slot.selected = false
	slot.color = Color.WHITE
	selected_slot = null
	drop_button.disabled = true
	drop_spin.editable = false
	drop_spin.min_value = 0
	drop_spin.value = 0
	title_label.text = ""
	description_label.text = ""
	selected_item_texture.texture = null
	
func select(slot):
	selected_slot = slot
	slot.selected = true
	slot.color = Color.GREEN
	drop_button.disabled = false
	drop_spin.editable = true
	drop_spin.min_value = 1
	drop_spin.value = 1
	drop_spin.max_value = slot.item.quantity
	
	title_label.text = slot.item.item_name
	description_label.text = slot.item.description
	
	selected_item_texture.texture = slot.item.texture
	
		
func on_slot_pressed(slot):
	if slot.empty:
		return
	if slot.selected:
		unselect(slot)	
		clear_craft_items()
	else: 
		if selected_slot:
			selected_slot.unselect()
			clear_craft_items()
		select(slot)
		create_craft_items(slot.item)
		
	toggle_use_item_button()

func create_craft_items(item: ItemResource):
	for i in item.crafted_items:
		var craft_panel = CraftItemPanel.create(i)
		craft_container.add_child(craft_panel)
		
func clear_craft_items():
	for craft_item in craft_container.get_children():
		craft_item.queue_free()
func toggle_use_item_button():
	if not selected_slot or selected_slot.item.quantity <=0:
		use_item_button.disabled = true
	else:
		if selected_slot.item.use_item_function:
			use_item_button.disabled = false
		else:
			use_item_button.disabled = true
	


func _on_use_item_button_pressed():
	var item = selected_slot.item
	if  item.use_item_function:
		item.use_item_function.call()
		if item.quantity == 0:
			use_item_button.disabled = true
			Inventory.player.unset_selected_item()
		return


func _on_drop_item_button_pressed():
	Inventory.remove_item(selected_slot.item.item_name,int(drop_spin.value))
	

		
func _input(event):
	if event.is_action_pressed("ToggleInventory"):
		container.visible = not container.visible
		selected_item_texture.visible = not selected_item_texture.visible
		

func get_selected_item():
	if selected_slot:
		return selected_slot.item
	return null
func display_interaction_info(info):
	if interaction_anim_player.is_playing():
		if info != interaction_info.text:
			interaction_anim_player.stop()
			interaction_info.modulate.a = 0
			interaction_info.text = info
			interaction_anim_player.play("Interaction Info")
	else:
		interaction_info.text = info
		interaction_anim_player.play("Interaction Info")

