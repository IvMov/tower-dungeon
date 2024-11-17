class_name Inventory extends Storage

const SPARK_TABLET = preload("res://resources/items/spark_tablet.tres")
const STONE = preload("res://resources/items/stone.tres")
#@export var spark_tablet: Item
@export var zoom_in_tablet: Item

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	id = 0
	size = Vector2(4, 3)
	#var item_bulk: ItemBulk = ItemBulk.new(SPARK_TABLET, 1)
	#var item_bulk2: ItemBulk = ItemBulk.new(zoom_in_tablet, 1)
	#var item_bulk3: ItemBulk = ItemBulk.new(zoom_in_tablet, 1)
	var item_bulkkk: ItemBulk = ItemBulk.new(STONE, 3)
	#items[Vector2(0,0)] = item_bulk3
	#items[Vector2(1,0)] = item_bulk2
	#items[Vector2(2,0)] = item_bulk2
	items[Vector2(0,1)] = item_bulkkk

func add(key: Vector3, item_bulk: ItemBulk) -> void:
	var key_2d: Vector2 = Vector2(key.y, key.z)
	var item_id: int = item_bulk.item.id
	
	if items.has(key_2d):
		if items.get(key_2d).item.id == item_id:
			items.get(key_2d).quantity += item_bulk.quantity
			GameEvents.emit_item_added(key)
		else:
			var slot: Vector2 =  calc_slot(key_2d, item_id)
			if slot == key_2d:
				GameEvents.emit_cant_pick_item()
				print("NO PLACE IN INVENTORY, sorry!!")
			else: 
				add(Vector3(0, slot.x, slot.y), item_bulk)
	else:
		items[key_2d] = item_bulk
		GameEvents.emit_item_added(key)

func calc_slot(key: Vector2, item_id: int) -> Vector2:
	for i in size.x:
		for j in size.y:
			var slot: Vector2 = Vector2(i, j)
			if !items.has(slot) || items.get(slot).item.id == item_id: 
				return slot
	return key
