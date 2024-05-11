extends Node3D

var direction: Vector3
var speed: float = 5
@onready var area_3d = $MeshInstance3D/Area3D

func _ready():
	area_3d.body_entered.connect(on_body_entered)

func _physics_process(delta):
	translate(direction * speed * delta)


func on_area_entered(area: Area3D):
	print("collision")
	queue_free()
	

func on_body_entered(body: Node3D):
	print(body)
	
	queue_free()
