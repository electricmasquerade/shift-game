extends Node3D

var num_enemies: int = 0


signal level_completed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# register with the GameManager
	for body in get_children():
		if body is Body:
			#connect all death signals to track progress
			body.dead.connect(_on_enemy_killed)
			num_enemies += 1
	print(num_enemies)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_killed():
	print("someone died")
	num_enemies -= 1
	if num_enemies == 1:
		level_completed.emit()
