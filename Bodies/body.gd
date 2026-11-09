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
	
@export var state: BodyState = BodyState.IDLE
#All bodies must have a controller that runs the movement or AI or whatever
@export var controller: Controller
@export var health_monitor: HealthMonitor
@export var health_bars: SubViewport
@export var health_bar_sprite: Sprite3D
@export var hitbox: Area3D
@export var shiftbox: ShiftBox
@export var enemy_controller_scene: PackedScene
@export var speed: float = 5.0
@export var shift_travel_time: float = 0.3
@export var shift_rotate_time: float = 0.4

@export var cam_marker: Marker3D
@export var pivot: Node3D
@export var glow: MeshInstance3D

var shift_target: bool:
	
	set(value):
		if not state == BodyState.STUNNED:
			return
		if value:
			glow.visible = true
		else:
			glow.visible = false
		shift_target = value
	get:
		return shift_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if controller == null:
		# spawn enemy controller
		var new_controller: Controller = enemy_controller_scene.instantiate()
		add_child(new_controller)
		controller=new_controller

	controller.global_position = pivot.global_position
	
	if hitbox:
		hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	
	if health_monitor:
		health_monitor.connect("dead", Callable(self, "die"))
		health_monitor.connect("stunned", Callable(self, "stunned"))
		
	health_bars.set_max(health_monitor.health, health_monitor.stun)

func _physics_process(delta: float) -> void:
	controller.update()
	move_and_slide()
	
func shift_into(player_controller: Controller, transition: bool) -> void:
	controller.die()
	player_controller.reparent(cam_marker, true)
	controller = player_controller
	# tween the controller to get it back to the cam marker position (0,0,0 relatively)
	if transition:
		GameManager.set_speed_lines(true, 0.1)
		var tween: Tween = create_tween()
		#tween.set_parallel(true)
		tween.tween_property(controller, "position", Vector3.ZERO, shift_travel_time)
		#tween.set_parallel(true)
		tween.tween_callback(GameManager.fade_to_black.bind(shift_rotate_time))
		tween.parallel().tween_property(controller, "rotation", Vector3.ZERO, shift_rotate_time)
		await tween.finished
		GameManager.set_speed_lines(false, 0.01)
	else:
		controller.position = Vector3.ZERO
		controller.rotation = Vector3.ZERO
	change_state(BodyState.PLAYER)
	
func shift_out() -> void:
	#remove the player controller and add back the AI controller
	#remove_child(controller)
	#cam_marker.add_child(controller)
	print("shifting out")
	change_state(BodyState.STUNNED)

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
			# reset velocities, it keeps inheriting player speed with no AI to override
			velocity = Vector3.ZERO
			#show health bars
			if health_bar_sprite:
				health_bar_sprite.visible = true
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
			if health_bar_sprite:
				health_bar_sprite.visible = false
			
			
		BodyState.DEAD:
			dead.emit()
		
	state = new_state

func set_player_collision() -> void:
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, false)
	
	
func set_enemy_collision() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)
	
func fire_main_weapon(target: Vector3) -> void:
	pass

func _on_hitbox_area_entered(area: Area3D) -> void:
	if area is Projectile:
		if area.payload:
			health_monitor.take_damage(area.payload)
			health_bars.update_bars(health_monitor.health, health_monitor.stun)

func die() -> void:
	pass
	#print("body died")
	
func stunned() -> void:
	change_state(BodyState.STUNNED)
