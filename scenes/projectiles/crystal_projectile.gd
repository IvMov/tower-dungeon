class_name CrystalProjectile extends Node3D


const RAND: float = 0.05
var direction: Vector3
var speed: float
var damage: float
var skill_id: int
var push_power: float
var explosion: bool = false

@onready var area_3d: Area3D = $Crystal/Area3D
@onready var crystal: MeshInstance3D = $Crystal
@onready var life_timer: Timer = $LifeTimer
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var collision_particles: GPUParticles3D = $CollisionParticles
@onready var collision_shape_3d: CollisionShape3D = $Crystal/Area3D/CollisionShape3D
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2


func _ready() -> void:
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true


func on_body_entered(body: Node3D) -> void:
	if body is BasicEnemy:
		if !explosion:
			do_explosion()
			explosion_timer.stop()
			body.get_damage(global_position, damage, push_power)
		elif body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_id, damage)

func do_explosion() -> void:
	explosion = true
	collision_particles.emitting = true
	area_3d.set_collision_mask_value(11, true)
	var tween: Tween = create_tween()

	tween.tween_property(collision_shape_3d.shape, "radius", 4.0, 0.4)
	tween.tween_property(collision_shape_3d.shape, "radius", 0.3, 0.2)
	await tween.finished
	life_timer.stop()
	on_life_timer_timeout()


func on_life_timer_timeout() -> void:
	var item: ItemBulk = ItemBulk.new(Constants.ITEM_CRYSTAL, 1)
	global_position =global_position + Vector3(randf_range(-RAND, RAND), RAND, randf_range(-RAND, RAND))
	GameEvents.emit_item_add(Vector3(2, global_position.x, global_position.z), item, global_position)
	queue_free()


func _on_explosion_timer_timeout() -> void:
	do_explosion()
