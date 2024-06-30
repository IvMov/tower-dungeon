class_name SparkProjectile extends Node3D

var direction: Vector3
var speed: float
var damage: float
var skill_name: String

@onready var life_timer: Timer = $LifeTimer

@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles

@onready var collision_particles: GPUParticles3D = $CollisionParticles

func _ready() -> void:
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func _physics_process(delta) -> void:
	translate(direction * speed * delta)


func on_body_entered(body: Node3D) -> void:
	handleb_body_collision()
	if body is BasicEnemy:
		if body.get_damage(damage):
			PlayerParameters.add_skill_exp(skill_name, damage)
	

func handleb_body_collision() -> void:
	speed = 0
	collision_particles.emitting = true	
	mesh_instance_3d.visible = false
	life_timer.wait_time = 0.5
	life_timer.start()

	
func on_life_timer_timeout() -> void:
	queue_free()
