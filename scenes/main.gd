extends Node

@onready var label = $UIWrapper/Label
@onready var map_generator: MapGenerator = $MapGenerator
@onready var inventory_screen: InventoryScreen = $UIWrapper/InventoryScreen

func _ready():
	map_generator.generate_level()
	inventory_screen.draw_inventory()

func _physics_process(_delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()


