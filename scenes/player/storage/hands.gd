class_name Hands extends Storage


func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	GameEvents.item_consumed.connect(on_item_consumed)
	id = 3


func on_item_consumed(hand: int, item_id: int):
	var coord: Vector3 = Vector3(3,0, hand)
	remove(coord, 1)
	GameEvents.emit_item_update_hand_view(hand)
