class_name DamageBoostController extends BaseController

var player: Player

func start_cast() -> void:
	cast_timer.wait_time = calc_duration()
	cooldown_timer.wait_time = skill.base_cooldown
	PlayerParameters.damage_boost = calc_boost()
	cast_timer.start()
	GameEvents.emit_item_consumed(hand, skill.id)
	cooldown()


func calc_duration() -> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return skill.base_duration + (skill.duration_per_lvl * skill_exp_data["lvl"])
	
func calc_boost() -> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return skill.base_value + (skill.value_per_lvl * skill_exp_data["lvl"])


func _on_cast_timer_timeout() -> void:
	print("boost FINISHED")
	PlayerParameters.damage_boost = 1.0
