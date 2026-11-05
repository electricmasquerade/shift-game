extends Controller


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

	
	
func die():
	print("removing enemy controller")
	queue_free()
