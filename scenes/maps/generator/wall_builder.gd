class_name WallBuilder extends Node3D

# WallBuilder - can build walls around the room, avoiding tunels with height of 3 m
# i'm noob so this map builder works now only with walls 4x2 size

@export var packed_wall: PackedScene

const CORE_TILE_SIZE: int = 2

func add_walls(room: Room, map: BlankMap) -> void:
	print("add_walls called")
	
	var wall_front_pos = room.start_point + Vector2(CORE_TILE_SIZE/2, -CORE_TILE_SIZE)
	var wall_back_pos = room.start_point + Vector2(CORE_TILE_SIZE/2, room.size.y*CORE_TILE_SIZE)
	var y_position: int
	
	for i in room.size.x/CORE_TILE_SIZE:
		# front side
		if i != 0:
			wall_front_pos += Vector2(CORE_TILE_SIZE*2, 0)
		y_position = 3 if check_is_ocupied_position(room, wall_front_pos) else 0
		var wall_front: Node3D = packed_wall.instantiate()
		map.add_tile(wall_front)
		wall_front.global_position = Vector3(wall_front_pos.x, y_position, wall_front_pos.y)
		wall_front.rotate_y(PI/2)
		# back side
		if i != 0:
			wall_back_pos += Vector2(CORE_TILE_SIZE*2, 0)
		y_position = 3 if check_is_ocupied_position(room, wall_back_pos) else 0
		var wall_back: Node3D = packed_wall.instantiate()
		map.add_tile(wall_back)
		wall_back.global_position = Vector3(wall_back_pos.x, y_position, wall_back_pos.y)
		wall_back.rotate_y(PI/2)
		

	wall_front_pos = room.start_point + Vector2(-CORE_TILE_SIZE, CORE_TILE_SIZE/2)
	wall_back_pos = room.start_point + Vector2(room.size.x*CORE_TILE_SIZE, CORE_TILE_SIZE/2)
	
	for i in room.size.y/CORE_TILE_SIZE:
		# front side
		if i != 0:
			wall_front_pos += Vector2(0, CORE_TILE_SIZE*2)
			wall_back_pos += Vector2(0, CORE_TILE_SIZE*2)
		var wall_front: Node3D = packed_wall.instantiate()
		map.add_tile(wall_front)
		y_position = 3 if check_is_ocupied_position(room, wall_front_pos) else 0
		wall_front.global_position = Vector3(wall_front_pos.x, y_position, wall_front_pos.y)
		var wall_back: Node3D = packed_wall.instantiate()
		map.add_tile(wall_back)
		y_position = 3 if check_is_ocupied_position(room, wall_back_pos) else 0
		wall_back.global_position = Vector3(wall_back_pos.x, y_position, wall_back_pos.y)


func check_is_ocupied_position(room: Room, desired_position: Vector2) -> bool:
	return room.entrance == desired_position ||  room.exit == desired_position || room.deadend_exit == desired_position
	
