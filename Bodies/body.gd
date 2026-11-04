extends CharacterBody3D
class_name Body

enum BodyState{
	IDLE,
	ACTIVE,
	STUNNED,
	PLAYER,
	DEAD
}
#All bodies must have a controller that runs the movement or AI or whatever
@export var controller: Controller
@export var speed: float = 5.0
@export var cam_marker: Marker3D
@export var pivot: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	controller.global_position = pivot.global_position

func _physics_process(delta: float) -> void:
	controller.update()
	move_and_slide()
	
func shifted_into() -> void:
	pass
