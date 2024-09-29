class_name Storage extends Node

# x - 0 means inventory, 1 - belt, 3 - hands
var id: int
#x - rows, y - columns
var size: Vector2

# key - vector2 (coordinates)
# value - item (with quantity!)
var items: Dictionary


func reset() -> void:
	items.clear()

func add(key: Vector2, item_bulk: ItemBulk) -> void:
	if items.has(key):
		items.get(key).quantity += item_bulk.quantity
	else:
		items[key] = item_bulk

func remove(key: Vector2,  quantity: int) -> void: 
	if items.has(key) && items.get(key).quantity < quantity:
		items.get(key).quantity -= quantity
		if items.get(key).quantity <=0:
			items.erase(key)	
	else:
		items.erase(key)

func on_item_add(to: Vector3, item_bulk: ItemBulk):
	if to.x == id:
		var key: Vector2 = Vector2(to.y, to.z)
		add(key, item_bulk)

func on_item_remove(from: Vector3, quantity: int):
	if from.x == id:
		var key: Vector2 = Vector2(from.y, from.z)
		remove(key, quantity)
