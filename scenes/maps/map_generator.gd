class_name MapGenerator extends Node3D

@export var packed_floor: PackedScene
@export var packed_tunel: PackedScene
@export var paked_blank_map: PackedScene

@export var DEADEND_POSSIBILITY: float = 0.0
@export var DIRECTION_AVAILABILITY_CD: int = 5 # how long steps the oposite tile could not be installed
@export var MIN_ROOM_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE
@export var MAX_ROOM_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE

@export var MAX_ROOMS: int = 1 # how many rooms will be on map
@export var MIN_TUNEL_LENGTH: int = 13 # how long tunels could be
@export var MAX_TUNEL_LENGTH: int = 14 # how long tunels could be

const CORE_TILE_SIZE: int = 2 
const CORE_TUNEL_SIZE: int = 4 

var next_position: Vector2 = Vector2.ZERO
var next_deadend_position: Vector2 = Vector2.ZERO
var root_room_position: Vector2 = Vector2.ZERO
var deadend_root_room_position: Vector2 = Vector2.ZERO

# core datashelf
var basic_directions: Array[Vector2] = [Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT, Vector2.UP]
var availability: Dictionary = {
		Vector2.LEFT: 0,
		Vector2.DOWN: 0,
		Vector2.RIGHT: 0,
		Vector2.UP: 0
	}
	
# reusable staff
var has_deadend_exit: bool
var room: Room
var map: BlankMap
var floor_part: Node3D
var directions: Array[Vector2]

#current direction for next tunel and room
var current_direction: Vector2
#direction for next deadend tunel and deadend room
var deadend_direction: Vector2

var room_size: Vector2 = Vector2(4, 4)
var deadend_room_size: Vector2 = Vector2(4, 4)

var tunel_rotation: float

var entrance_coordinates: Vector2
var exit_coordinates: Vector2
# exit from common room to deadend room
var exit_to_deadend_coordinates: Vector2
# entrance to deadend room (next after exit_to_deadend_coordinates)
var deadend_entrance_coordinates: Vector2


# Define the group name and the coordinates to check
var group_name = "floor"


func _ready():
	#generate_map()
	generate_level()
	
	#map_inst.bake_navigation()


func generate_level() -> void:
	prepare_blank_map()
	for i in MAX_ROOMS:
		generate_room()


func generate_room() -> void:
	room = Room.new()
	room.size = room_size
	room.entrance = entrance_coordinates
	room.start_point = root_room_position
	
	has_deadend_exit = randf() > DEADEND_POSSIBILITY
	next_position = root_room_position
	fill_room_floor()
	
	add_room_exit()
	room.exit = exit_coordinates
	var rand: int = randi_range(MIN_TUNEL_LENGTH, MAX_TUNEL_LENGTH)
	for i in rand:
		entrance_coordinates = add_next_room_entrance(current_direction, entrance_coordinates)
	tunel_rotation = 0
	
	
	if has_deadend_exit:
		add_exit_to_deadend_room()
		room.deadend_exit = exit_to_deadend_coordinates
		for i in rand:
			deadend_entrance_coordinates = add_next_room_entrance(deadend_direction, deadend_entrance_coordinates)
	
	# saved room required to build walls - to check all deadends and etc
	var room = map.add_room(room)
	add_walls(room)
	
	# normal next room calcs - need to encapsulate
	room_size = calculate_room_size()
	root_room_position = calc_next_room_start_position(room_size, entrance_coordinates, current_direction)
	
	tunel_rotation = 0
	# deadend calcs - need to encapsulate
	if has_deadend_exit:
		
		deadend_room_size = calculate_room_size()
		deadend_root_room_position = calc_next_room_start_position(deadend_room_size, deadend_entrance_coordinates, deadend_direction)
		next_deadend_position = deadend_root_room_position
		build_deadend_room()
		var deadend_room = save_deadend_room_to_map()
		add_walls(deadend_room)
		clean_deadend_vars()
	
	#update ONLY after deadend spawns or not - if use it earlier  - some good directions will be blocked for pick_random_method
	update_available_dirrections()


func save_deadend_room_to_map() -> Room:
	var room: Room = Room.new()
	room.entrance = deadend_entrance_coordinates
	room.exit = Vector2.ZERO
	room.deadend_exit = Vector2.ZERO
	room.size = deadend_room_size
	room.start_point = deadend_root_room_position
	return map.add_room(room)

func clean_deadend_vars() -> void:
	deadend_entrance_coordinates = Vector2.ZERO
	deadend_room_size = Vector2.ZERO
	deadend_root_room_position = Vector2.ZERO


func fill_room_floor() -> void:
	print("will build floor for room size %s" % room_size)
	print("start %s" % root_room_position)
	print("entrance_coordinates %s" % entrance_coordinates)
	for i in room_size.x:
		for j in room_size.y:
			floor_part = packed_floor.instantiate()
			map.add_tile(floor_part)
			floor_part.global_position = Vector3(next_position.x, 0, next_position.y)
			next_position += Vector2(0, 2)
		next_position += Vector2(2, 0)
		if i != room_size.x-1:
			next_position.y = root_room_position.y
	

