class_name StatsComponent extends Node3D

@export var owner_node: CharacterBody3D

@export var max_value: float
@export var current_value: float
@export var regen: float

func minus(value: float) -> bool:
	return false

func plus(value: float) -> bool:
	if current_value == max_value:
		return false
	current_value = min(max_value, current_value + value)
	return true
