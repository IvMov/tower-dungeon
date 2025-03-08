class_name StaminaHealController extends BaseController


var player: Player

func start_cast() -> void:
	if !player:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
	elif player.stamina_component.current_value >= player.stamina_component.max_value:
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.FULL_STAMINA)
	else:
		player.stamina_component.plus(skill.base_value)
		GameEvents.emit_item_consumed(hand, skill.id)
