class_name CrystalProjectile extends Node3D


const RAND: float = 0.05
var direction: Vector3
var speed: float
var damage: float
var skill_id: int
var push_power: float
var is_falling: bool

@onready var gravity_bitch: Timer = $GravityBitch
@onready var life_timer: Timer = $LifeTimer
@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var crystal: MeshInstance3D = $MeshInstance3D
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var collision_particles: GPUParticles3D = $CollisionParticles
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/Area3D/CollisionShape3D

func _ready() -> void:
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true
	

func _physics_process(delta) -> void:
	if direction != Vector3.ZERO:
		direction.y = direction.y - delta * speed / 40
	translate(speed * direction * delta)

func rotate_random() -> void:
		mesh_instance_3d.rotate_x(randf_range(-PI, PI))
		mesh_instance_3d.rotate_z(randf_range(-PI, PI))
		mesh_instance_3d.rotate_y(randf_range(-PI, PI))


func on_body_entered(body: Node3D) -> void:

	handleb_body_collision(body)
	if body is BasicEnemy:
		if body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_id, damage)

func handleb_body_collision(body: Node3D) -> void:
	if is_falling || body.get_collision_layer_value(2):
		speed = 0
		direction = Vector3.ZERO
		life_timer.wait_time = 0.1
		life_timer.start()
		gravity_bitch.stop()
	else:
		is_falling = true
		direction = Vector3.DOWN
		speed = 8
	


func on_life_timer_timeout() -> void:
	collision_particles.emitting = true
	area_3d.set_collision_mask_value(11, true)
	var tween: Tween = create_tween()
	
	tween.tween_property(collision_shape_3d.shape, "radius", 3.0, 0.3)
	tween.tween_property(collision_shape_3d.shape, "radius", 0.3, 0.1)
	await tween.finished
	crystal.visible = false
	var item: ItemBulk = ItemBulk.new(Constants.ITEM_CRYSTAL, 1)
	global_position =global_position + Vector3(randf_range(-RAND, RAND), RAND, randf_range(-RAND, RAND))
	GameEvents.emit_item_add(Vector3(2, global_position.x, global_position.z), item, global_position)
	queue_free()


func _on_gravity_bitch_timeout() -> void:
		rotate_random()
