extends Node
@onready var timer = $Timer

@export var enemy: PackedScene

func _on_timer_timeout():
	var inst = enemy.instantiate()
	add_child(inst)
	inst.global_position = Vector3(randf_range(0,20)*get_sign(), 10, randf_range(0,20) * get_sign())


func get_sign() -> int:
	return -1 if randf() <0.5 else 1
