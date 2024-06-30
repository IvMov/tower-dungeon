class_name StaminaComponent extends StatsComponent

func _ready() -> void:
	can_regen = true

signal stamina_changed(value: float)

func minus(value: float) -> bool:
	if current_value - value < 0:
		return false
	current_value -= value
	emit_stamina_changed(-1 * value)
	run_regen()
	return true


func plus(value: float) -> bool:
	var is_stamina_changed: bool = super.plus(value)
	if is_stamina_changed:
		emit_stamina_changed(value)
	
	return is_stamina_changed


func emit_stamina_changed(value: float) -> void:
	stamina_changed.emit(value)

