class_name  BlankMap extends Node3D

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

var rooms: Dictionary
var id_counter: int = 0

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

func add_tile(tile: Node3D) -> void:
	if !navigation_region_3d:
		navigation_region_3d = $NavigationRegion3D
	navigation_region_3d.add_child(tile)

func bake_navigation() -> void:
	navigation_region_3d.bake_navigation_mesh()
