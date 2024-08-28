class_name MapGenerator extends Node3D

@export var has_ceil: bool = false
@export var has_walls: bool = false
@export var has_torches: bool = false
@export var has_columns: bool = false
@onready var wall_builder: WallBuilder = $WallBuilder
@onready var surface_builder: SurfaceBuilder = $SurfaceBuilder
@onready var tunel_builder: TunelBuilder = $TunelBuilder
@onready var torch_builder: TorchBuilder = $TorchBuilder
@onready var column_builder = $ColumnBuilder

@export var MAX_ROOMS: int = 1 # how many rooms will be on map
@export var DEADEND_POSSIBILITY: float = 0.0
@export var MIN_ROOM_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE
@export var MAX_ROOM_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE
@export var MIN_TUNEL_LENGTH: int = 1 # how long tunels could be
@export var MAX_TUNEL_LENGTH: int = 2 # how long tunels could be
@export var DIRECTION_AVAILABILITY_CD: int = 5 # how long steps the oposite tile could not be installed
@export var ROOM_SIZE: Vector2 = Vector2(1,1)

@export var paked_blank_map: PackedScene
@export var enemy_spawner: PackedScene
@export var enemy_packed: PackedScene

var root_room_position: Vector2 = Vector2.ZERO
var deadend_root_room_position: Vector2 = Vector2.ZERO
var is_spawner = true
# core datashelf
var basic_directions: Array[Vector2] = [Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT, Vector2.UP]
var directions: Array[Vector2]
var availability: Dictionary = {
		Vector2.LEFT: 0,
		Vector2.DOWN: 0,
		Vector2.RIGHT: 0,
		Vector2.UP: 0
	}

# reusable staff
var room: Room
var map: BlankMap

#current direction for next tunel and room
var next_room_direction: Vector2
#direction for next deadend tunel and deadend room
var deadend_room_direction: Vector2
var deadend_ROOM_SIZE: Vector2 = Vector2(4, 4)

var tunel_length: int
# result of creation of tunel (x-y - start of tunel, z-w - end of tunel)
var exit_and_entrance_coordinates: Vector4

# room exit tunel position (start of tunel)
var exit_coordinates: Vector2
# room entrance tunel position (end of tunel)
var next_entrance_coordinates: Vector2
# exit from common room to deadend room tunel position (start of tunel)
var exit_to_deadend_coordinates: Vector2
# entrance to deadend room (next after exit_to_deadend_coordinates) (end of tunel)
var deadend_entrance_coordinates: Vector2


func generate_level() -> void:
	prepare_blank_map()
	for i in MAX_ROOMS:
		generate_room()
	map.bake_navigation()


func generate_room() -> void:
	create_common_room()
	
	# deadend calcs - need to encapsulate
	if randf() <= DEADEND_POSSIBILITY:
		create_deadend_room()
	# saved room required to build walls - to check all deadends and etc
	room = map.add_room(room)
	if has_walls:
		wall_builder.add_walls(room, map)
	if has_torches:
		torch_builder.add_torches(room, map)
	if has_columns:
		column_builder.add_columns(room, map)
	
	# normal next room calcs - need to encapsulate
	ROOM_SIZE = calculate_ROOM_SIZE()
	print("room size %s" % ROOM_SIZE)
	root_room_position = calc_room_start_position(ROOM_SIZE, next_entrance_coordinates, next_room_direction)
	
	#update ONLY after deadend spawns or not - if use it earlier  - some good directions will be blocked for pick_random_method
	update_available_dirrections()


func save_deadend_room_to_map() -> Room:
	var room: Room = Room.new()
	room.entrance = deadend_entrance_coordinates
	room.exit = Vector2.ZERO
	room.deadend_exit = Vector2.ZERO
	room.size = deadend_ROOM_SIZE
	room.start_point = deadend_root_room_position
	room.floor_height = 0
	return map.add_room(room)

func create_common_room() -> void:
	room = Room.new()
	room.size = ROOM_SIZE
	room.entrance = next_entrance_coordinates
	room.start_point = root_room_position
	room.floor_height = 0
	room.ceil_height = 20
	
	surface_builder.build_surface(room, map, has_ceil)
	
	if is_spawner:
		var spawn: EnemySpawner = enemy_spawner.instantiate()
		map.add_child(spawn)
		spawn.agr_collision.shape.size = Vector3(ROOM_SIZE.x * Constants.CORE_TILE_SIZE, room.ceil_height, ROOM_SIZE.y * Constants.CORE_TILE_SIZE)
		spawn.global_position = Vector3(room.start_point.x + room.size.x * Constants.CORE_TILE_SIZE/2 + randi_range(-3, 3), 0,room.start_point.y +  room.size.y*Constants.CORE_TILE_SIZE/2 + randi_range(-3, 3))
		for i in (room.size.x + room.size.y):
			var enemy = enemy_packed.instantiate()
			map.add_child(enemy)
			enemy.global_position = Vector3(room.start_point.x + randf_range(1, room.size.x-1) * Constants.CORE_TILE_SIZE, randf_range(1, 10), room.start_point.y + randf_range(1, room.size.y-1) * Constants.CORE_TILE_SIZE)
	next_room_direction = get_random_available_direction()
	tunel_length = randi_range(MIN_TUNEL_LENGTH, MAX_TUNEL_LENGTH)
	exit_and_entrance_coordinates = tunel_builder.add_tunel(tunel_length, next_room_direction, room, map)
	exit_coordinates = Vector2(exit_and_entrance_coordinates.x, exit_and_entrance_coordinates.y)
	next_entrance_coordinates = Vector2(exit_and_entrance_coordinates.z, exit_and_entrance_coordinates.w)
	room.exit = exit_coordinates


