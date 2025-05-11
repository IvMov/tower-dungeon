class_name Storage extends Node

const STORAGES_NAMES_BY_ID :Dictionary[int, String] = {0: "inventory", 1: "belt", 2: "map", 3: "hands"}

var id: int
#x - rows, y - columns
var size: Vector2

# key - vector2 (coordinates)
# value - item (with quantity!)
var items: Dictionary


func reset() -> void:
	items.clear()

func load_storage(data: Dictionary) -> void:
	id = data["id"]
	size = data["size"]
	items = load_items(data)

func load_items(data: Dictionary) -> Dictionary:
	var result: Dictionary[Vector2, ItemBulk]
	for item_coord in data["items"]:
		var item: Item = Constants.items_pool[data["items"][item_coord]["id"]]
		var item_bulk: ItemBulk = ItemBulk.new(item, data["items"][item_coord]["quantity"])
		result.set(item_coord, item_bulk)
	return result


func save_storage(player_data: Dictionary, storage_name) -> void:
	PlayerParameters.player_data[MetaProgression.STORAGES_KEY][storage_name]["id"] = id
	PlayerParameters.player_data[MetaProgression.STORAGES_KEY][storage_name]["size"] = size
	var items_save: Dictionary = {}
	for coord in items:
		var item_obj: Dictionary = {
			"id" : items[coord].item.id,
			"quantity": items[coord].quantity
		}
		items_save.set(coord, item_obj)
		
	PlayerParameters.player_data[MetaProgression.STORAGES_KEY][storage_name]["items"] = items_save
	

func add(key: Vector3, item_bulk: ItemBulk) -> void:
	var key_2d: Vector2 = Vector2(key.y, key.z)
	if items.has(key_2d):
		items.get(key_2d).quantity += item_bulk.quantity
	else:
		items[key_2d] = item_bulk
	GameEvents.emit_redraw_item(key)

func remove(key: Vector3,  quantity: int) -> void: 
	var key_2d: Vector2 = Vector2(key.y, key.z)
	if items.has(key_2d) && items.get(key_2d).quantity > quantity:
		items.get(key_2d).quantity -= quantity
	elif items.has(key_2d) && quantity == items.get(key_2d).quantity:
		items.erase(key_2d)
		GameEvents.emit_item_from_storage(key)
	GameEvents.emit_redraw_item(key)

func find_location_by_id(item_id: int) -> Vector3:
	for key in items.keys():
		if items.get(key).item.id == item_id:
			return Vector3(id, key.x, key.y)
	return Vector3(-1, -1, -1)

func on_item_add(to: Vector3, item_bulk: ItemBulk, _map_pos: Vector3):
	if to.x == id:
		add(to, item_bulk)

func on_item_remove(from: Vector3, quantity: int):
	if from.x == id:
		remove(from, quantity)
