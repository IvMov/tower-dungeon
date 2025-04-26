class_name ControlScreen extends CanvasLayer

func _unhandled_input(event):
	if event.is_action_pressed("exit"):
		_on_back_button_pressed()

func _on_back_button_pressed() -> void:
	queue_free()
