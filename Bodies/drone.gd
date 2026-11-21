extends Body
@export var main_weapon_one: ProjectileWeapon
@export var main_weapon_two: ProjectileWeapon

var shoot_left = true

func fire_main_weapon(target: Vector3) -> void:
	# this one has two main weapons
	#fire left one first
	#main_weapon_one.fire_weapon(target)
	#main_weapon_two.fire_weapon(target)
	if shoot_left:
		main_weapon_one.fire_weapon(target)
		shoot_left = !shoot_left
		print("shooting_left")
	else:
		main_weapon_two.fire_weapon(target)
		shoot_left = !shoot_left
		print("shooting_right")
