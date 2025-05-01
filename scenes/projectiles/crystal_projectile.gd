class_name CrystalProjectile extends Node3D

const CRYSTAL_SIZE: Vector3 = Vector3(0.2, 0.3, 0.1)
const CRYSTAL_COLOR_STABLE: Color = Color(0.46, 2.0, 2.0)
const CRYSTAL_COLOR_UNSTABLE: Color = Color(2.0, 0.2, 0.4)
const RAND: float = 0.05


var direction: Vector3
var speed: float
var damage: float
var skill_id: int
var push_power: float
var explosion: bool = false
#radius of explosion
var radius: float
#how long one ping before explosion lasts (0.2 to 0.1)
var before_explosion_time_unit: float


@onready var area_3d: Area3D = $Crystal/Area3D
@onready var crystal: MeshInstance3D = $Crystal
@onready var life_timer: Timer = $LifeTimer
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var collision_particles: GPUParticles3D = $CollisionParticles
@onready var collision_shape_3d: CollisionShape3D = $Crystal/Area3D/CollisionShape3D
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2
@onready var visual_radius_of_exsplosion: MeshInstance3D = $VisualRadiusOfExsplosion


func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func pre_explosion() -> void:
	crystal.get_active_material(0).albedo_color = CRYSTAL_COLOR_UNSTABLE
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	visual_radius_of_exsplosion.visible = true
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE*2, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius*0.75, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius*1.5, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(crystal.mesh, "size",CRYSTAL_SIZE, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", 0.1, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", 0.2, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE*3, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius*2, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", 0.1, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", 0.2, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE*3, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius*2, before_explosion_time_unit)
	tween.chain()
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", 0.1, before_explosion_time_unit)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", 0.2, before_explosion_time_unit)

	await tween.finished

func do_explosion() -> void:
	explosion = true
	collision_particles.emitting = true
	area_3d.set_collision_mask_value(11, true)
	area_3d.set_collision_mask_value(13, true)
	area_3d.set_collision_mask_value(14, true)
	
	visual_radius_of_exsplosion.get_active_material(0).albedo_color = Color(1, 0, 0, 0.02)
	var tween: Tween = create_tween()
	tween.set_parallel().set_ease(Tween.EASE_IN)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "radius", radius, 0.3)
	tween.tween_property(visual_radius_of_exsplosion.mesh, "height", radius * 2, 0.3)
	tween.tween_property(collision_shape_3d.shape, "radius", radius, 0.3)
	tween.chain()
	tween.tween_property(crystal.mesh, "size", CRYSTAL_SIZE, 0.1)
	tween.tween_property(collision_shape_3d.shape, "radius", 0.3, 0.1)
	await tween.finished
	
	visual_radius_of_exsplosion.visible = false
	area_3d.set_collision_mask_value(11, false)
	area_3d.set_collision_mask_value(14, false)
	area_3d.set_collision_mask_value(13, false)
	crystal.get_active_material(0).albedo_color = CRYSTAL_COLOR_STABLE



func on_life_timer_timeout() -> void:
	var item: ItemBulk = ItemBulk.new(Constants.get_item_by_id(Constants.ITEM_CRYSTAL_ID), 1)
	global_position = global_position + Vector3(randf_range(-RAND, RAND), 0, randf_range(-RAND, RAND))
	global_position.y = RAND
	GameEvents.emit_item_add(Vector3(2, global_position.x, global_position.z), item, global_position)
	queue_free()


func _on_explosion_timer_timeout() -> void:
	await pre_explosion()
	do_explosion()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BasicEnemy:
		if !explosion:
			do_explosion()
			explosion_timer.stop()
			body.get_damage(global_position, damage, push_power)
		elif body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_id, damage)
