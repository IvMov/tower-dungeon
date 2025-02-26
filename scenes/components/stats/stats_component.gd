class_name StatsComponent extends Node3D

signal max_value_changed(value:float)

@export var owner_node: CharacterBody3D

@export var max_value: float
@export var current_value: float
@export var regen: float

@onready var regen_timer = $RegenTimer

var can_regen: bool = false

func minus(_value: float) -> bool:
	return false

func plus(value: float) -> bool:
	if current_value == max_value:
		return false
	current_value = min(max_value, current_value + value)
	return true

func run_regen() -> void:
	if can_regen && regen_timer.is_stopped() && regen > 0 && max_value > current_value:
		plus(regen)
		regen_timer.start()

func _on_regen_timer_timeout() -> void:
	if !owner_node.is_dying:
		run_regen()
	
func emit_max_value_changed(_value: float) -> void:
	max_value_changed.emit()
