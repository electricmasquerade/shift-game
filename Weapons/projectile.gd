extends Area3D
class_name Projectile
var payload: Payload
@export var target: Vector3
@export var speed: float = 20.0
var target_direction: Vector3

func _ready() -> void:
	# create life timer to despawn
	var timer: Timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)

func _physics_process(delta) -> void:
	if payload == null:
		queue_free()
		return
	global_position += target_direction * speed * delta
	
func spawn(new_target: Vector3, new_payload: Payload) -> void:
	self.target = new_target
	self.payload = new_payload
	self.target_direction = (new_target - global_position).normalized()
	self.speed = new_payload.speed
	look_at(new_target, Vector3.UP)


func _on_area_entered(area):

	queue_free()


func _on_body_entered(body: Node3D) -> void:
	print("wall hit")
		
