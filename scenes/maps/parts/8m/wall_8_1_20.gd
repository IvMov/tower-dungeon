extends Node3D

@onready var decal: Decal = $MeshInstance3D/Decal
@onready var decal_2: Decal = $MeshInstance3D/Decal2

func _ready() -> void:
	var height: float  = randf_range(3, 15)
	
	
	decal.size.x = height
	decal.size.z = 8
	decal.global_position.y = 20 - (height/2) - 0.1
	
	decal_2.size.z = randf_range(1, 4)
	decal_2.size.x = decal_2.size.z*0.75
	
	decal_2.texture_albedo = Constants.wall_signs.pick_random()
	decal_2.global_position.y = randf_range(1 if decal.size.z > 2 else 0.5, 3)
	decal_2.global_position.z = randf_range(-3, 3)
