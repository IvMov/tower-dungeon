class_name StoneProjectile extends Node3D

var direction: Vector3
var speed: float
var damage: float
var skill_name: String
var push_power: float
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
		direction.y = direction.y - delta * speed / 30
	translate(direction * speed * delta)


func on_body_entered(body: Node3D) -> void:
	handleb_body_collision()
	if body is BasicEnemy:
		if body.get_damage(global_position, damage, push_power):
			PlayerParameters.add_skill_exp(skill_name, damage)
	

func handleb_body_collision() -> void:
	speed = 0
	collision_particles.emitting = true	
	stone.visible = false
	life_timer.wait_time = 0.5
	life_timer.start()

	
func on_life_timer_timeout() -> void:
	queue_free()
