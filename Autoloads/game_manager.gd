extends Node

enum GameState{
	MAIN_MENU,
	PLAYING,
	PAUSED
}

var state: GameState = GameState.PLAYING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_state(new_state: GameState) -> void:
	var current_state: GameState = state
	# handle exit state changes
	match current_state:
		GameState.MAIN_MENU:
			pass
		GameState.PLAYING:
			pass
		GameState.PAUSED:
			pass
		
