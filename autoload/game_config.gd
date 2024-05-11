extends Node

const MAX_MOUSE_ROTATION_X: float = 0.8
const MIN_MOUSE_ROTATION_X: float = -0.8

var mouse_sensitivity_game: float = 0.003
var mouse_sensitivity_menu: float = 0.003
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var full_screen: bool = false


func _unhandled_input(event):
	if event.is_action("full_screen") && event.is_released():
		resize_screen()
		


func resize_screen():
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	full_screen = !is_fullscreen
	GameEvents.emit_screen_resized()


func get_mouse_sensetivity():
	return mouse_sensitivity_game if GameStage.current_game_stage == 1 else mouse_sensitivity_menu

