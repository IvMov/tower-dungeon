class_name FlyingText extends Node3D
@onready var sprite_3d: Sprite3D = $Sprite3D


func set_text(text: String) -> void:
	%Label.text = text
