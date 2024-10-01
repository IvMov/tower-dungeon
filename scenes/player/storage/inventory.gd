class_name Inventory extends Storage

const SPARK_TABLET = preload("res://resources/items/spark_tablet.tres")
#@export var spark_tablet: Item
@export var zoom_in_tablet: Item

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	id = 0
	size = Vector2(3, 4)
	var item_bulk: ItemBulk = ItemBulk.new(SPARK_TABLET, 1)
	var item_bulk2: ItemBulk = ItemBulk.new(zoom_in_tablet, 1)
	items[Vector2(0,0)] = item_bulk
	items[Vector2(0,1)] = item_bulk2

func add(key: Vector3, item_bulk: ItemBulk) -> void:
	super.add(key, item_bulk)
	emit_item_added(Vector2(key.y, key.z))
