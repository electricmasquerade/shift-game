extends Controller
@onready var fps_cam: Camera3D = $Camera3D
@export var min_angle: float = -70.0
@export var max_angle: float = 70.0
var target: Body



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		body.rotate_y(-event.relative.x * GameManager.sensitivity)
		body.pivot.rotate_x(-event.relative.y * GameManager.sensitivity)
		body.pivot.rotation.x = clamp(body.pivot.rotation.x, deg_to_rad(min_angle), deg_to_rad(max_angle))

func _ready() -> void:
	super()
	
	

func _physics_process(delta: float) -> void:
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta
	
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("shift"):
		#print("here's the target")
		#print(body.shiftbox.target)
		target = body.shiftbox.target
		if target:
			shift_into(target, true)
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var camera_dir: Basis = body.pivot.basis
	direction = camera_dir * direction
	
	if direction:
		body.velocity.x = direction.x * body.speed
		body.velocity.z = direction.z * body.speed
		#pivot.basis = Basis.looking_at(direction)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, body.speed)
		body.velocity.z = move_toward(body.velocity.z, 0, body.speed)

func shift_into(new_target: Body, transition: bool) -> void:
	body.shift_out()
	new_target.shift_into(self, transition)
	body = new_target
	
func die():
	pass
