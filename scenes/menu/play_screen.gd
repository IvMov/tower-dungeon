extends CanvasLayer

func _ready() -> void:
	GameEvents.change_game_stage.connect(on_game_stage_changed)


func _on_new_game_button_pressed() -> void:
	get_parent().add_child(ScreenTransition.NEW_GAME_SCREEN.instantiate())

func _on_continue_game_button_pressed() -> void:
	get_parent().add_child(ScreenTransition.CONTINUE_GAME_SCREEN.instantiate())

func _on_back_button_pressed() -> void:
	queue_free()

func on_game_stage_changed(gameStage: GameStage.Stage) -> void:
	if gameStage == GameStage.Stage.GAME:
		queue_free()