func create_deadend_room() -> void:
		tunel_length = randi_range(MIN_TUNEL_LENGTH, MAX_TUNEL_LENGTH)
		deadend_room_direction = pick_random()
		if deadend_room_direction:
			exit_and_entrance_coordinates = tunel_builder.add_tunel(tunel_length, deadend_room_direction, room, map)
			exit_to_deadend_coordinates = Vector2(exit_and_entrance_coordinates.x, exit_and_entrance_coordinates.y) 
			deadend_entrance_coordinates = Vector2(exit_and_entrance_coordinates.z, exit_and_entrance_coordinates.w)
			room.deadend_exit = exit_to_deadend_coordinates
			deadend_ROOM_SIZE = calculate_ROOM_SIZE()
			deadend_root_room_position = calc_room_start_position(deadend_ROOM_SIZE, deadend_entrance_coordinates, deadend_room_direction)
			var deadend_room: Room = save_deadend_room_to_map()
			deadend_room.ceil_height = 20
			surface_builder.build_surface(deadend_room, map, has_ceil)
			if has_walls:
				wall_builder.add_walls(deadend_room, map)
			if has_torches:
				torch_builder.add_torches(deadend_room, map)
			if has_columns:
				column_builder.add_columns(deadend_room, map)
			deadend_update_available_dirrections()
		else:
			print("NO FREE DIRRECTIONS FOR DEADEND ROOM!")
			deadend_entrance_coordinates = Vector2.ZERO
			exit_to_deadend_coordinates = Vector2.ZERO




func calc_room_start_position(room: Vector2, entrance: Vector2, some_direction: Vector2) -> Vector2:
	var next_room_start_point: Vector2
	match some_direction:
		Vector2.LEFT: 
			next_room_start_point.x = calc_rand_x_root_room_position(room, entrance)
			next_room_start_point.y = entrance.y - (room.y * Constants.CORE_TILE_SIZE) + Constants.TUNEL_PADDING
		Vector2.RIGHT:
			next_room_start_point.x = calc_rand_x_root_room_position(room, entrance)
			next_room_start_point.y = entrance.y + Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
		Vector2.DOWN:
			next_room_start_point.x = entrance.x - (room.x * Constants.CORE_TILE_SIZE) + Constants.TUNEL_PADDING
			next_room_start_point.y = calc_rand_y_root_room_position(room, entrance)
		Vector2.UP: 
			next_room_start_point.x = entrance.x + Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
			next_room_start_point.y = calc_rand_y_root_room_position(room, entrance)
	print("next_room_start_point %s" % next_room_start_point)
	return next_room_start_point


func calc_rand_x_root_room_position(room: Vector2, entrance: Vector2) -> int:
	var possible_locations = room.x - 1
	return entrance.x - randi_range(0, possible_locations) * Constants.CORE_TILE_SIZE

func calc_rand_y_root_room_position(room: Vector2, entrance: Vector2) -> int:
	var possible_locations = room.y - 1
	return entrance.y - randi_range(0, possible_locations) * Constants.CORE_TILE_SIZE


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
	print(availability)
	match next_room_direction:
		Vector2.LEFT: 
			availability[Vector2.RIGHT] = DIRECTION_AVAILABILITY_CD
		Vector2.RIGHT:
			availability[Vector2.LEFT] = DIRECTION_AVAILABILITY_CD
		Vector2.DOWN:
			availability[Vector2.UP] = DIRECTION_AVAILABILITY_CD
		Vector2.UP: 
			availability[Vector2.DOWN] = DIRECTION_AVAILABILITY_CD
	

func deadend_update_available_dirrections() -> void:
	match deadend_room_direction:
		Vector2.LEFT: 
			availability[Vector2.LEFT] = DIRECTION_AVAILABILITY_CD-2
		Vector2.RIGHT:
			availability[Vector2.RIGHT] = DIRECTION_AVAILABILITY_CD-2
		Vector2.DOWN:
			availability[Vector2.DOWN] = DIRECTION_AVAILABILITY_CD-2
		Vector2.UP: 
			availability[Vector2.UP] = DIRECTION_AVAILABILITY_CD-2

# handle cd of availability dirrections 
func update_dirrections_cd() -> void:
	for dir in availability:
			if availability[dir] > 0:
				availability[dir]-=1


func pick_random() -> Vector2:
	if directions.is_empty():
		print("FCK - something wrong! CHECK GENERATOR OF MAP!")
		return Vector2(0, 0)
	directions.shuffle()
	var direction: Vector2 = directions.pop_front()
	if availability[direction] > 0:
		return pick_random()
	return direction


func calculate_ROOM_SIZE() -> Vector2:
	var current_x: int = randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
	var current_y: int = randi_range(MIN_ROOM_SIZE, MAX_ROOM_SIZE)
	
	return Vector2(current_x, current_y)
	
