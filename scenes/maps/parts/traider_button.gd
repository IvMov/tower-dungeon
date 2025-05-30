extends Hoverable


func _on_static_body_3d_mouse_entered() -> void:
	if GameStage.current_game_stage != GameStage.Stage.GAME:
		return
	super._on_static_body_3d_mouse_entered()
	flying_text.set_text("traider_button_text")


func do_action() -> bool:
	GameEvents.emit_change_game_stage(GameStage.Stage.TRAIDER)
	return false
