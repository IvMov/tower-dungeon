extends Node3D

@onready var sprite_2d = $CanvasLayer/Sprite2D


func _ready() -> void:
	GameEvents.screen_resized.connect(on_screen_resized)
	relocate_crosshair()


func relocate_crosshair() -> void:
	#TODO: change this to get center + 1 + 1 by y and x
	sprite_2d.global_position = get_viewport().get_visible_rect().get_center() 

func on_screen_resized() -> void:
	relocate_crosshair()
