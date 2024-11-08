class_name HealthComponent extends StatsComponent

signal health_changed(value: float, current_value: float)

func _ready() -> void:
	can_regen = true
	emit_max_value_changed(max_value)


func minus(value: float) -> bool:
	current_value = max(0, current_value - value)
	emit_health_changed(-1 * value)
	if current_value == 0:
		die()
	else:
		run_regen()
		play_damage_animation()
		
	return true


func plus(value: float) -> bool:
	var is_health_changed: bool = super.plus(value)
	if is_health_changed:
		emit_health_changed(value)
	
	return is_health_changed

func play_damage_animation() -> void:
	var animaiton_name = "take-damage-1" if randf() > 0.5 else "take-damage-2"
	if randf() > 0:
		owner_node.animation_player.play(animaiton_name)
	else:
		owner_node.animation_player.play_backwards(animaiton_name)

func die() -> void:
	if owner_node.is_dying:
		return
	owner_node.is_dying = true
	owner_node.custom_death_actions()
	if owner_node.is_dying:
		if owner_node is BasicEnemy:
			owner_node.souls_drop_component.drop_soul()
			GameEvents.emit_souls_dropped(owner_node.global_position, owner_node.soul_component.souls)
			owner_node.agr_area.disable_mode = true
		
		owner_node.animation_player.play("die")
		await owner_node.animation_player.animation_finished
		var tween = create_tween()
		tween.tween_property(owner_node, "global_position", Vector3(owner_node.global_position.x, owner_node.global_position.y+2, owner_node.global_position.z) , 0.3)
		tween.tween_callback(owner_node.queue_free)
	


func emit_health_changed(value: float) -> void:
	if owner_node is BasicEnemy:
		if owner_node.is_dying:
			owner_node.hp_bar.disable()
		else:
			owner_node.hp_bar.update(current_value, max_value)
	health_changed.emit(value, current_value)
