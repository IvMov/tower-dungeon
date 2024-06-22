class_name DamageFlashComponent
extends Node

const ANIMATION_TIME: float = 0.3

@export var health_component: HealthComponent
@export var meshes: Array[MeshInstance3D]
@onready var gpu_particles_3d = $GPUParticles3D

var tween: Tween
var last_hp: float
var color: Color


func _ready():
	health_component.health_changed.connect(on_health_changed)


func on_health_changed(value: float) -> void:
	if value < 0:
		tween = prepare_tween()
		change_color_to(Color.RED)
		tween.chain()
		change_color_to(Color.WHITE)
	else:
		gpu_particles_3d.emitting = true


func change_color_to(color: Color) -> void: 
	for mesh in meshes:	
		var material = mesh.get_surface_override_material(0)
		tween.tween_property(material, "albedo_color", color, ANIMATION_TIME)

func prepare_tween() -> Tween:
	if tween && tween.is_valid():
			tween.kill()
	return create_tween().set_parallel(true)
