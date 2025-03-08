class_name HealthHealController extends BaseController

var player: Player

func start_cast() -> void:
	if !player:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
	elif player.health_component.current_value >= player.health_component.max_value:
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.FULL_HP)
	else:
		player.health_component.plus(skill.base_value)
		GameEvents.emit_item_consumed(hand, skill.id)
