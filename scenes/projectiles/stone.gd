extends Node3D

var direction: Vector3
var speed: float = 10
@onready var area_3d = $MeshInstance3D/Area3D
@onready var mesh_instance_3d = $MeshInstance3D

func _ready():
	area_3d.body_entered.connect(on_body_entered)

func _physics_process(delta):
	translate(direction * speed * delta)


func on_body_entered(body: Node3D):
	speed = 0
	set_scale(Vector3.ONE*3)
	mesh_instance_3d.mesh.material.albedo_color = Color.WHITE
	#queue_free()
