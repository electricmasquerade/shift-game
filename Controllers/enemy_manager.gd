extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for body in get_children():
		if body is Body:
			#connect all death signals to track progress
			body.dead.connect(_on_enemy_killed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_killed():
	print("someone died")
