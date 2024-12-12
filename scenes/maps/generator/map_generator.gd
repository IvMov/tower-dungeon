class_name MapGenerator extends Node3D

@export var has_ceil: bool = false
@export var has_walls: bool = false
@export var has_torches: bool = false
@export var has_columns: bool = false
@export var has_spawner = true

@onready var wall_builder: WallBuilder = $WallBuilder
@onready var surface_builder: SurfaceBuilder = $SurfaceBuilder
@onready var tunel_builder: TunelBuilder = $TunelBuilder
@onready var torch_builder: TorchBuilder = $TorchBuilder
@onready var column_builder: ColumnBuilder = $ColumnBuilder
@onready var player_fontain_builder: PlayerFontainBuilder = $PlayerFontainBuilder

@export var ROOMS: int = 1 # how many rooms will be on map
@export var DEADEND_INIT_POSSIBILITY: float = 0.8
@export var MIN_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE
@export var MAX_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE

@export var MIN_TUNEL_LENGTH: int = 1 # how long tunels could be
@export var MAX_TUNEL_LENGTH: int = 2 # how long tunels could be
@export var DIRECTION_AVAILABILITY_CD: int = 5 # how long steps the oposite tile could not be installed
@export var ROOM_SIZE: Vector2 = Vector2(1,1)

@export var paked_blank_map: PackedScene
@export var enemy_spawner: PackedScene
@export var wall_enemy: PackedScene
@export var enemy_packed: PackedScene

var root_room_position: Vector2 = Vector2.ZERO
var deadend_root_room_position: Vector2 = Vector2.ZERO
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
var deadend_possibility: float
var blocked_room: bool = false
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
	deadend_possibility = DEADEND_INIT_POSSIBILITY
	prepare_blank_map()
	for i in ROOMS:
		print("new room %d" % i)
		generate_room()
		# map storage as map of each empty map
		# each_room_generate pickable items - add them to map_storage
	map.bake_navigation()
	# TODO: think about map save (below - copied from internet)
	#var node_to_save = $Node2D
	#var scene = PackedScene.new()
	#scene.pack(node_to_save)
	#ResourceSaver.save(scene, "res://MyScene.tscn")


func generate_room() -> void:
	create_common_room()
	
	# deadend calcs - need to encapsulate
	if randf() <= deadend_possibility:
		create_deadend_room()
		deadend_possibility = DEADEND_INIT_POSSIBILITY
		print("bingo - deadend")
	else:
		deadend_possibility = min(1, deadend_possibility + randf_range(0.05, 0.15))
		print("No deadend, possibility for next room! %f" % deadend_possibility)
	if blocked_room:
		#block exit from room
		var wall_enemy_inst: WallEnemy = wall_enemy.instantiate()
		
		map.add_child(wall_enemy_inst)
		wall_enemy_inst.global_position.y = -2
		wall_enemy_inst.global_position = Vector3(room.exit.x, 0.0, room.exit.y)
		if next_room_direction == Vector2.LEFT || next_room_direction == Vector2.RIGHT:
			wall_enemy_inst.rotate_y(PI/2)

		player_fontain_builder.add_fontain(room, map, wall_enemy_inst)
		print("blocked room generated")
		blocked_room = false
		
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
	root_room_position = calc_room_start_position(ROOM_SIZE, next_entrance_coordinates, next_room_direction)
	
	#update ONLY after deadend spawns or not - if use it earlier  - some good directions will be blocked for pick_random_method
	update_available_dirrections()
	if room.deadend_exit != Vector2.ZERO:
		blocked_room = true


func save_deadend_room_to_map() -> Room:
	var new_room: Room = Room.new()
	new_room.entrance = deadend_entrance_coordinates
	new_room.exit = Vector2.ZERO
	new_room.deadend_exit = Vector2.ZERO
	new_room.size = deadend_ROOM_SIZE
	new_room.start_point = deadend_root_room_position
	new_room.floor_height = 0
	print(new_room)
	return map.add_room(new_room)


func create_common_room() -> void:
	room = Room.new()
	room.size = ROOM_SIZE
	room.entrance = next_entrance_coordinates
	room.start_point = root_room_position
	room.floor_height = 0
	room.ceil_height = 20
	
	surface_builder.build_surface(room, map, has_ceil)
	
	if has_spawner:
		var spawn: EnemySpawner = enemy_spawner.instantiate()
		map.add_child(spawn)
		spawn.spawn_distance = max(ROOM_SIZE.x * Constants.CORE_TILE_SIZE / 2, ROOM_SIZE.y * Constants.CORE_TILE_SIZE / 2) 
		spawn.boost_enemies_num = (room.size.x + room.size.y)
		spawn.agr_collision.shape.size = Vector3(ROOM_SIZE.x * Constants.CORE_TILE_SIZE, room.ceil_height, ROOM_SIZE.y * Constants.CORE_TILE_SIZE)
		spawn.global_position = Vector3(room.start_point.x + room.size.x * Constants.CORE_TILE_SIZE/2 + randi_range(-3, 3), 0,room.start_point.y +  room.size.y*Constants.CORE_TILE_SIZE/2 + randi_range(-3, 3))

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




func calc_room_start_position(target_room: Vector2, entrance: Vector2, some_direction: Vector2) -> Vector2:
	var next_room_start_point: Vector2
	match some_direction:
		Vector2.LEFT: 
			next_room_start_point.x = calc_rand_x_root_room_position(target_room, entrance)
			next_room_start_point.y = entrance.y - (target_room.y * Constants.CORE_TILE_SIZE) + Constants.TUNEL_PADDING
		Vector2.RIGHT:
			next_room_start_point.x = calc_rand_x_root_room_position(target_room, entrance)
			next_room_start_point.y = entrance.y + Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
		Vector2.DOWN:
			next_room_start_point.x = entrance.x - (target_room.x * Constants.CORE_TILE_SIZE) + Constants.TUNEL_PADDING
			next_room_start_point.y = calc_rand_y_root_room_position(target_room, entrance)
		Vector2.UP: 
			next_room_start_point.x = entrance.x + Constants.CORE_TILE_SIZE - Constants.TUNEL_PADDING
			next_room_start_point.y = calc_rand_y_root_room_position(target_room, entrance)
	return next_room_start_point


func calc_rand_x_root_room_position(target_room: Vector2, entrance: Vector2) -> int:
	var possible_locations = target_room.x - 1
	return entrance.x - randi_range(0, possible_locations) * Constants.CORE_TILE_SIZE

func calc_rand_y_root_room_position(target_room: Vector2, entrance: Vector2) -> int:
	var possible_locations = target_room.y - 1
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
	print(MIN_SIZE)
	print(MAX_SIZE)
	var current_x: int = randi_range(MIN_SIZE, MAX_SIZE)
	var current_y: int = randi_range(MIN_SIZE, MAX_SIZE)
	print("x: %d, y: %d" % [current_x, current_y])
	return Vector2(current_x, current_y)
	
