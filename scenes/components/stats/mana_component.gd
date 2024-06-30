class_name ManaComponent extends StatsComponent

func _ready() -> void:
	can_regen = true

signal mana_changed(value: float)

func minus(value: float) -> bool:
	if current_value - value < 0:
		return false
	current_value -= value
	emit_mana_changed(-1 * value)
	run_regen()
	return true


func plus(value: float) -> bool:
	var is_mana_changed: bool = super.plus(value)
	if is_mana_changed:
		emit_mana_changed(value)
	
	return is_mana_changed


func emit_mana_changed(value: float) -> void:
	mana_changed.emit(value)

