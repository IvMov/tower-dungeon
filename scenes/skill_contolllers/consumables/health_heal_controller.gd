class_name HealthHealController extends BaseController

var player: Player

func start_cast() -> void:
	if !player:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
		return
	else:
		player.health_component.plus(skill.base_value)
		GameEvents.emit_item_consumed(hand, skill.id)
