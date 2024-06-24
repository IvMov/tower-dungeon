extends Node
@onready var timer = $Timer

@export var enemy: PackedScene
@onready var label = $CanvasLayer/Label
@onready var enemies = $Enemies

func _physics_process(delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()

func _on_timer_timeout():
	var inst = enemy.instantiate()
	enemies.add_child(inst)
	inst.global_position = Vector3(randf_range(0,20)*get_sign(), 10, randf_range(0,20) * get_sign())


func get_sign() -> int:
	return -1 if randf() <0.5 else 1
