class_name FireballProjectile extends Node3D

const FIRE_DMG: float = 1.0
var direction: Vector3
var speed: float
var radius: float
var damage: float
var skill_id: int
var push_power: float
var is_explosing: bool = false

@onready var life_timer: Timer = $LifeTimer

@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var visual_radius_of_exsplosion: MeshInstance3D = $VisualRadiusOfExsplosion
@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/Area3D/CollisionShape3D

@onready var collision_particles: GPUParticles3D = $CollisionParticles

func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func _physics_process(delta) -> void:
	translate(direction * speed * delta)


func handleb_body_collision() -> void:
	if !is_explosing:
		is_explosing = true
		speed = 0
		await do_explosion()
		life_timer.wait_time = 0.5
		life_timer.start()
		mesh_instance_3d.visible = false


func do_explosion() -> void:
	visual_radius_of_exsplosion.visible = true
	collision_particles.emitting = true
	area_3d.set_collision_mask_value(11, true)
	area_3d.set_collision_mask_value(13, true)
	area_3d.set_collision_mask_value(14, true)
	
	var tween: Tween = create_tween()
	tween.set_parallel().set_ease(Tween.EASE_IN)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius, 0.2)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius * 2, 0.2)
	tween.tween_property(collision_shape_3d.shape, "radius", radius, 0.2)
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 0.3, 0.2)
	
	tween.chain()
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", 0.1, 0.2)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", 0.1 * 2, 0.2)
	tween.tween_property(collision_shape_3d.shape, "radius", 0.1, 0.2)
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 1.5, 0.2)
	
	await tween.finished
	
	visual_radius_of_exsplosion.visible = false
	area_3d.set_collision_mask_value(11, false)
	area_3d.set_collision_mask_value(14, false)
	area_3d.set_collision_mask_value(13, false)

	
func on_life_timer_timeout() -> void:
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !area.get_parent() || !area.get_parent().get_parent():
		return
	var body: Node = area.get_parent().get_parent().get_parent();
	if body is BasicEnemy:
		handleb_body_collision()
		if body.get_damage(global_position, damage, push_power, FIRE_DMG):
			PlayerParameters.add_skill_exp(skill_id, damage)


func _on_area_3d_body_entered(body: Node3D) -> void:
	handleb_body_collision()
	if body is BasicEnemy:
		if body.get_damage(global_position, damage, push_power,  FIRE_DMG):
			PlayerParameters.add_skill_exp(skill_id, damage)
	
