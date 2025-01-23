extends Hoverable

var text: String = "Press E to finish stage \n & \nvisit the traider"


func do_action() -> void: 
	GameEvents.emit_from_stage_to_shop()


func _on_static_body_3d_mouse_entered() -> void:
	flying_text.set_text(text)
	flying_text.visible = true
