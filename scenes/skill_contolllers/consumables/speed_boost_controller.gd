class_name SpeedBoostController extends BaseController

var player: Player

func start_cast() -> void:
	cooldown_timer.wait_time = skill.base_cooldown
	cast_timer.wait_time = skill.base_duration
	PlayerParameters.speed_boost = skill.base_value
	cast_timer.start()
	GameEvents.emit_item_consumed(hand, skill.id)
	cooldown()


func _on_cast_timer_timeout() -> void:
	PlayerParameters.speed_boost = 1
