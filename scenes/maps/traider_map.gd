extends Node3D

@onready var items: Node3D = $Items

func _ready() -> void:
	GameEvents.emit_new_stage()
	
func on_item_to_map(to: Vector3, item: PackedScene): 
	var instance: Node3D = item.instantiate();
	instance.rotate_y(randf_range(-PI, PI))
	items.add_child(instance)
	instance.global_position = to
