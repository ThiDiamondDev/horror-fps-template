extends MarginContainer

class_name CraftReqLabel

var text = ""

@onready var label: Label = $Label

func _ready():
	label.text = text
