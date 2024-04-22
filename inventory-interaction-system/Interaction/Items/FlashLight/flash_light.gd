extends Camera3D

@onready var light : SpotLight3D = $SpotLight3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rec_animation: AnimationPlayer = $RecordingIconAnimation
@onready var batteries_label :Label = $UIContainer/EnergyContainer/FlowContainer/BatteriesLabel
@onready var rec_time_label: Label = $UIContainer/RecordingContainer/FlowContainer/MarginContainer/RecordingTimeLabel
@onready var ui_container: Control = $UIContainer
@onready var timer: Timer = $Timer
@onready var zoom_label: Label = $UIContainer/RecordingContainer/ZoomLabel
@onready var night_vision_mesh: MeshInstance3D = $NightVisionMesh

var elapsed_time = 0
var material: Material

@export var normal_speed = 1
@export var reduced_speed = .3

@export var min_fov = 1
@export var max_fov = 75
@export var zoom_sensibiity = 1

@export var max_zoom_rate = 2 

var last_fov = 0

enum CAM_MODES {
	NIGHT_VISION_ON,
	NIGHT_VISION_OFF,
	POWER_OFF
}
var current_mode: CAM_MODES
var last_mode: CAM_MODES

func _ready():
	material = night_vision_mesh.get_active_material(0)
	rec_animation.play("Rec Icon Animation")
	update_power_cells()
	Inventory.update_power_cells.connect(update_power_cells)
	animation_player.play("Decrease Energy")
	set_nightvision_mode(CAM_MODES.NIGHT_VISION_OFF)
	fov = max_fov
	last_fov = fov
	
	
func set_nightvision_mode(mode: CAM_MODES):
	if mode == CAM_MODES.NIGHT_VISION_ON:
		light.visible = true
		ui_container.visible = true
		animation_player.speed_scale = normal_speed
		material.set_shader_parameter("ENABLE_NIGHT_VISION", true)
		material.set_shader_parameter("ENABLE_NOISE", true)
	elif mode == CAM_MODES.NIGHT_VISION_OFF:
		light.visible = false
		ui_container.visible = true
		animation_player.speed_scale = reduced_speed
		material.set_shader_parameter("ENABLE_NIGHT_VISION", false)
		material.set_shader_parameter("ENABLE_NOISE", true)
	elif  mode == CAM_MODES.POWER_OFF:
		light.visible = false
		animation_player.speed_scale = 0
		ui_container.visible = false
		last_fov = fov
		fov = max_fov
		timer.stop()
		material.set_shader_parameter("ENABLE_NIGHT_VISION", false)
		material.set_shader_parameter("ENABLE_NOISE", false)
		
	current_mode = mode
		
func _input(event):
	if event.is_action_pressed("ToggleCamcorder"):
		if current_mode == CAM_MODES.POWER_OFF:
			set_nightvision_mode(last_mode)
			timer.start()
			fov = last_fov
		else:
			last_mode = current_mode
			set_nightvision_mode(CAM_MODES.POWER_OFF)
		return
	
	if current_mode == CAM_MODES.POWER_OFF:
		return
	
	if event.is_action_pressed("ToggleLight"):
		if  current_mode == CAM_MODES.NIGHT_VISION_ON:
			if animation_player.current_animation_position == animation_player.current_animation_length:
				try_to_recharge()
				return
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_OFF)
			return
		if  not animation_player.assigned_animation:
			try_to_recharge()
			return
		if animation_player.current_animation_position == animation_player.current_animation_length:
			try_to_recharge()
		else:
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_ON)
			
	if event is InputEventMouseButton:
		var new_fov = fov
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			new_fov -= zoom_sensibiity
			if new_fov < min_fov:
				new_fov = min_fov
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			new_fov += zoom_sensibiity
			if new_fov > max_fov:
				new_fov = max_fov
		if new_fov != fov:
			fov = new_fov
			var max_abs_difference = abs(min_fov - max_fov)
			var current_abs_difference = abs(new_fov - max_fov)
			var zoom_value = (max_abs_difference + current_abs_difference * (max_zoom_rate - 1))
			zoom_value /= max_abs_difference 
			
			update_zoom_label(zoom_value)
		
func update_zoom_label(new_zoom: float):
	zoom_label.text = "%.2f X" % new_zoom
		
func update_power_cells():
	batteries_label.text = str(Inventory.power_cells) + "/" + str(Inventory.power_cells_limit)

func try_to_recharge():
	if Inventory.power_cells > 0:
		Inventory.power_cells -= 1
		update_power_cells()
		animation_player.play("Decrease Energy")
		set_nightvision_mode(CAM_MODES.NIGHT_VISION_ON)

func format_elapsed_time(_elapsed_time: int) -> String:
	var hours = _elapsed_time / 3600.0
	var minutes = (_elapsed_time % 3600) / 60.0
	var seconds: int = _elapsed_time % 60

	var formatted_hours: String = str(int(hours)).pad_zeros(2)
	var formatted_minutes: String = str(int(minutes)).pad_zeros(2)
	var formatted_seconds: String = str(seconds).pad_zeros(2)

	return formatted_hours + ":" + formatted_minutes + ":" + formatted_seconds


func _on_timer_timeout():
	elapsed_time += 1
	var elapsed_str = format_elapsed_time(elapsed_time)
	rec_time_label.text = elapsed_str
	

