extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var controller = $PlayerController
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

@export var mouse_sensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0

var min_camera_x = deg_to_rad(-90)
var max_camera_x =  deg_to_rad(90)

var camera
func _ready():
	camera = controller.camera

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and controller.can_move_camera:
		rotation.y -= event.relative.x / mouse_sensibility
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
		camera.rotation.x -= event.relative.y / mouse_sensibility
		camera.rotation.x = clamp(camera.rotation.x,min_camera_x,max_camera_x)
