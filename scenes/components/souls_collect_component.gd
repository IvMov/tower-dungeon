class_name SoulsCollectComponent extends Node3D

@export var player: Player

func _ready():
	GameEvents.souls_collect.connect(on_souls_collect)

func on_souls_collect(_location: Vector3, value: Vector3) -> void:
	player.soul_component.plus(value)
