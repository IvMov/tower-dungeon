class_name SoulsDropComponent extends Node3D


func drop_soul():
	var souls: Vector3 = get_parent().soul_component.souls
	for i in souls.x:
		var soul_instance: SoulPart = Constants.SOUL_PART.instantiate();
		Constants.SOULS.add_child(soul_instance)
		soul_instance.set_color(Constants.GREEN_SOUL_COLOR)
		soul_instance.soul_type = Enums.SoulType.GREEN
		soul_instance.global_position = global_position
		soul_instance.collect()
	for i in souls.y:
		var soul_instance: SoulPart = Constants.SOUL_PART.instantiate();
		Constants.SOULS.add_child(soul_instance)
		soul_instance.set_color(Constants.BLUE_SOUL_COLOR)
		soul_instance.soul_type = Enums.SoulType.BLUE
		soul_instance.global_position = global_position
		soul_instance.collect()
	for i in souls.z:
		var soul_instance: SoulPart = Constants.SOUL_PART.instantiate();
		Constants.SOULS.add_child(soul_instance)
		soul_instance.set_color(Constants.RED_SOUL_COLOR)
		soul_instance.soul_type = Enums.SoulType.RED
		soul_instance.global_position = global_position
		soul_instance.collect()
