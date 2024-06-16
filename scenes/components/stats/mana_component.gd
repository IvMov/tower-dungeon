class_name ManaComponent extends StatsComponent

@onready var regen_timer = $RegenTimer


signal mana_changed(value: float)

func minus(value: float) -> bool:
	if current_value - value < 0:
		return false
	current_value = current_value - value
	regen_timer.start()
	emit_mana_changed(-1 * value)
	return true


func plus(value: float) -> bool:
	var mana_changed: bool = super.plus(value)
	if mana_changed:
		emit_mana_changed(value)
	
	return mana_changed


func emit_mana_changed(value: float) -> void:
	print("mana changed emmited %0.1f" % value)
	mana_changed.emit(value)




func _on_regen_timer_timeout() -> void:
	if max_value <= current_value:
		return
	plus(regen)
	regen_timer.start()
