extends "res://inventory-interaction-system/Interaction/InteractionBase.gd"

class_name DragInteraction

@export var key_name:String
@export var locked_message: String
@export var open_message: String
@export var locking_open_message: String
@export var on_lock_message: String
@export var wrong_item_message: String

@export_enum("position", "rotation_degrees") var affected_prop := "position"
@export_enum("x", "y", "z") var affected_axis := "x"
@export_enum("x", "y") var mouse_axis := "y"
@export var weight := 1.0

@export var min_offset := 0.0
@export var max_offset := 0.0
@export var max_offset_locked := 3.0

@export var is_locked := false
@export var break_key:= false
@export var max_distance := 5.0

signal interaction_end

var player: Player

var min_value: float
var max_value: float
var max_value_locked
var min_value_locked

func _ready():
	set_process_input(false)
	set_process(false)
	var property = get_affected_property()
	min_value = property + min_offset
	max_value = property + max_offset
	max_value_locked = property + max_offset_locked
	min_value_locked = min_value
func is_in_closed_range():
	var property = get_affected_property()
	return property >= min_value and property <= max_value_locked
func stop_interaction():
	set_process(false)
	set_process_input(false)
	interaction_end.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player:
		var distance = player.global_position.distance_to(self.global_position)
		if distance > max_distance:
			stop_interaction()
				
func get_affected_property():
	return self[affected_prop][affected_axis]

func set_affected_property(value: float):
	self[affected_prop][affected_axis] = value

func get_min_value():
	if is_locked:
		return min_value_locked
	else:
		return min_value	

func get_max_value():
	if is_locked:
		return max_value_locked
	else:
		return max_value	
func interact(parameters=null):
	player = parameters
	var selected_item = Inventory.get_selected_item()
	if selected_item:
		if selected_item.item_name == key_name:
			var message = on_lock_message 
			if is_locked:
				message = open_message
			if break_key:
				message += "(the key broke)"
			if not is_in_closed_range():
				Inventory.display_interaction_info(locking_open_message)
				
			else:
				Inventory.display_interaction_info(message)
			
				if break_key:
					Inventory.remove_item(key_name,1)
				if Inventory.get_item(key_name):
					Inventory.unselect_item.emit()
				is_locked = not is_locked
				
		elif selected_item and selected_item.item_name != key_name:
			Inventory.display_interaction_info(wrong_item_message)
	elif is_locked:
		Inventory.display_interaction_info(locked_message)
		
	set_process(true)
	set_process_input(true)
	
func move_object(mouse_movement: Vector2):
	var property = get_affected_property()
	var direction = 1
	if not is_player_in_front(player,self):
		direction = -1
	
	var movement = property + (mouse_movement[mouse_axis] * weight) * direction
	if movement >= get_min_value() and movement <= get_max_value():
		set_affected_property(movement)
	


func _input(event):
	if event.is_action_released("Interact"):
		stop_interaction()
		return
	if event is InputEventMouseMotion:
		move_object(event.relative)
