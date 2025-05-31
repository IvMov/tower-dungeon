extends Node3D
@onready var kubes: MultiMeshInstance3D = $Kubes
@onready var spheres: MultiMeshInstance3D = $Spheres
@onready var crystals: MultiMeshInstance3D = $Crystals

@export var kubes_number: int = randi_range(10, 15)
@export var spheres_number: int = randi_range(10, 15)
@export var crystals_number: int = randi_range(100, 200)
@export var radius_max: float = 150.0
@export var height_range_near: float = 15
@export var height_range_far: float = 70
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var entrance_to_stage: Node3D = $MeshInstance3D/EntranceToStage
var done: bool = false
#TODO:SET TIMER to 5-10 sec

func _ready():
	var max = radius_max * 2
	kubes.multimesh.instance_count = kubes_number
	for i in kubes_number:
		var x = randf_range(-radius_max, radius_max)
		var z = randf_range(-radius_max, radius_max)
		var y = randf_range(height_range_near, max*2)
		var random_pos = Vector3(x, y, z)
		var transform: Transform3D = Transform3D.IDENTITY
		transform.origin = random_pos
		kubes.multimesh.set_instance_transform(i, transform)

	spheres.multimesh.instance_count = spheres_number
	for i in spheres_number:
		var x = randf_range(-radius_max, radius_max)
		var z = randf_range(-radius_max, radius_max)
		var y = randf_range(height_range_near, max*2)
		var random_pos = Vector3(x, y, z)
		var transform: Transform3D = Transform3D.IDENTITY
		transform.origin = random_pos
		spheres.multimesh.set_instance_transform(i, transform)
		
	crystals.multimesh.instance_count = crystals_number
	
	for i in crystals_number:
		var random_pos = Vector3(
			randf_range(-radius_max, radius_max),
			randf_range(0, max*2),
			randf_range(-radius_max, radius_max)
		)
		
		var transform: Transform3D = Transform3D.IDENTITY
		transform.origin = random_pos
		
		transform.basis.x = Vector3(randf_range(-PI/2, PI/2), randf_range(-PI/2, PI/2), randf_range(-PI/2, PI/2))
		transform.basis = transform.basis.scaled(Vector3.ONE * randf_range(2, 10))
		crystals.multimesh.set_instance_transform(i, transform)
	
	


func _on_timer_timeout() -> void:
	PlayerParameters.player.set_is_end()
	animation_player.play("final")


func _on_area_3d_area_entered(_area: Area3D) -> void:
	if !done:
		done = true
		timer.start()
		entrance_to_stage.queue_free()
