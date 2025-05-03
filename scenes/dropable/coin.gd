class_name Coin extends Node3D

@onready var timer: Timer = $Timer
@onready var area_3d: Area3D = $MeshInstance3D/Area3D

var speed: float = randf_range(8, 14)
var direction: Vector3

func _physics_process(delta: float) -> void:
	global_translate(direction * speed * delta)
	
func set_disabled() -> void:
	area_3d.set_collision_mask_value(8, false)
	timer.stop()

func collect() -> void:
	direction = (PlayerParameters.get_position(0.5) - global_position).normalized()
	timer.start()

func _on_timer_timeout() -> void:
	speed = min(speed+2, 25)
	direction = (PlayerParameters.get_position(0.5) - global_position).normalized()

#emited artificially from another area which find this area
func _on_area_3d_area_entered(area: Area3D) -> void:
	PlayerParameters.add_coin()
	queue_free()
