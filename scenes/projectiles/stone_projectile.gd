class_name StoneProjectile extends RigidBody3D

const RAND: float = 0.5
var direction: Vector3
var speed: float
var damage: float
var skill_id: int
var push_power: float

@onready var life_timer: Timer = $LifeTimer
@onready var stone: MeshInstance3D = $Stone
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var collision_particles: GPUParticles3D = $CollisionParticles

func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

	
func on_life_timer_timeout() -> void:
	stone.visible = false
	var item: ItemBulk = ItemBulk.new(Constants.ITEM_STONE, 1)
	global_position = global_position + Vector3(randf_range(-RAND, RAND), 0, randf_range(-RAND, RAND))
	GameEvents.emit_item_add(Vector3(2, global_position.x, global_position.z), item, global_position)
	queue_free()


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	collision_particles.emitting = true
	life_timer.wait_time = 1
	life_timer.start()
	if body is BasicEnemy:
		if body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_id, damage)
	
	
