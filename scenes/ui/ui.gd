extends Node2D

@onready var margin_container: MarginContainer = $CanvasLayer/MarginContainer

func _ready() -> void:
	on_screen_resized()
	GameEvents.screen_resized.connect(on_screen_resized)


func on_screen_resized() -> void:
	change_margins()
	for child in margin_container.get_children():
		child.resize()

func change_margins() -> void:
	margin_container.add_theme_constant_override("margin_top", GameConfig.grid_block/10)
	margin_container.add_theme_constant_override("margin_left", GameConfig.grid_block/10)
	margin_container.add_theme_constant_override("margin_bottom", GameConfig.grid_block/10)
	margin_container.add_theme_constant_override("margin_right", GameConfig.grid_block/10)
