class_name Hands extends Storage


func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	id = 3
