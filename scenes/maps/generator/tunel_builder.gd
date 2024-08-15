class_name TunelBuilder extends Node3D

@export var packed_tunel: PackedScene


var tunel_rotation: float
# exit from room
var start_tunel_coordinates: Vector2
# entrance to next room
var end_tunel_coordinates: Vector2
var has_candle: bool = true
@export var base_candle_cd: int = 3
var candle_cd: int = 1 # 1 to trigger candle on first segment

func add_tunel(length: int, direction: Vector2, room: Room, map: BlankMap) -> Vector4:
	candle_cd = base_candle_cd
	add_start(direction, room, map)
	add_end(length, direction, map)
	
	return Vector4(start_tunel_coordinates.x, start_tunel_coordinates.y, end_tunel_coordinates.x, end_tunel_coordinates.y)

func add_start(direction: Vector2, room: Room, map: BlankMap) -> void:
	match direction:
		Vector2.LEFT: 
			var left_x = calc_rand_x_tunel_position(room)
			var left_y = room.start_point.y - Constants.CORE_TILE_SIZE + Constants.TUNEL_PADDING
			print("exit to the LEFT")
			start_tunel_coordinates = Vector2(left_x, left_y)
			tunel_rotation = PI/2
		Vector2.RIGHT:
			var right_x = calc_rand_x_tunel_position(room)
			var right_y = room.start_point.y + room.size.y * Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
			print("exit to the RIGHT")
			start_tunel_coordinates = Vector2(right_x, right_y)
			tunel_rotation = PI/2
		Vector2.DOWN:
			var down_x = room.start_point.x - Constants.CORE_TILE_SIZE + Constants.TUNEL_PADDING
			var down_y = calc_rand_y_tunel_position(room)
			print("exit to the DOWN")
			start_tunel_coordinates = Vector2(down_x, down_y)
		Vector2.UP: 
			var up_x = room.start_point.x + room.size.x * Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
			var up_y = calc_rand_y_tunel_position(room)
			print("exit to the UP")
			start_tunel_coordinates = Vector2(up_x, up_y)
			
	#choose_room_exit_direction
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_navigation_tile(tunel)
	candle_or_not_candle(tunel)
	tunel.global_position = Vector3(start_tunel_coordinates.x, 0, start_tunel_coordinates.y)
	tunel.rotate_y(tunel_rotation)


func add_end(length: int, direction: Vector2, map: BlankMap) -> void:
	end_tunel_coordinates = start_tunel_coordinates
	for i in length:
		end_tunel_coordinates = add_next_tunel_part(direction, end_tunel_coordinates, map)
	tunel_rotation = 0


func add_next_tunel_part(direction: Vector2, entrance: Vector2, map: BlankMap) -> Vector2:
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_navigation_tile(tunel)
	candle_or_not_candle(tunel)
	match direction:
		Vector2.LEFT: 
			entrance = Vector2(entrance.x, entrance.y - Constants.CORE_TILE_SIZE) 
		Vector2.RIGHT:
			entrance = Vector2(entrance.x, entrance.y + Constants.CORE_TILE_SIZE) 
		Vector2.DOWN:
			entrance = Vector2(entrance.x - Constants.CORE_TILE_SIZE, entrance.y) 
		Vector2.UP: 
			entrance = Vector2(entrance.x + Constants.CORE_TILE_SIZE, entrance.y) 
	tunel.global_position = Vector3(entrance.x, 0, entrance.y)
	tunel.rotate_y(tunel_rotation)
	return entrance
	

func calc_rand_x_tunel_position(room: Room) -> int:
	# cause each tunel need 4m plate (and room size has n-plates with size 4m, so can contain n/2) -1 -calcualtions from 0 
	var possible_locations = room.size.x - 1
	return (room.start_point.x + randi_range(0,  possible_locations) * Constants.CORE_TILE_SIZE)

func calc_rand_y_tunel_position(room: Room) -> int:
	var possible_locations = room.size.y - 1 
	return (room.start_point.y + randi_range(0,  possible_locations) * Constants.CORE_TILE_SIZE)


func candle_or_not_candle(tunel: Tunel) -> void:
	candle_cd-=1
	if candle_cd == 0:
		candle_cd = base_candle_cd
	else:
		tunel.candle_1.queue_free()
		tunel.candle_2.queue_free()
