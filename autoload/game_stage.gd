extends Node


enum  Stage {MENU = 0, GAME = 1, GAME_PAUSED = 2, GAME_END = 3}


var current_game_stage: Stage = Stage.MENU


func _ready():
	GameEvents.change_game_stage.connect(on_change_game_stage)


func on_change_game_stage(game_stage: Stage):
	current_game_stage = game_stage
	update_cursor()


func update_cursor():
	match current_game_stage:
		1: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		0, 2, 3: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

