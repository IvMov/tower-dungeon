extends Node3D

@onready var decal: Decal = $MeshInstance3D/Decal

func _ready() -> void:
	var height: float  = randf_range(10, 16)
	decal.size.x = height
	decal.global_position.y = 20 - (height/2) - 0.1
	
