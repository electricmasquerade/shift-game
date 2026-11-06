extends Area3D
class_name ShiftBox

var targets: Array[Body]
var target: Body:
	set(new_target):
		if target:
			target.shift_target = false
		target = new_target
		if target:
			target.shift_target = true
# current target is the closest body in the targets array



func _physics_process(delta: float) -> void:
	#update target to closest one in array
	update_target()
	


func _on_area_entered(area: Area3D) -> void:
	
	##check if there is a parent of the entered area that is a body
	var current_node: Node3D = area
	while current_node != null and not (current_node is Body):
		current_node = current_node.get_parent()
	if current_node is Body:
		targets.append(current_node)
		#print(targets)
	else:
		print("No Target found")
	update_target()
	


func _on_area_exited(area: Area3D) -> void:
	# get body of area
	var current_node: Node3D = area
	while current_node != null and not (current_node is Body):
		current_node = current_node.get_parent()
	if current_node is Body:
		targets.erase(current_node)
		#print(targets)
	else:
		print("something is wrong")
	update_target()
	
func update_target() -> void:
	if targets.size() > 0:
		target = targets[0]
		for body in targets:
			if body.global_position.distance_to(global_position) < target.global_position.distance_to(global_position):
				target = body
	else:
		target = null
	
