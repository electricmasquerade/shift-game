extends Node

@export var sensitivity: float = 0.003
@onready var speed_lines: TextureRect = $CanvasLayer/SpeedLines
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

enum GameState{
	MAIN_MENU,
	PLAYING,
	PAUSED
}

var state: GameState = GameState.PLAYING


#this forces capture for web export i guess
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_viewport().set_input_as_handled() # Prevents unwanted side-effects


	if event.is_action_pressed("ui_cancel"): # "ui_cancel" maps to Escape by default
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
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

func fade_to_black(duration: float) -> void:
	color_rect.modulate.a = 0.0
	# modulate the colorrect to do like a loading fade
	var fade_percent: float = .2
	var hold_percent: float = 1.0 - 2*fade_percent
	color_rect.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, duration * fade_percent) # Fades in over duration/2
	tween.tween_interval(duration * hold_percent)
	tween.tween_property(color_rect, "modulate:a", 0.0, duration * fade_percent) # Fades out over duration/2
	await tween.finished
	color_rect.visible = false
	
func set_speed_lines(value: bool, duration: float) -> void:
	if value: # fade in the speed lines
		speed_lines.visible = true
		#speed_lines.modulate.a = 0.0
		var tween: Tween = create_tween()
		tween.tween_property(speed_lines, "modulate:a", 1.0, duration) # Fades in over duration/2
	else:
		#speed_lines.modulate.a = 1.0
		var tween: Tween = create_tween()
		tween.tween_property(speed_lines, "modulate:a", 0.0, duration)
		await tween.finished 
		speed_lines.visible = false
	
		
