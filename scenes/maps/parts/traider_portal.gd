extends Hoverable

var text: String = "Press E to finish stage \n & \nvisit the traider"


func do_action() -> bool: 
	GameEvents.emit_from_stage_to_shop()
	return false


func _on_static_body_3d_mouse_entered() -> void:
	flying_text.set_text(text)
	flying_text.visible = true
