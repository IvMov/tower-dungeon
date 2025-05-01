class_name EntryMap extends Node3D

@onready var left: Node3D = $MetaUpgrades/Left
const FIRE_BLADE_TRAP_META_UPGRADE = preload("res://resources/upgrades/fire_blade_trap_meta_upgrade.tres")
var upgrade_position: Vector3 = Vector3(-4, 0.4, -18)
var upgrade_step: float = 8.0

func _ready() -> void:
	add_new()
	add_new()
	add_new()
	add_new()
	

func add_new() -> void:
	var test = Constants.META_UPGRADE_VIEW.instantiate()
	left.add_child(test)
	test.upgrade = FIRE_BLADE_TRAP_META_UPGRADE
	test.global_position = upgrade_position
	upgrade_position.z += upgrade_step
	test.prepare_view()
	
