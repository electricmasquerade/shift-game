extends Node3D
class_name Controller
var parent: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	print(parent)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update() -> void:
	# this code is called to determine what the controlled node does. For the player, it handles input and stuff
	pass
