extends Node3D
class_name ProjectileWeapon

@export var payload: Payload
@export var projectile_scene: PackedScene
@onready var cooldown_timer = $CooldownTimer
var on_cooldown: bool = false


func _ready():
	cooldown_timer.wait_time = payload.cooldown

func fire_weapon(target: Vector3) -> void:
	if on_cooldown:
		return
	var new_projectile: Projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(new_projectile)
	#force the projectile to spawn at the weapon's position
	new_projectile.global_position = global_position

	new_projectile.spawn(target, payload)
	
	cooldown_timer.start()
	on_cooldown = true


func _on_cooldown_timer_timeout():
	on_cooldown = false
