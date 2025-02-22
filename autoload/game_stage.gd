extends Node


enum  Stage {MENU = 0, GAME = 1, INVENTORY = 2, TRAIDER = 3, GAME_PAUSED = 8, GAME_END = 9}


const TRAIDER_SCREEN = preload("res://scenes/screens/traider_screen.tscn")


var current_game_stage: Stage = Stage.GAME
var test = false

func _ready():
	GameEvents.change_game_stage.connect(on_change_game_stage)

func _unhandled_input(event):
	if event.is_action("exit")  && event.is_released() && (current_game_stage == Stage.INVENTORY || current_game_stage == Stage.TRAIDER):
		GameEvents.emit_change_game_stage(Stage.GAME)

	if event.is_action("inventory") && event.is_released():
		if current_game_stage == Stage.INVENTORY:
			GameEvents.emit_change_game_stage(Stage.GAME)
		elif current_game_stage == Stage.GAME:
			GameEvents.emit_change_game_stage(Stage.INVENTORY)

func on_change_game_stage(game_stage: Stage):
	current_game_stage = game_stage
	update_cursor()


func update_cursor():
	match current_game_stage:
		1, 9: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		0, 2, 3, 8: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func is_stage(stage: Stage) -> bool:
	return current_game_stage == stage;
