extends Node3D

@onready var done_particles: GPUParticles3D = $DoneParticles

func _ready() -> void:
	if randf() > 0.3:
		done_particles.emitting = true
