extends Node


signal change_game_stage(game_stage)
signal screen_resized()

func emit_change_game_stage(game_stage):
	change_game_stage.emit(game_stage)
	
func emit_screen_resized():
	screen_resized.emit()
