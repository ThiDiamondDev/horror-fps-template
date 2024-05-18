extends Resource

class_name ItemResource

@export var item_name: String =""
@export var texture: CompressedTexture2D
@export var mesh: Mesh
@export var quantity: int = 0
@export var crafted_items: Array[CraftItem]
@export_multiline var description: String

var use_item_function: Callable

signal use_item

static func create_new_item(item: ItemResource):
	var new_item: ItemResource = ItemResource.new()
	new_item.item_name = item.item_name
	new_item.texture = item.texture
	new_item.quantity = item.quantity
	new_item.use_item_function = item.use_item_function
	new_item.crafted_items = item.crafted_items
	new_item.description = item.description
	new_item.mesh = item.mesh
	
	return new_item

