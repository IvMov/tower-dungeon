extends Node3D

var direction: Vector3
var speed: float = 20

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
	set_scale(Vector3.ONE*2)
	mesh_instance_3d.mesh.material.albedo_color = Color.WHITE
	if body is BasicEnemy:
		body.get_damage()
		queue_free()


func on_life_timer_timeout():
	queue_free()
