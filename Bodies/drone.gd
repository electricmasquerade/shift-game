extends Body
@export var main_weapon_one: ProjectileWeapon
@export var main_weapon_two: ProjectileWeapon

func fire_main_weapon(target: Vector3) -> void:
	main_weapon_one.fire_weapon(target)
	main_weapon_two.fire_weapon(target)