func build_deadend_room() -> void:
	print("will build floor for deadend_room size %s" % deadend_room_size)
	print("start %s" % deadend_root_room_position)
	for i in deadend_room_size.x:
		for j in deadend_room_size.y:
			floor_part = packed_floor.instantiate()
			map.add_tile(floor_part)
			floor_part.global_position = Vector3(next_deadend_position.x, 0, next_deadend_position.y)
			next_deadend_position += Vector2(0, 2)
		next_deadend_position += Vector2(2, 0)
		if i != deadend_room_size.x-1:
			next_deadend_position.y = deadend_root_room_position.y

func add_room_exit() -> void:
	current_direction = get_random_available_direction()
	exit_coordinates = Vector2.ZERO
	match current_direction:
		Vector2.LEFT: 
			var left_x = calc_rand_x_tunel_position()
			var left_y = root_room_position.y - 2
			print("exit to the LEFT")
			exit_coordinates = Vector2(left_x, left_y)
		Vector2.RIGHT:
			var right_x = calc_rand_x_tunel_position()
			var right_y = next_position.y
			print("exit to the RIGHT")
			exit_coordinates = Vector2(right_x, right_y)
		Vector2.DOWN:
			var down_x = root_room_position.x - 2
			var down_y = calc_rand_y_tunel_position()
			print("exit to the DOWN")
			exit_coordinates = Vector2(down_x, down_y)
			tunel_rotation = PI/2
		Vector2.UP: 
			var up_x = next_position.x
			var up_y = calc_rand_y_tunel_position()
			print("exit to the UP")
			exit_coordinates = Vector2(up_x, up_y)
			tunel_rotation = PI/2
	#choose_room_exit_direction
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_tile(tunel)
	tunel.global_position = Vector3(exit_coordinates.x, 0, exit_coordinates.y)
	tunel.rotate_y(tunel_rotation)
	entrance_coordinates = exit_coordinates


func add_exit_to_deadend_room() -> void:
	deadend_direction = pick_random()
	exit_to_deadend_coordinates = Vector2.ZERO
	match deadend_direction:
		Vector2.LEFT: 
			var left_x = calc_rand_x_tunel_position()
			var left_y = root_room_position.y - 2
			print("exit_to_deadend_coordinates to the LEFT")
			exit_to_deadend_coordinates = Vector2(left_x, left_y)
			print(exit_to_deadend_coordinates)
		Vector2.RIGHT:
			var right_x = calc_rand_x_tunel_position()
			var right_y = next_position.y
			print("exit_to_deadend_coordinates to the RIGHT")
			exit_to_deadend_coordinates = Vector2(right_x, right_y)
		Vector2.DOWN:
			var down_x = root_room_position.x - 2
			var down_y = calc_rand_y_tunel_position()
			print("exit_to_deadend_coordinates to the DOWN")
			exit_to_deadend_coordinates = Vector2(down_x, down_y)
			tunel_rotation = PI/2
		Vector2.UP: 
			var up_x = next_position.x
			var up_y = calc_rand_y_tunel_position()
			print("exit_to_deadend_coordinates to the UP")
			exit_to_deadend_coordinates = Vector2(up_x, up_y)
			tunel_rotation = PI/2
	#choose_room_exit_direction
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_tile(tunel)
	tunel.global_position = Vector3(exit_to_deadend_coordinates.x, 0, exit_to_deadend_coordinates.y)
	tunel.rotate_y(tunel_rotation)
	deadend_entrance_coordinates = exit_to_deadend_coordinates


func add_next_room_entrance(direction: Vector2, entrance: Vector2) -> Vector2:
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_tile(tunel)
	match direction:
		Vector2.LEFT: 
			entrance = Vector2(entrance.x, entrance.y - CORE_TUNEL_SIZE)
		Vector2.RIGHT:
			entrance = Vector2(entrance.x, entrance.y + CORE_TUNEL_SIZE)
		Vector2.DOWN:
			entrance = Vector2(entrance.x - CORE_TUNEL_SIZE, entrance.y)
		Vector2.UP: 
			entrance = Vector2(entrance.x + CORE_TUNEL_SIZE, entrance.y)
	tunel.global_position = Vector3(entrance.x, 0, entrance.y)
	tunel.rotate_y(tunel_rotation)
	return entrance;


func add_walls(room: Room) -> void:
	pass


func calc_next_room_start_position(room: Vector2, entrance: Vector2, some_direction: Vector2) -> Vector2:
	var next_room_start_point: Vector2
	match some_direction:
		Vector2.LEFT: 
			next_room_start_point.x = calc_rand_x_root_room_position(room, entrance)
			next_room_start_point.y = entrance.y - (room.y * CORE_TILE_SIZE)
		Vector2.RIGHT:
			next_room_start_point.x = calc_rand_x_root_room_position(room, entrance)
			next_room_start_point.y = entrance.y + CORE_TILE_SIZE
		Vector2.DOWN:
			next_room_start_point.x = entrance.x - (room.x * CORE_TILE_SIZE)
			next_room_start_point.y = calc_rand_y_root_room_position(room, entrance)
		Vector2.UP: 
			next_room_start_point.x = entrance.x + CORE_TILE_SIZE
			next_room_start_point.y = calc_rand_y_root_room_position(room, entrance)
	print("next_room_start_point %s" % next_room_start_point)
	return next_room_start_point


