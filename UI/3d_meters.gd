extends SubViewport

@export var life_bar: ProgressBar
@export var stamina_bar: ProgressBar

func update_bars(health: float, stamina: float) -> void:
	life_bar.value = health
	print(health)
	stamina_bar.value = stamina

func set_max(max_health: float, max_stamina: float) -> void:
	life_bar.max_value = max_health
	stamina_bar.max_value = max_stamina
