extends Resource
class_name HealthMonitor

@export var health: float = 100.0:
	set(value):
		if value <= 0.0:
			health = 0.0
			emit_signal("dead")
		else:
			health = value
	get:
		return health
@export var stun: float = 100.0:
	set(value):
		if value <= 0.0:
			stun = 0.0
			emit_signal("stunned")
		else:
			stun = value
	get:
		return stun

signal dead
signal stunned

func take_damage(payload: Payload) -> void:
	health -= payload.health_damage
	stun -= payload.stun_damage
