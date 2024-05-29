extends Node3D
class_name PlayerSmallCharge

var direction: Vector3
var speed: float = 20
var damage: float = 1.0

@onready var life_timer = $LifeTimer

@onready var area_3d = $MeshInstance3D/Area3D
@onready var mesh_instance_3d = $MeshInstance3D

func _ready():
	area_3d.body_entered.connect(on_body_entered)
	life_timer.timeout.connect(on_life_timer_timeout)

func _physics_process(delta):
	translate(direction * speed * delta)


func on_body_entered(body: Node3D):
	speed = 0
	if body is BasicEnemy:
		body.get_damage(damage)
		queue_free()


func on_life_timer_timeout():
	queue_free()
