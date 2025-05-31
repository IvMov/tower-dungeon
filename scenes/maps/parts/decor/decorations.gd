extends Node3D

@onready var multimesh_3d: MultiMeshInstance3D = $MultiMeshInstance3D

@export var instance_count: int = randi_range(70, 120)
@export var radius: float = 50.0
@export var height_range: float = 0.2

func _ready():
	multimesh_3d.multimesh.instance_count = instance_count

	for i in instance_count:
		var random_pos = Vector3(
			randf_range(-radius, radius),
			randf_range(0.01, height_range),
			randf_range(-radius, radius)
		)
		
		var transform: Transform3D = Transform3D.IDENTITY
		transform.origin = random_pos
		
		transform.basis.x = Vector3(randf_range(-PI/2, PI/2), randf_range(-PI/2, PI/2), randf_range(-PI/2, PI/2))
		multimesh_3d.multimesh.set_instance_transform(i, transform)
