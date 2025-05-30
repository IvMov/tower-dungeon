extends Hoverable

var is_traider: bool = true
func _ready() -> void:
	flying_text.set_text("traider_to_stage_text")

func do_action() -> bool: 
	if PlayerParameters.player_data["game_lvl"] % 2 == 0 && is_traider:
		GameEvents.emit_to_entry_stage()
	else:
		GameEvents.emit_from_shop_to_stage()
	
	return false

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true
