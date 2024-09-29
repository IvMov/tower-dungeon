class_name ItemBulk extends Node

var quantity: int
var item: Item

func _init(item: Item, quantity: int) -> void:
	self.quantity = quantity
	self.item = item
