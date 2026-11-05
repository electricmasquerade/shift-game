extends CharacterBody3D
class_name Body

signal dead

enum BodyState{
	IDLE,
	ACTIVE,
	STUNNED,
	PLAYER,
	DEAD
}
	
var state: BodyState = BodyState.IDLE
#All bodies must have a controller that runs the movement or AI or whatever
@export var controller: Controller
@export var health_monitor: HealthMonitor
@export var speed: float = 5.0
@export var cam_marker: Marker3D
@export var pivot: Node3D
@export var glow: MeshInstance3D

var shift_target: bool:
	set(value):
		if value:
			glow.visible = true
		else:
			glow.visible = false
		shift_target = value
	get:
		return shift_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(controller)
	#controller.reparent(cam_marker)
	print(controller)
	controller.global_position = pivot.global_position

func _physics_process(delta: float) -> void:
	controller.update()
	move_and_slide()
	
func shift_into(player_controller: Controller) -> void:
	controller.die()
	player_controller.reparent(cam_marker, true)
	controller = player_controller
	# tween the controller to get it back to the cam marker position (0,0,0 relatively)
	var tween: Tween = create_tween()
	tween.tween_property(controller, "position", Vector3.ZERO, 0.5)
	tween.tween_property(controller, "rotation", Vector3.ZERO, 0.1)
	change_state(BodyState.PLAYER)
	
func shift_out() -> void:
	#remove the player controller and add back the AI controller
	remove_child(controller)
	cam_marker.add_child(controller)
	change_state(BodyState.ACTIVE)

func change_state(new_state: BodyState) -> void:
	var current_state: BodyState = state
	# handle exit state changes
	match current_state:
		BodyState.IDLE:
			pass
		BodyState.ACTIVE:
			pass
		BodyState.STUNNED:
			pass
		BodyState.PLAYER:
			set_enemy_collision()
			
		BodyState.DEAD:
			pass
	#handle entering state:
	match new_state:
		BodyState.IDLE:
			pass
		BodyState.ACTIVE:
			pass
		BodyState.STUNNED:
			pass
		BodyState.PLAYER:
			#entering player needs to set new collision layers and stuff
			set_player_collision()
			pass
		BodyState.DEAD:
			dead.emit()
		
	state = new_state

func set_player_collision() -> void:
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, false)
	
	
func set_enemy_collision() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
