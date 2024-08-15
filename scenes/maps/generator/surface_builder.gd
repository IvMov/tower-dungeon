class_name SurfaceBuilder extends Node3D

# SurfaceBuilder - can build surfaces (floor and ceil(optional))
@export var floor_packed: PackedScene
@export var ceil_packed: PackedScene

var next_position: Vector2 = Vector2.ZERO
var floor_part: Node3D
var ceil_part: Node3D

func build_surface(room: Room, map: BlankMap, is_ceil_to_build: bool = false) -> void:
	next_position = room.start_point
	for i in room.size.x:
		for j in room.size.y:
			build_floor_part(room.floor_height, map)
			if is_ceil_to_build:
				build_ceil_part(room.ceil_height, map)
			next_position += Vector2(0, Constants.CORE_TILE_SIZE)
		next_position += Vector2(Constants.CORE_TILE_SIZE, 0)
		if i != room.size.x-1:
			next_position.y = room.start_point.y


func build_floor_part(height: int, map: BlankMap) -> void: 
	floor_part = floor_packed.instantiate()
	map.add_navigation_tile(floor_part)
	floor_part.global_position = Vector3(next_position.x, height, next_position.y)

func build_ceil_part(height: int, map: BlankMap) -> void: 
	ceil_part = ceil_packed.instantiate()
	map.add_tile(ceil_part)
	ceil_part.global_position = Vector3(next_position.x, height, next_position.y)
