class_name MapStorage extends Storage

const RAND: float = 0.2
var cache_item: Node3D

func _ready() -> void:
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	GameEvents.item_from_map.connect(on_item_from_map)
	GameEvents.item_added.connect(on_item_added)
	GameEvents.cant_pick_item.connect(on_cant_pick_item)
	id = 2

#override to save 3d coordinates
func add(key: Vector3, item_bulk: ItemBulk) -> void:
	
	if items.has(key):
		items.get(key).quantity += item_bulk.quantity
	else:
		items[key] = item_bulk
	GameEvents.emit_item_to_map(key, item_bulk.item.scene)

func on_item_add(to: Vector3, item_bulk: ItemBulk, map_pos: Vector3):
	if to.x == id:
		if map_pos == Vector3.ZERO:
			var key: Vector3 = PlayerParameters.get_position()
			key = key + Vector3(randf_range(-RAND, RAND), RAND, randf_range(-RAND, RAND))
			add(key, item_bulk)
		else:
			add(map_pos, item_bulk)

func on_item_from_map(item: Node3D):
	var from: Vector3 = item.global_position
	if items.has(from):
		cache_item = item
		GameEvents.emit_item_add(Vector3(0, 0, 0), items.get(from))
	else:
		item.queue_free()

func on_item_added(_to: Vector3):
	if cache_item:
		items.erase(cache_item.global_position)
		cache_item.queue_free()
		cache_item = null


func on_cant_pick_item():
	cache_item = null
