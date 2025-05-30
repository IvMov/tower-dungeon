class_name EntryMap extends Node3D

@onready var items: Node3D = $Items
@onready var exit_from_shop: Node3D = $Walls/ExitFromShop

@onready var right: Node3D = $MetaUpgrades/Right
@onready var left: Node3D = $MetaUpgrades/Left

var upgrade_position: Vector3 = Vector3(-4, 0.4, 18)
var upgrade_step: float = 4.0

func _ready() -> void:
	exit_from_shop.is_traider = false
	GameEvents.item_to_map.connect(on_item_to_map)
	for id in MetaProgression.upgrade_pool:
		add_upgrade(MetaProgression.upgrade_pool[id])

func add_upgrade(upgrade: MetaUpgrade) -> void:
	var inst = Constants.META_UPGRADE_VIEW.instantiate()
	if upgrade_position == Vector3(-4, 0.4, -18):
		upgrade_position = Vector3(4, 0.4, 18)
	if upgrade_position.x == -4:
		left.add_child(inst)
	else:
		right.add_child(inst)
	inst.init(upgrade, upgrade_position)
	upgrade_position.z -= upgrade_step
	inst.prepare_view()

func on_item_to_map(to: Vector3, item: PackedScene): 
	var instance: Node3D = item.instantiate();
	instance.rotate_y(randf_range(-PI, PI))
	items.add_child(instance)
	instance.global_position = to
