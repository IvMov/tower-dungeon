class_name ItemView extends TextureRect

@onready var quantity_label: Label = $MarginContainer/Quantity

var item: Item
var quantity: int

func _ready() -> void:
	texture = item.image
	quantity_label.text = str(quantity)
	expand_mode = 1
