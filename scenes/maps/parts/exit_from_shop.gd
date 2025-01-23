extends Hoverable

func _ready() -> void:
	flying_text.set_text("Press E to go to the next stage.")

func do_action() -> void: 
	GameEvents.emit_from_shop_to_stage()

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true
