class_name FireProjectile extends Node3D


@onready var life_timer: Timer = $LifeTimer
@onready var projectile_particles: GPUParticles3D = $ProjectileParticles
@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_particles: GPUParticles3D = $CollisionParticles

var direction: Vector3
var speed: float
var damage: float

func _ready() -> void:
	damage = 15
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true
	

func _physics_process(delta) -> void:
	translate(direction * speed * delta)
	if direction != Vector3.ZERO:
		# Create a new transform looking in the direction of movement
		var look_at_point = global_transform.origin + direction
		var new_transform = global_transform.looking_at(look_at_point, Vector3.UP)


func on_body_entered(body: Node3D) -> void:
	handleb_body_collision()
	if body is BasicEnemy:
		body.get_damage(global_position, damage, 0)
	

func handleb_body_collision() -> void:
	speed = 0
	collision_particles.emitting = true	
	mesh_instance_3d.visible = false
	life_timer.wait_time = 0.3
	life_timer.start()

	
func on_life_timer_timeout() -> void:
	queue_free()
