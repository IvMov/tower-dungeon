class_name Belt extends Storage

const SPARK_TABLET: Item = preload("res://resources/items/spark_tablet.tres")

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	id = 1
	size = Vector2(0, 5) # x always 0 - for belt (1 row)
	var item_bulk: ItemBulk = ItemBulk.new(SPARK_TABLET, 1)
	items[Vector2(0,1)] = item_bulk
	var item_bulk2: ItemBulk = ItemBulk.new(SPARK_TABLET, 1)
	items[Vector2(0,3)] = item_bulk2
	var item_bulk3: ItemBulk = ItemBulk.new(Constants.ITEM_CRYSTAL, 50)
	items[Vector2(0,0)] = item_bulk3
	var item_bulk4: ItemBulk = ItemBulk.new(Constants.ITEM_SNOWBALL_TABLET, 1)
	items[Vector2(0,4)] = item_bulk4
