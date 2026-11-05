extends Body

@onready var cam_yaw: Node3D = $CamYaw
@onready var cam_pitch: Node3D = $CamYaw/CamPitch
#@onready var pivot: Node3D = $Pivot
@onready var shiftbox: Area3D = $Pivot/ShiftBox


func _ready() -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_yaw.rotate_y(-event.relative.x * GameManager.sensitivity)
		cam_pitch.rotate_x(-event.relative.y * GameManager.sensitivity)
		pivot.rotate_y(-event.relative.x * GameManager.sensitivity)
		cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var camera_dir: Basis = cam_yaw.basis
	direction = camera_dir * direction
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		#pivot.basis = Basis.looking_at(direction)

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("shift"):
		print("shifting")
		print(shiftbox.target)

	move_and_slide()
