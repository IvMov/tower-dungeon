class_name ItemBulk extends Node

var quantity: int
var item: Item

func _init(new_item: Item, new_quantity: int) -> void:
	self.quantity = new_quantity
	self.item = new_item
