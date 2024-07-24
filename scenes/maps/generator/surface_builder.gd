class_name SurfaceBuilder extends Node3D

# SurfaceBuilder - can build surfaces (floor and ceil(optional))
@export var floors_packed: Array[PackedScene]

var next_position: Vector2 = Vector2.ZERO
var floor_part: Node3D
const CORE_TILE_SIZE: int = 2 

func build_surface(room: Room, map: BlankMap, is_ceil_to_build: bool = false) -> void:
	next_position = room.start_point
	for i in room.size.x:
		for j in room.size.y:
			build_floor(map)
			if is_ceil_to_build:
				build_ceil(map)
			next_position += Vector2(0, CORE_TILE_SIZE)
		next_position += Vector2(CORE_TILE_SIZE, 0)
		if i != room.size.x-1:
			next_position.y = room.start_point.y


func build_floor(map: BlankMap) -> void: 
	floor_part = floors_packed.pick_random().instantiate()
	map.add_tile(floor_part)
	floor_part.global_position = Vector3(next_position.x, 0, next_position.y)

func build_ceil(map: BlankMap) -> void: 
	floor_part = floors_packed.pick_random().instantiate()
	floor_part.rotate_x(PI)
	map.add_tile(floor_part)
	floor_part.global_position = Vector3(next_position.x, 9, next_position.y)
	floor_part = floors_packed.pick_random().instantiate()
	map.add_tile(floor_part)
	floor_part.global_position = Vector3(next_position.x, 10, next_position.y)
