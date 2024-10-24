class_name  BlankMap extends Node3D

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var environment: Node3D = $Environment
@onready var items: Node3D = $Items

var rooms: Dictionary
var id_counter: int = 0

func _ready() -> void:
	GameEvents.item_to_map.connect(on_item_to_map)

func add_room(room: Room) -> Room:
	if room.id == 0:
		room.id = id_counter
		room.previous_room_id = room.id - 1 # -1 for first room
	room.floor_height = 0 # static floor level
	rooms[room.id] = room
	id_counter+=1
	return room
	
func get_room_by_id(room_id: int) -> Room:
	return rooms[room_id]

func add_object(object: Node3D) -> void:
	if !environment:
		environment = $Environment
	environment.add_child(object)

func add_tile(tile: Node3D) -> void:
	if !environment:
		environment = $Environment
	environment.add_child(tile)

func add_navigation_tile(tile: Node3D) -> void:
	if !navigation_region_3d:
		navigation_region_3d = $NavigationRegion3D
	navigation_region_3d.add_child(tile)

func bake_navigation() -> void:
	navigation_region_3d.bake_navigation_mesh()

func on_item_to_map(to: Vector3, item: PackedScene): 
	var instance: Node3D = item.instantiate();
	instance.rotate_y(randf_range(-PI, PI))
	items.add_child(instance)
	instance.global_position = to
