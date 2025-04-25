extends CanvasLayer

@onready var back_button = $MarginContainer/ColorRect/VBoxContainer2/BackButton


func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	
func _unhandled_input(event):
	if event.is_action_pressed("exit"):
		on_back_button_pressed()


func on_back_button_pressed():
	queue_free()
