class_name ControlScreen extends CanvasLayer

var last_scene: CanvasLayer 

func _unhandled_key_input(event):
	if event.is_action_pressed("exit"):
		_on_back_button_pressed()

func _on_back_button_pressed() -> void:
	last_scene.bacground.color.a = 0.5
	last_scene.v_box_container.visible = true
	queue_free()
