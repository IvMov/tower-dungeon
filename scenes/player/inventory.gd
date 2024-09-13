class_name Inventory extends Node3D

@export var player: Player
@export var spark_tablet: Item
const WIDTH: int = 2
const HEIGHT: int = 5

# key - vector2 (coordinates)
# value - properties: 
# quantity - int
# item - Item
var items: Dictionary


func _ready():
	items[Vector2(0,0)] = {
		"quantity": 1,
		"item" : spark_tablet
	}
