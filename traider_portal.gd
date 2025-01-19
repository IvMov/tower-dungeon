extends Hoverable

var text: String = "Press E to finish stage \n & \nvisit the traider"

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.set_text(text)
	flying_text.visible = true
