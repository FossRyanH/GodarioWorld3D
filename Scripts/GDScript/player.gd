extends CharacterBody3D


@onready var visuals : Node3D = $Visuals
@onready var camera_mount : Node3D = $CameraMount

@export var sensitivity : float = 0.085
@export var gravity : float = 9.81

@export var walk_speed : float = 3.1
@export var sprint_speed : float = 7.5
var move_speed = walk_speed
var jump_force := [4.5, 3.5]
var jump_count : int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x * sensitivity))

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity
	
	if Input.is_action_just_pressed("jump") and jump_count < jump_force.size():
		velocity.y = jump_force[jump_count]
	else:
		jump_count = 0
	
	if Input.is_action_pressed("sprint"):
		move_speed = sprint_speed
	else:
		move_speed = walk_speed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		visuals.look_at(position + direction)
		
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	move_and_slide()
