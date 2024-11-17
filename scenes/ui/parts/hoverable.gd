class_name Hoverable extends Node3D

@onready var flying_text: FlyingText = $FlyingText


func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_text.visible = false
