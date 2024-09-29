extends Control

const MAX_MOUSE_ROTATION_X: float = PI/2
const V_BLOCKS: int = 18
var mouse_sensitivity_game: float = 0.003
var mouse_sensitivity_menu: float = 0.003
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var full_screen: bool = false
# 1/N part of vertical screen to be sure that all blocks are alligned
var grid_block: float

func _ready() -> void:
	theme = preload("res://resources/main_theme.tres")
	recalculate_screen_grid_block()

func _unhandled_input(event):
	if event.is_action("full_screen") && event.is_released():
		resize_screen()

func recalculate_screen_grid_block() -> void:
	grid_block = get_window().size.x / V_BLOCKS

func resize_screen() -> void:
	request_ready()
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	recalculate_screen_grid_block()
	resize_font()
	full_screen = !is_fullscreen
	GameEvents.emit_screen_resized()

func resize_font() -> void:
	
	theme.default_font_size = grid_block/3
	self.set_theme(theme)

func get_mouse_sensetivity():
	return mouse_sensitivity_game if GameStage.current_game_stage == 1 else mouse_sensitivity_menu


	
