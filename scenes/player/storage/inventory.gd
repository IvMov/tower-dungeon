class_name Inventory extends Storage

const NAME: String = "inventory"

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	var data: Dictionary = PlayerParameters.player_data[MetaProgression.STORAGES_KEY]["inventory"]
	load_storage(data)

func save_storage(player_data: Dictionary, storage_name: String) -> void:
	#var item_bulk2: ItemBulk = ItemBulk.new(Constants.get_item_by_id(Constants.ITEM_SPEED_ID), 10)
	#var item_bulk3: ItemBulk = ItemBulk.new(Constants.get_item_by_id(Constants.ITEM_DAMAGE_ID), 5)
	#var item_bulk4: ItemBulk = ItemBulk.new(Constants.get_item_by_id(Constants.ITEM_SPARK_ID), 1)
#
	#items[Vector2(1,0)] = item_bulk2
	#items[Vector2(1,1)] = item_bulk3
	#items[Vector2(1,2)] = item_bulk4
	super.save_storage(player_data, storage_name)


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
				print("EXCEPTION: NO PLACE IN INVENTORY, sorry!!")
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
