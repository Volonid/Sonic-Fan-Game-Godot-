extends CharacterBody3D

@export var speed : float = 20
@export var acceleration : float = 15
@export var air_acceleration : float = 5
@export var gravity : float = 0.98
@export var max_terminal_velocity : float = 54
@export var jump_power : float = 20

@export var mouse_sensitivty : float = 0.1 # (float, 0.1, 1)
@export var min_pitch : float = -90 # (float, -90, 0)
@export var max_pitch : float = 90 # (float, 0, 90)

var y_velocity : float

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/CameraBoom/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivty
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivty
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("move_foward"):
		direction -= transform.basis.z
	
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

	if Input.is_action_just_pressed("jump"):
		y_velocity = jump_power

	velocity.y = y_velocity
	move_and_slide()
