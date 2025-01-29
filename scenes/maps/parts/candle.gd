class_name Candle extends Node3D

@onready var flying_text: FlyingText = $FlyingText
@onready var omni_light_3d: OmniLight3D = $Head/OmniLight3D
@onready var head: MeshInstance3D = $Head


func _ready() -> void:
	flying_text.set_text("I'm just candle... \n Press E")

func do_action() -> bool: 
	head.visible = !head.visible
	return false

func _on_static_body_3d_mouse_entered() -> void:
	flying_text.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_text.visible = false
