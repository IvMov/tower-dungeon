class_name EffectFlashComponent extends Node

const ANIMATION_TIME: float = 0.3

@export var damage_particles_scene: PackedScene
@export var health_component: HealthComponent
@export var meshes: Array[MeshInstance3D]
@onready var gpu_particles_3d = $GPUParticles3D
@onready var slow_down_particles: GPUParticles3D = $SlowDownParticles


var tween: Tween
var last_hp: float
var color: Color
var last_color: Color
var is_player: bool = false


func _ready():
	GameEvents.skill_call_failed.connect(on_skill_call_failed)
	health_component.health_changed.connect(on_health_changed)


func on_health_changed(value: float, _current_value: float) -> void:
	
	if value < 0:
		var damage_particles: GPUParticles3D = damage_particles_scene.instantiate()
		add_child(damage_particles)
		damage_particles.emitting = true
		add_text(value)
		await get_tree().create_timer(damage_particles.lifetime*2).timeout
		
		damage_particles.queue_free()
	if value > 0:
		gpu_particles_3d.emitting = true

func add_text(value: float) -> void:
	var text: Text = Constants.TEXT.instantiate()
	add_child(text)
	text.set_float(value, is_player)
	await text.play(is_player)

func start_slow_down() -> void:
	if !slow_down_particles.emitting:
		slow_down_particles.emitting = true

func stop_slow_down() -> void:
	if slow_down_particles.emitting:
		slow_down_particles.emitting = false


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

func on_skill_call_failed(skill_id: int, enum_num: int) -> void:
	if is_player:
		var text_holder: Text = Constants.TEXT.instantiate()
		add_child(text_holder)
		text_holder.set_text(tr(str(Enums.SkillCallFailedReason.keys()[enum_num])))
		text_holder.play(true)
