extends CanvasLayer


func _on_back_to_menu_pressed() -> void:
	GameStage.current_game_stage = GameStage.Stage.MENU
	PlayerParameters.reset_player()
	queue_free()
