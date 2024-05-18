extends LeverActivatedBase
var min_y 
var tween
@export var max_y := 3.5
@export var duration := 5
var activated = false
func _ready():
	min_y = position.y
	
	
func activate():
	activated = true
	tween = create_tween()
	tween.tween_property(self,"position:y",max_y,duration)
	tween.finished.connect(on_activate_end)
	
func deactivate():
	activated = false
	tween = create_tween()
	tween.tween_property(self,"position:y",min_y,duration)
	tween.finished.connect(on_deactivate_end)

func on_activate_end():
	end_activate.emit()
func on_deactivate_end():
	end_deactivate.emit()
	
	
