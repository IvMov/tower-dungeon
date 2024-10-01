class_name  MapStorage extends Storage

const RAND: float = 0.2

func _ready() -> void:
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	GameEvents.item_from_map.connect(on_item_from_map)
	id = 2

#override to save 3d coordinates
func add(_key: Vector3, item_bulk: ItemBulk) -> void:
	var key_3d: Vector3 = get_tree().get_first_node_in_group("player").global_position
	key_3d = key_3d + Vector3(randf_range(-RAND, RAND), RAND, randf_range(-RAND, RAND))
	if items.has(key_3d):
		items.get(key_3d).quantity += item_bulk.quantity
	else:
		items[key_3d] = item_bulk
	GameEvents.emit_item_to_map(key_3d, item_bulk.item.scene)


func on_item_from_map(from: Vector3):
	if items.has(from):
		GameEvents.emit_item_add(Vector3(0, 1, 1), items.get(from))
		items.erase(from)
