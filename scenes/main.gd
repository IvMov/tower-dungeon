class_name MainScene extends Node

const TRAIDER_MAP: PackedScene = preload("res://scenes/maps/traider_map.tscn")
const ENTRY_MAP: PackedScene = preload("res://scenes/maps/entry_map.tscn")

@onready var label = $UIWrapper/Label
@onready var map_generator: MapGenerator = $MapGenerator
@onready var maps: Node3D = $Maps
@onready var enemies: Node3D = $Enemies
@onready var souls: Node3D = $Souls
@onready var projectiles: Node3D = $Projectiles

const PLAYER_START_POINT: Vector3 = Vector3(1, 0.2, -1)

func _ready():
	GameEvents.from_stage_to_shop.connect(on_from_stage_to_shop)
	GameEvents.from_shop_to_stage.connect(on_from_shop_to_stage)
	GameEvents.to_entry_stage.connect(on_to_entry_stage)
	GameEvents.game_end.connect(on_game_end)
	
	if PlayerParameters.player_data["current_time"] != 0.0:
		GameEvents.emit_from_stage_to_shop()
	else:
		#maps.add_child(ENTRY_MAP.instantiate())
		maps.add_child(preload("res://scenes/maps/kube_map.tscn").instantiate())
	Constants.SOULS = souls
	Constants.ENEMIES = enemies
	Constants.PROJECTILES = projectiles


func _physics_process(_delta):
	label.text = "FPS: %f" % Engine.get_frames_per_second()

func clean_map() -> void:
	if !maps.get_children().is_empty() && maps.get_child(0):
		maps.get_child(0).queue_free()
	for enemy in enemies.get_children(): 
		if enemy is BasicEnemy:
			enemy.is_dying = true
		enemy.queue_free()
	for soul in souls.get_children():
		soul.queue_free()
	for proj in projectiles.get_children():
		proj.queue_free()

func on_game_end():
	clean_map()
	var entry: Node3D = ENTRY_MAP.instantiate()
	maps.add_child(entry)
	PlayerParameters.player.global_position = PLAYER_START_POINT
	PlayerParameters.player.rotation.y = 0

func on_from_stage_to_shop():
	clean_map()
	var shop: Node3D = TRAIDER_MAP.instantiate()
	maps.add_child(shop)
	PlayerParameters.player.global_position = PLAYER_START_POINT
	PlayerParameters.player.rotation.y = PI

func on_from_shop_to_stage():
	maps.get_child(0).queue_free()
	PlayerParameters.player_data[MetaProgression.STORAGES_KEY]["traider"] = {}
	map_generator.reset()
	var start_point: Vector3 = map_generator.generate_level()
	PlayerParameters.player.global_position = start_point
	PlayerParameters.player.rotation.y = PlayerParameters.next_rotation

func on_to_entry_stage():
	maps.get_child(0).queue_free()
	var entry: Node3D = ENTRY_MAP.instantiate()
	maps.add_child(entry)
	PlayerParameters.player.global_position = PLAYER_START_POINT
	PlayerParameters.player.rotation.y = 0
