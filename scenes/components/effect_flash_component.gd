class_name EffectFlashComponent extends Node

const ANIMATION_TIME: float = 0.3

@export var damage_particles_scene: PackedScene
@export var health_component: HealthComponent
@export var meshes: Array[MeshInstance3D]
@onready var gpu_particles_3d = $GPUParticles3D


var tween: Tween
var last_hp: float
var color: Color
var last_color: Color


func _ready():
	health_component.health_changed.connect(on_health_changed)


func on_health_changed(value: float, _current_value: float) -> void:
	
	if value < 0:
		var damage_particles: GPUParticles3D = damage_particles_scene.instantiate()
		add_child(damage_particles)
		damage_particles.emitting = true
		#damage_particles.finished.connect(on_damage_particles_finished)
		await get_tree().create_timer(damage_particles.lifetime*2).timeout
		damage_particles.queue_free()
	if value > 0:
		gpu_particles_3d.emitting = true


func change_color_to(new_color: Color) -> void: 
	for mesh in meshes:	
		var material = mesh.get_surface_override_material(0)
		last_color = material.albedo_color
		if !material:
			tween.kill()
		else:
			tween.tween_property(material, "albedo_color", new_color, ANIMATION_TIME)

func prepare_tween() -> Tween:
	if tween && tween.is_valid():
			tween.kill()
	return create_tween().set_parallel(true)
