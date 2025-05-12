extends Node3D

@onready var decal: Decal = $MeshInstance3D/Decal

func _ready() -> void:
	var height: float  = randf_range(3, 15)
	
	decal.size.x = height
	decal.size.z = 8
	decal.global_position.y = 16 - (height/2) - 0.1
	
