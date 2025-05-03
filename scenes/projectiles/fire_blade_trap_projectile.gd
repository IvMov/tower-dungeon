class_name FireBladeTrapProjectile extends RigidBody3D

const RAND: float = 0.05
var rotation_speed: int = 4
var fire_dmg: float 
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

@onready var fire_blade_base: MeshInstance3D = $FireBladeBase

@onready var blade: MeshInstance3D = $Blade
@onready var area_3d: Area3D = $Blade/Area3D
@onready var collision_shape_3d: CollisionShape3D = $Blade/Area3D/CollisionShape3D

@onready var life_timer: Timer = $LifeTimer
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2
@onready var collision_particles: GPUParticles3D = $Blade/CollisionParticles



func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func set_disabled() -> void: 
	life_timer.stop()
	explosion_timer.stop()
	collision_particles.emitting = false
	projectile_particles.emitting = false
	set_collision_layer_value(1, true)

func do_explosion() -> void:
	if explosion:
		return
	explosion = true
	blade.visible = true
	area_3d.set_collision_mask_value(11, true)
	area_3d.set_collision_mask_value(13, true)

	#blade.get_active_material(0).albedo_color = Color(2, 2, 2, 0.2)
	var tween: Tween = create_tween()
	collision_particles.emitting = true
	tween.set_parallel()
	
	tween.tween_property(blade.mesh, "height", radius*2, 0.2)
	tween.tween_property(blade.mesh, "bottom_radius", 0.05, 0.2)
	tween.tween_property(blade.mesh, "top_radius", 0.05, 0.2)
	tween.tween_property(collision_shape_3d.shape, "height", radius*2.1, 0.2)
	tween.tween_property(blade.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 0.1, 0.2)
	#
	tween.chain()
	tween.tween_property(blade.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 2, 2)
	tween.tween_property(blade, "global_rotation:y", rotation_speed * TAU, 2)
	tween.chain()
	tween.tween_property(blade, "global_rotation:y", rotation_speed * TAU, 2)
	tween.tween_property(blade.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 0.1, 2)
	tween.chain()
	tween.tween_property(blade.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 6, 2)
	tween.tween_property(blade.mesh, "height", 0.1, 2)
	tween.tween_property(blade.mesh, "bottom_radius", 0.02, 0.1)
	tween.tween_property(blade.mesh, "top_radius", 0.02, 0.1)
	tween.tween_property(blade, "global_rotation:y", -rotation_speed * 2 * TAU, 2)
	tween.tween_property(collision_shape_3d.shape, "height", 0.1, 2)
	tween.tween_property(blade.mesh.surface_get_material(0), "uv1_scale", Vector3.ONE * 1, 2)
	
	await tween.finished
	
	blade.visible = false
	area_3d.set_collision_mask_value(11, false)
	area_3d.set_collision_mask_value(14, false)
	area_3d.set_collision_mask_value(13, false)
	life_timer.start(0.1)
	collision_particles.emitting = false
	pass


func on_life_timer_timeout() -> void:
	queue_free()


func _on_explosion_timer_timeout() -> void:
	do_explosion()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BasicEnemy:
		if !explosion:
			do_explosion()
			explosion_timer.stop()
			if body.get_damage(global_position, damage, push_power, fire_dmg):
				PlayerParameters.add_skill_exp(skill_id, damage)
		elif body.get_damage(global_position, damage, push_power, fire_dmg):
			PlayerParameters.add_skill_exp(skill_id, damage)
