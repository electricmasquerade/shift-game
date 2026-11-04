extends Node

@export var sensitivity: float = 0.003

enum GameState{
	MAIN_MENU,
	PLAYING,
	PAUSED
}

var state: GameState = GameState.PLAYING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# capture mouse by default for now
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if state == GameState.PAUSED:
			change_state(GameState.PLAYING)
		else:
			change_state(GameState.PAUSED)

func change_state(new_state: GameState) -> void:
	var current_state: GameState = state
	# handle exit state changes
	match current_state:
		GameState.MAIN_MENU:
			pass
		GameState.PLAYING:
			pass
		GameState.PAUSED:
			#exiting pause needs to unpause the game
			get_tree().paused = false
			
		
	#handle entering state:
	match new_state:
		GameState.MAIN_MENU:
			pass
		GameState.PLAYING:
			# needs to have mouse captured when entering playing state
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GameState.PAUSED:
			#entering pause needs to pause the game and free mouse
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	state = new_state
