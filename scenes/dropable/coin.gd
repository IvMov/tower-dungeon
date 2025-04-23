class_name Coin extends Node3D

@onready var timer: Timer = $Timer

var speed: float = randf_range(8, 14)
var direction: Vector3

func _physics_process(delta: float) -> void:
	global_translate(direction * speed * delta)

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
