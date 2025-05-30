extends Hoverable

var done: bool = false

func do_action() -> bool: 
	if !done:
		done = true
		GameEvents.emit_from_stage_to_shop()
		PlayerParameters.player_data["game_lvl"]+=1
		print("INFO: new game level: %d" % PlayerParameters.player_data["game_lvl"])
	return false


func _on_static_body_3d_mouse_entered() -> void:
	flying_text.set_text("to_traider_text")
	flying_text.visible = true
