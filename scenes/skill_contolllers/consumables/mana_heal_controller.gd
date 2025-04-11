class_name ManaHealController extends BaseController

var player: Player

func start_cast() -> void:
	if !player:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
	elif player.mana_component.current_value >= player.mana_component.max_value:
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.FULL_MANA)
	else:
		player.mana_component.plus(skill.base_value)
		GameEvents.emit_item_consumed(hand, skill.id)
		cooldown()
