extends PopUpScreen

func action() -> void: 
	MetaProgression.save_game_on_quit()
	get_tree().quit()
