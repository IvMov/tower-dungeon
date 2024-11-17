class_name Stone extends Node3D

@onready var flying_text: FlyingText = $FlyingText

func _ready() -> void:
	flying_text.set_text("Stone \n Press E to pick up")

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_text.visible = false
