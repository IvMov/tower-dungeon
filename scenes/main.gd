extends Node

const SHOP_MAP: PackedScene = preload("res://scenes/maps/shop_map.tscn")

@onready var label = $UIWrapper/Label
@onready var map_generator: MapGenerator = $MapGenerator
@onready var maps: Node3D = $Maps
@onready var player: Player = $Player
@onready var enemies: Node3D = $Enemies

const PLAYER_START_POINT: Vector3 = Vector3(1, 0.2, -1)

func _ready():
	#map_generator.ROOMS = randi_range(3, 10)
	var start_point: Vector3 = map_generator.generate_level()
	player.global_position = start_point
	GameEvents.from_stage_to_shop.connect(on_from_stage_to_shop)
	GameEvents.from_shop_to_stage.connect(on_from_shop_to_stage)

func _physics_process(_delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()

func on_from_stage_to_shop():
	maps.get_child(0).queue_free()
	for enemy in enemies.get_children(): 
		enemy.queue_free()
	var shop: Node3D = SHOP_MAP.instantiate()
	maps.add_child(shop)
	player.global_position = PLAYER_START_POINT

func on_from_shop_to_stage():
	maps.get_child(0).queue_free()
	
	map_generator.reset()
	#map_generator.ROOMS = randi_range(3, 10)
	var start_point: Vector3 = map_generator.generate_level()
	player.global_position = start_point
