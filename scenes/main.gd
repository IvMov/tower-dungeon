extends Node

@onready var label = $UIWrapper/Label
@onready var map_generator: MapGenerator = $MapGenerator

func _ready():
	map_generator.generate_level()

func _physics_process(_delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()
