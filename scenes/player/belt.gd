class_name Belt extends Storage

@export var spark_tablet: Item

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	id = 1
	size = Vector2(0, 5) # x always 0 - for belt (1 row)
	var item_bulk: ItemBulk = ItemBulk.new(spark_tablet, 20)
	items[Vector2(0,1)] = item_bulk
	var item_bulk2: ItemBulk = ItemBulk.new(spark_tablet, 3)
	items[Vector2(0,3)] = item_bulk2
