class_name SoulsDropComponent extends Node3D


func drop_soul():
	var soul_instance: Soul = GameEvents.soul.instantiate();
	get_tree().get_first_node_in_group("souls").add_child(soul_instance)
	soul_instance.emit(get_parent().soul_component.souls)
	soul_instance.global_position = get_parent().global_position + Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	soul_instance.global_position.y = 0.6
	soul_instance.rotate_y(randf_range(-PI, PI))
	soul_instance.rotate_x(randf_range(-PI, PI))
	soul_instance.rotate_z(randf_range(-PI, PI))
