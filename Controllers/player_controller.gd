extends Controller
@onready var fps_cam: Camera3D = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		parent.rotate_y(-event.relative.x * GameManager.sensitivity)
		parent.pivot.rotate_x(event.relative.y * GameManager.sensitivity)
		rotate_x(event.relative.y * GameManager.sensitivity)
		
		parent.pivot.rotation.x = clamp(parent.pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		rotation.x = clamp(rotation.x, deg_to_rad(-60), deg_to_rad(60))
# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	fps_cam.position = parent.cam_marker.position
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var camera_dir: Basis = parent.pivot.basis
	direction = camera_dir * -direction
	
	if direction:
		parent.velocity.x = direction.x * parent.speed
		parent.velocity.z = direction.z * parent.speed
		#pivot.basis = Basis.looking_at(direction)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.speed)
		parent.velocity.z = move_toward(parent.velocity.z, 0, parent.speed)
