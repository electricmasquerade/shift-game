extends Node3D
class_name ProjectileWeapon

@export var payload: Payload
@export var projectile_scene: PackedScene
@export var sound_effect: AudioStream
@onready var cooldown_timer = $CooldownTimer
var on_cooldown: bool = false
@onready var weapon_sound: AudioStreamPlayer3D = $WeaponSound
@export var muzzle_flash: CPUParticles3D


func _ready():
	cooldown_timer.wait_time = payload.cooldown
	weapon_sound.stream = sound_effect

	

func fire_weapon(target: Vector3) -> void:
	muzzle_flash.emitting = true
	if on_cooldown:
		return
	var new_projectile: Projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(new_projectile)
	#force the projectile to spawn at the weapon's position
	new_projectile.global_position = global_position

	new_projectile.spawn(target, payload)
	
	cooldown_timer.start()
	on_cooldown = true
	weapon_sound.play()


func _on_cooldown_timer_timeout():
	on_cooldown = false
