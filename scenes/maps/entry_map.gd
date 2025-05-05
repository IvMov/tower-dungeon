class_name EntryMap extends Node3D

@onready var left: Node3D = $MetaUpgrades/Left
var upgrade_position: Vector3 = Vector3(-4, 0.4, -18)
var upgrade_step: float = 5.0

func _ready() -> void:
	for id in MetaProgression.upgrade_pool:
		add_upgrade(MetaProgression.upgrade_pool[id])

func add_upgrade(upgrade: MetaUpgrade) -> void:
	var inst = Constants.META_UPGRADE_VIEW.instantiate()
	left.add_child(inst)
	inst.init(upgrade, upgrade_position)
	upgrade_position.z += upgrade_step
	inst.prepare_view()
	
