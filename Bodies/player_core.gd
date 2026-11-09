extends Body

@onready var cam_yaw: Node3D = $CamYaw
@onready var cam_pitch: Node3D = $CamYaw/CamPitch
#@onready var pivot: Node3D = $Pivot
@export var player_controller_scene: PackedScene
@onready var third_per_cam: Camera3D = $CamYaw/CamPitch/SpringArm3D/Camera3D


func _ready() -> void:
	state = BodyState.PLAYER

func _unhandled_input(event: InputEvent) -> void:
	if state != BodyState.PLAYER:
		return
	if event is InputEventMouseMotion:
		cam_yaw.rotate_y(-event.relative.x * GameManager.sensitivity)
		cam_pitch.rotate_x(-event.relative.y * GameManager.sensitivity)
		pivot.rotate_y(-event.relative.x * GameManager.sensitivity)
		cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if state != BodyState.PLAYER:
		return
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
		#print("shifting")
		#print(shiftbox.target)
		shift(shiftbox.target)

	move_and_slide()

func shift(target: Body) -> void:
	#TODO: add stun check on body either here or in shiftbox
	var new_player_controller: Controller = player_controller_scene.instantiate()
	add_child(new_player_controller)
	new_player_controller.global_position = pivot.global_position
	new_player_controller.global_rotation = pivot.global_rotation
	new_player_controller.shift_into(target, false)
	# tween current camera towards the new one
	var tween: Tween = create_tween()
	#tween.set_parallel(true)
	GameManager.set_speed_lines(true, 0.1)
	tween.tween_property(third_per_cam, "global_position", new_player_controller.fps_cam.global_position, shift_travel_time)
	tween.tween_callback(GameManager.fade_to_black.bind(shift_rotate_time))
	tween.parallel().tween_property(third_per_cam, "global_rotation", new_player_controller.fps_cam.global_rotation, shift_rotate_time)
	await tween.finished
	GameManager.set_speed_lines(false, 0.1)
	new_player_controller.fps_cam.current = true
	change_state(BodyState.DEAD)
	despawn()
	
func despawn() -> void:
	await get_tree().create_timer(2.0).timeout
	queue_free()
