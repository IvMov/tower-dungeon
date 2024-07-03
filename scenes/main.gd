extends Node

@onready var label = $CanvasLayer/Label

func _physics_process(delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()

