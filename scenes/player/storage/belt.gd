class_name Belt extends Storage

const NAME: String = "belt"

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	var data: Dictionary = PlayerParameters.player_data[MetaProgression.STORAGES_KEY][NAME]
	load_storage(data)
	if !items.has(Vector2.ZERO):
		var item_bulk2: ItemBulk = ItemBulk.new(Constants.items_pool[Constants.ITEM_FIREBALL_ID], 1)
		items[Vector2.ZERO] = item_bulk2

#test items was loaded to storage on load or save
	#var item_bulk: ItemBulk = ItemBulk.new(Constants.DAMAGE_BOOST_TABLET, 1)
	#items[Vector2(0,1)] = item_bulk
	#var item_bulkk: ItemBulk = ItemBulk.new(Constants.ACID_METEOR_TABLET, 1)
	#items[Vector2(0,2)] = item_bulkk
	#var item_bulk2: ItemBulk = ItemBulk.new(Constants.FIREBALL_TABLET, 1)
	#items[Vector2(0,3)] = item_bulk2
	#var item_bulk3: ItemBulk = ItemBulk.new(Constants.ITEM_CRYSTAL, 50)
	#items[Vector2(0,0)] = item_bulk3
	#var item_bulk4: ItemBulk = ItemBulk.new(Constants.ITEM_SNOWBALL_TABLET, 1)
	#items[Vector2(0,4)] = item_bulk4
	#var item_bulk5: ItemBulk = ItemBulk.new(Constants.FIRE_BLADE_TRAP_TABLET, 1)
	#items[Vector2(0,5)] = item_bulk5

	
