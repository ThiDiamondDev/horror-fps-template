extends StaticBody3D

@export var start_mode_activated: bool = false 
@onready var lever_bar: DragInteraction = $LeverBar
@onready var activation_shape: CollisionShape3D = $ActivationArea/CollisionShape3D
@onready var deactivation_shape: CollisionShape3D = $DeactivationArea/CollisionShape3D
@onready var rotation_reference = $RotationReference
@export var object : LeverActivatedBase
var activated := start_mode_activated

func _ready():
	if object:
		object.end_activate.connect(unlock_bar)
		object.end_deactivate.connect(unlock_bar)
		if start_mode_activated:
			lever_bar.set_affected_property(lever_bar.max_value)
			activation_shape.set_deferred("disabled",true)
			deactivation_shape.set_deferred("disabled",false)
		else:
			lever_bar.set_affected_property(lever_bar.min_value)
			activation_shape.set_deferred("disabled",false)
			deactivation_shape.set_deferred("disabled",true)


func _on_activation_area_area_entered(_area):
	if object:
		lever_bar.stop_interaction()
		lever_bar.set_affected_property(lever_bar.max_value)
		lever_bar.min_value_locked = lever_bar.max_value
		lever_bar.max_value_locked = lever_bar.max_value - 5
		lever_bar.is_locked = true
		flip_activate()
		if object.activated:
			object.deactivate()
		else:
			object.activate()
	
func _on_deactivation_area_area_entered(_area):
	if object:
		lever_bar.stop_interaction()
		lever_bar.set_affected_property(lever_bar.min_value)
		lever_bar.min_value_locked = lever_bar.min_value_locked
		lever_bar.max_value_locked = lever_bar.min_value + 5
		lever_bar.is_locked = true
		flip_activate()
		if object.activated:
			object.deactivate()
		else:
			object.activate()
	
func flip_activate():
	activation_shape.set_deferred("disabled",not activation_shape.disabled)
	deactivation_shape.set_deferred("disabled",not deactivation_shape.disabled)

func unlock_bar():
	lever_bar.is_locked = false
