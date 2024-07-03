extends Node3D

@onready var life_timer = $LifeTimer

func _ready() -> void:
	life_timer.timeout.connect(on_life_timer_timeout)



func on_life_timer_timeout() -> void:
	queue_free()