func calc_deadend_room_params() -> void:
	match deadend_direction:
		Vector2.LEFT: 
			deadend_root_room_position.x = calc_rand_x_root_room_position(deadend_room_size, deadend_entrance_coordinates)
			deadend_root_room_position.y = deadend_entrance_coordinates.y - (deadend_room_size.y * CORE_TILE_SIZE)
		Vector2.RIGHT:
			deadend_root_room_position.x = calc_rand_x_root_room_position(deadend_room_size, deadend_entrance_coordinates)
			deadend_root_room_position.y = deadend_entrance_coordinates.y + CORE_TILE_SIZE
		Vector2.DOWN:
			deadend_root_room_position.x = deadend_entrance_coordinates.x - (deadend_room_size.x * CORE_TILE_SIZE)
			deadend_root_room_position.y = calc_rand_y_root_room_position(deadend_room_size, deadend_entrance_coordinates)
		Vector2.UP: 
			deadend_root_room_position.x = deadend_entrance_coordinates.x + CORE_TILE_SIZE
			deadend_root_room_position.y = calc_rand_y_root_room_position(deadend_room_size, deadend_entrance_coordinates)
	next_position = root_room_position
	tunel_rotation = 0


func calc_rand_x_root_room_position(room: Vector2, entrance: Vector2) -> int:
	var possible_locations = ((room.x * CORE_TILE_SIZE) / CORE_TUNEL_SIZE) - 1
	return (entrance.x - CORE_TILE_SIZE - (possible_locations * CORE_TUNEL_SIZE)) + (randi_range(0, possible_locations) * CORE_TUNEL_SIZE) +1

func calc_rand_y_root_room_position(room: Vector2, entrance: Vector2) -> int:
	var possible_locations = ((room.y * CORE_TILE_SIZE) / CORE_TUNEL_SIZE) - 1
	return (entrance.y - CORE_TILE_SIZE - (possible_locations * CORE_TUNEL_SIZE)) + (randi_range(0, possible_locations) * CORE_TUNEL_SIZE) +1

func calc_rand_x_tunel_position() -> int:
	# cause each tunel need 4m plate (and room size has n-plates with size 4m, so can contain n/2) -1 -calcualtions from 0 
	var possible_locations = (room_size.x / CORE_TILE_SIZE) - 1
	return (root_room_position.x + randi_range(0,  possible_locations) * CORE_TUNEL_SIZE) + 1

func calc_rand_y_tunel_position() -> int:
	var possible_locations = (room_size.y / CORE_TILE_SIZE) - 1 
	return (root_room_position.y + randi_range(0,  possible_locations) * CORE_TUNEL_SIZE) + 1


func prepare_blank_map() -> void:
	map = paked_blank_map.instantiate()
	get_tree().get_first_node_in_group("maps").add_child(map)



func get_random_available_direction() -> Vector2:
	update_dirrections_cd()
	directions = basic_directions.duplicate()
	var picked_direction = pick_random()
	
	return picked_direction


# add availability cd for new dirrection oposite dir
func update_available_dirrections() -> void:
	match current_direction:
		Vector2.LEFT: 
			availability[Vector2.RIGHT] = DIRECTION_AVAILABILITY_CD
		Vector2.RIGHT:
			availability[Vector2.LEFT] = DIRECTION_AVAILABILITY_CD
		Vector2.DOWN:
			availability[Vector2.UP] = DIRECTION_AVAILABILITY_CD
		Vector2.UP: 
			availability[Vector2.DOWN] = DIRECTION_AVAILABILITY_CD


# handle cd of availability dirrections 
func update_dirrections_cd() -> void:
	for dir in availability:
			if availability[dir] > 0:
				availability[dir]-=1


func pick_random() -> Vector2:
	if directions.is_empty():
		print("FCK - something wrong! CHECK SPAWNER OF MAP!")
		return Vector2(0, 0)
	directions.shuffle()
	var direction: Vector2 = directions.pop_front()
	if availability[direction] > 0:
		return pick_random()
	return direction



func calculate_room_size() -> Vector2:
	var variants_min: int = MIN_ROOM_SIZE / CORE_TILE_SIZE
	var variants_max: int = MAX_ROOM_SIZE / CORE_TILE_SIZE
	var current_x_multiplier: int = randi_range(variants_min, variants_max)
	var current_y_multiplier: int = randi_range(variants_min, variants_max)
	
	return Vector2(CORE_TILE_SIZE * current_x_multiplier, CORE_TILE_SIZE * current_y_multiplier)
	
