class_name HealthComponent extends StatsComponent

signal health_changed(value: float)

func minus(value: float) -> bool:
	current_value = max(0, current_value - value)
	emit_health_changed(-1 * value)
	if current_value == 0:
		die()
	else:
		play_damage_animation()
		
	return true


func plus(value: float) -> bool:
	var health_changed: bool = super.plus(value)
	if health_changed:
		emit_health_changed(value)
	
	return health_changed

func play_damage_animation():
	var name = "take-damage-1" if randf() > 0.5 else "take-damage-2"
	if randf() > 0:
		owner.animation_player.play(name)
	else:
		owner.animation_player.play_backwards(name)

func die():
	owner.custom_death_actions()
	owner.is_dying = true
	if owner is BasicEnemy:
		owner.agr_area.disable_mode = true
		owner.death_timer.start()
	
	owner.animation_player.play("die")
	await owner.animation_player.animation_finished
	var tween = create_tween()
	tween.tween_property(owner, "global_position", Vector3(owner.global_position.x, owner.global_position.y+2, owner.global_position.z) , 0.3)


func emit_health_changed(value: float):
	print("health change emmited %0.1f", value)
	health_changed.emit(value)
