class_name StoneProjectile extends Node3D

const RAND: float = 0.1
var direction: Vector3
var speed: float
var damage: float
var skill_name: String
var push_power: float
var is_falling: bool

@onready var gravity_bitch: Timer = $GravityBitch

@onready var life_timer: Timer = $LifeTimer

@onready var area_3d: Area3D = $MeshInstance3D/Area3D

@onready var stone: MeshInstance3D = $MeshInstance3D

@onready var projectile_particles: GPUParticles3D = $ProjectileParticles

@onready var collision_particles: GPUParticles3D = $CollisionParticles

func _ready() -> void:
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true
	

func _physics_process(delta) -> void:
	if direction != Vector3.ZERO:
		direction.y = direction.y - delta * speed / 40
	translate(speed * direction * delta)


func on_body_entered(body: Node3D) -> void:
	handleb_body_collision(body)
	if body is BasicEnemy:
		if body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_name, damage)
	

func handleb_body_collision(body: Node3D) -> void:
	print(body.collision_layer)
	if is_falling || body.get_collision_layer_value(2):
		speed = 0
		direction = Vector3.ZERO
		life_timer.wait_time = RAND
		life_timer.start()
		collision_particles.emitting = true
	else:
		is_falling = true
		collision_particles.emitting = true
		direction = Vector3.DOWN
		speed = 6
	

	
func on_life_timer_timeout() -> void:
	stone.visible = false
	var item: ItemBulk = ItemBulk.new(Constants.ITEM_STONE, 1)
	global_position =global_position + Vector3(randf_range(-RAND, RAND), RAND/2, randf_range(-RAND, RAND))
	GameEvents.emit_item_add(Vector3(2, global_position.x, global_position.z), item, global_position)
	queue_free()
