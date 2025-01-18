extends Hoverable



func _on_static_body_3d_mouse_entered() -> void:
	super._on_static_body_3d_mouse_entered()
	flying_text.set_text("Press E to open the shop.")
