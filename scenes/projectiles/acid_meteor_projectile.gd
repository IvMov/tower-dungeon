class_name AcidMeteorProjectile extends Node3D

const RAND: float = 0.05

var acid_dmg: float 
var direction: Vector3
var speed: float
var damage: float
var skill_id: int
var push_power: float
var explosion: bool = false
#radius of explosion
var radius: float
#how long one ping before explosion lasts (0.2 to 0.1)
var before_explosion_time_unit: float = 0.2


@onready var area_3d: Area3D = $Meteor/Area3D
@onready var meteor: MeshInstance3D = $Meteor
@onready var life_timer: Timer = $LifeTimer
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var collision_particles: GPUParticles3D = $CollisionParticles
@onready var collision_shape_3d: CollisionShape3D = $Meteor/Area3D/CollisionShape3D
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2
@onready var visual_radius_of_exsplosion: MeshInstance3D = $VisualRadiusOfExsplosion


func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func pre_explosion() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(meteor.mesh, "radius", meteor.mesh.radius * 3, before_explosion_time_unit)
	tween.tween_property(meteor.mesh, "height", meteor.mesh.height * 3, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(meteor.mesh, "radius", meteor.mesh.radius / 3, before_explosion_time_unit)
	tween.tween_property(meteor.mesh, "height", meteor.mesh.height / 3, before_explosion_time_unit)
	await tween.finished

func do_explosion() -> void:
	if explosion:
		return
	explosion = true
	visual_radius_of_exsplosion.visible = true
	collision_particles.emitting = true
	area_3d.set_collision_mask_value(11, true)
	area_3d.set_collision_mask_value(13, true)
	area_3d.set_collision_mask_value(14, true)
	
	visual_radius_of_exsplosion.get_active_material(0).albedo_color = Color(1, 1, 1, 0.1)
	var tween: Tween = create_tween()
	tween.set_parallel().set_ease(Tween.EASE_IN)
	
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius, 2)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius * 2, 2)
	tween.tween_property(collision_shape_3d.shape, "radius", radius, 2)
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 0.1, 2)
	
	tween.chain()
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 2, 2)
	tween.chain()
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 0.1, 2)
	
	tween.chain()
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 6, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", 0.1, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", 0.1 * 2, before_explosion_time_unit)
	tween.tween_property(collision_shape_3d.shape, "radius", 0.1, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 1, before_explosion_time_unit)
	
	await tween.finished
	
	visual_radius_of_exsplosion.visible = false
	area_3d.set_collision_mask_value(11, false)
	area_3d.set_collision_mask_value(14, false)
	area_3d.set_collision_mask_value(13, false)
	visual_radius_of_exsplosion.get_active_material(0).albedo_color = Color(1, 1, 1, 1)
	
	life_timer.start(0.1)


func on_life_timer_timeout() -> void:
	queue_free()


func _on_explosion_timer_timeout() -> void:
	await pre_explosion()
	do_explosion()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BasicEnemy:
		if !explosion:
			do_explosion()
			explosion_timer.stop()
			if body.get_damage(global_position, damage, push_power, 0, acid_dmg):
				PlayerParameters.add_skill_exp(skill_id, damage)
		elif body.get_damage(global_position, damage, push_power, 0, acid_dmg):
			PlayerParameters.add_skill_exp(skill_id, damage)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is BasicEnemy:
		body.get_damage(global_position, acid_dmg, push_power, 0, acid_dmg)
		PlayerParameters.add_skill_exp(skill_id, acid_dmg * 4)
