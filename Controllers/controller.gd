extends Node3D
class_name Controller
var body: CharacterBody3D
var health_monitor: HealthMonitor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# loop for top level parent as a body
	get_controller_body()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update() -> void:
	# this code is called to determine what the controlled node does. For the player, it handles input and stuff
	pass

func get_controller_body() -> void:
	var current_node: Node3D = self
	while current_node != null and not (current_node is Body):
		current_node = current_node.get_parent()
	if current_node is Body:
		body = current_node
	else:
		print("Controller must be a child of a Body node")
