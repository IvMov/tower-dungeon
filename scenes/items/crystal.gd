class_name Crystal extends Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@onready var flying_text: FlyingText = $FlyingText


func _ready() -> void:
	flying_text.set_text("Crystal \n Press E to pick up")

func rotate_random() -> void:
		mesh_instance_3d.rotate_x(randf_range(-PI, PI))
		mesh_instance_3d.rotate_z(randf_range(-PI, PI))

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_text.visible = false
