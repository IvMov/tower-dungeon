class_name SoulPart extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var timer: Timer = $Timer

#need to be setted to distinguish soul type will be collected
@export var soul_type: Enums.SoulType
@export var color: Color

var speed: float = randf_range(8, 14)
var direction: Vector3

var spread: float = randf_range(2, 4)


func _physics_process(delta: float) -> void:
	global_translate(direction * speed * delta)

func set_color(color: Color) -> void:
	mesh_instance_3d.get_active_material(0).albedo_color = color

func collect() -> void:
	var target: Vector3 = global_position
	target.x += randf_range(-spread, spread)
	target.y += randf_range(0, spread* 2)
	target.x += randf_range(-spread, spread)
	direction = (target - global_position).normalized()
	timer.start()

func _on_timer_timeout() -> void:
	speed = min(speed+2, 25)
	timer.wait_time = max(timer.wait_time - 0.03, 0.15)
	direction = (PlayerParameters.get_position(0.5) - global_position).normalized()

#emited artificially from another area which find this area
func _on_area_3d_area_entered(area: Area3D) -> void:
	PlayerParameters.add_soul(soul_type)
	queue_free()
