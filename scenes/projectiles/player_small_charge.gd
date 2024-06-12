extends Node3D
class_name PlayerSmallCharge

var direction: Vector3
var speed: float = 15 #looks good to appgreid speed of projectile up to 30 ? 
var damage: float = 1.0 

@onready var life_timer = $LifeTimer

@onready var area_3d = $MeshInstance3D/Area3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var projectile_particles = $ProjectileParticles

@onready var collision_particles = $CollisionParticles

func _ready():
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)
	projectile_particles.emitting = true

func _physics_process(delta):
	translate(direction * speed * delta)


func on_body_entered(body: Node3D):
	handleb_body_collision()
	if body is BasicEnemy:
		body.get_damage(damage)
	

func handleb_body_collision():
	speed = 0
	collision_particles.emitting = true	
	mesh_instance_3d.visible = false
	life_timer.wait_time = 0.5
	life_timer.start()

	
func on_life_timer_timeout():
	queue_free()
