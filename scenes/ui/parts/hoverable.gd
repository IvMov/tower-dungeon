class_name Hoverable extends Node3D

@onready var flying_text: FlyingText = $FlyingText


#to use
#1) create inherited scene, attach new script inherited this
#2) add area3d + connect signals on inherited sceene

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_text.visible = false

#return false if not maintainable action and true if action can be repeated if button is hold
func do_action() -> bool:
	return false
