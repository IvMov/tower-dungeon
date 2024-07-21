class_name SurfaceBuilder extends Node3D

# SurfaceBuilder - can build surfaces (floor and ceil(optional))
@export var floors_packed: Array[PackedScene]

var next_position: Vector2 = Vector2.ZERO
var floor_part: Node3D
const CORE_TILE_SIZE: int = 2 

func build_surface(room: Room, map: BlankMap, is_ceil_to_build: bool = false) -> void:
	next_position = room.start_point
	print("will build floor for room size %s" % room.size)
	print("start %s" % room.start_point)
	print("entrance_coordinates %s" % room.entrance)
	for i in room.size.x:
		for j in room.size.y:
			floor_part = floors_packed.pick_random().instantiate()
			map.add_tile(floor_part)
			floor_part.global_position = Vector3(next_position.x, 0, next_position.y)
			next_position += Vector2(0, CORE_TILE_SIZE)
		next_position += Vector2(CORE_TILE_SIZE, 0)
		if i != room.size.x-1:
			next_position.y = room.start_point.y
	
