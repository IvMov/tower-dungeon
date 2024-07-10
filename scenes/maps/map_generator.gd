class_name MapGenerator extends Node3D

@export var packed_floor: PackedScene
@export var packed_tunel: PackedScene
@export var paked_blank_map: PackedScene

const AVAILABILITY_CD: int = 5 # how long steps the oposite tile could not be installed
const MAX_ROOM_SIZE: int = 16 # must be dividible by CORE_TILE_SIZE
const MIN_ROOM_SIZE: int = 4 # must be dividible by CORE_TILE_SIZE
const CORE_TILE_SIZE: int = 4 

var next_x_position: Vector2 = Vector2.ZERO
var next_y_position: Vector2 = Vector2(0, 2)

# core datashelf
var basic_directions: Array[Vector2] = [Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT, Vector2.UP]
var availability: Dictionary = {
		Vector2.LEFT: 0,
		Vector2.DOWN: 0,
		Vector2.RIGHT: 0,
		Vector2.UP: 0
	}
	
# reusable staff
var map: BlankMap
var floor_part: Node3D
var directions: Array[Vector2]
var current_direction: Vector2
var exit_position: Vector2
var room_size: Vector2


func _ready():
	
	#generate_map()
	generate_level()
	
	#map_inst.bake_navigation()


func generate_level() -> void:
	prepare_blank_map()
	calculate_room_size()
	generate_room(room_size.x, room_size.y)


func generate_room(x: float, y: float) -> void:
	fill_room_floor(x, y)
	add_room_exit()
	

func fill_room_floor(x: float, y: float) -> void:
	for i in x:
		floor_part = packed_floor.instantiate()
		map.add_tile(floor_part)
		floor_part.global_position = Vector3(next_x_position.x, 0, next_x_position.y)
		next_y_position = next_x_position +  Vector2(0, 2)
		for j in y-1:
			next_y_position = Vector2(next_x_position.x, next_y_position.y)
			floor_part = packed_floor.instantiate()
			map.add_tile(floor_part)
			floor_part.global_position = Vector3(next_y_position.x, 0, next_y_position.y)
			next_y_position += Vector2(0, 2)

		next_x_position += Vector2(2, 0)
		

func add_room_exit() -> void:
	set_current_dirrection_to_available_random()
	var door_coordinates: Vector2 = Vector2.ZERO
	var door_rotation: float = 0.0
	current_direction = pick_random()
	match current_direction:
		Vector2.LEFT: 
			var left_x = calc_rand_x_door_position()
			var left_y = next_y_position.y - (room_size.y * 2) - 2
			print("exit to the LEFT")
			door_coordinates = Vector2(left_x, left_y)
		Vector2.RIGHT:
			#TODO: DEBUG WHY NOT RIGHT SPAWN EXIT LITTLE BIT LEFTER SOMETIME
			var right_x = calc_rand_x_door_position()
			var right_y = next_y_position.y
			print("exit to the RIGHT")
			door_coordinates = Vector2(right_x, right_y)
			
		Vector2.DOWN:
			var down_x = next_x_position.x - (room_size.x * 2) - 2
			var down_y = calc_rand_y_door_position()
			print("exit to the DOWN")
			door_coordinates = Vector2(down_x, down_y)
			door_rotation = PI/2
		Vector2.UP: 
			var up_x = next_x_position.x
			var up_y = calc_rand_y_door_position()
			print("exit to the UP")
			door_coordinates = Vector2(up_x, up_y)
			door_rotation = PI/2
			
	print(door_coordinates)
	#choose_room_exit_direction
	var tunel: Node3D = packed_tunel.instantiate()
	map.add_tile(tunel)
	tunel.global_position = Vector3(door_coordinates.x, 0, door_coordinates.y)
	tunel.rotate_y(door_rotation)



func calc_rand_y_door_position() -> int:
	var current_y: int = next_y_position.y
	var possible_locations = (int) (current_y / 4) - 1	
	print(possible_locations)
	return (randi_range(0, possible_locations) * 4) + 1


func calc_rand_x_door_position() -> int:
	var current_x: int = next_x_position.x
	var possible_locations = (int) (current_x / 4)- 1
	print(possible_locations)
	return (randi_range(0, possible_locations) * 4)+ 1


func prepare_blank_map() -> void:
	map = paked_blank_map.instantiate()
	get_tree().get_first_node_in_group("maps").add_child(map)



# that test method that spawns tiles in random order, to check random algorythmh
func generate_map() -> void:
	prepare_blank_map()
	
	for i in 20:
		set_current_dirrection_to_available_random()

		floor_part = packed_floor.instantiate()
		map.add_tile(floor_part)
		
		floor_part.global_position = Vector3(next_x_position.x, 0, next_x_position.y)
		
		if randi_range(0, 10) < 1:
			spawn_dead_end(current_direction)
			
		next_x_position += (current_direction*2)


# method encapsulates all updates and other logic related to random pick
func set_current_dirrection_to_available_random() -> void:
	update_dirrections_cd()
	directions = basic_directions.duplicate()
	current_direction = pick_random()
	update_available_dirrections()

# add availability cd for new dirrection oposite dir
func update_available_dirrections() -> void:
	match current_direction:
		Vector2.LEFT: 
			availability[Vector2.RIGHT] = AVAILABILITY_CD
		Vector2.RIGHT:
			availability[Vector2.LEFT] = AVAILABILITY_CD
		Vector2.DOWN:
			availability[Vector2.UP] = AVAILABILITY_CD
		Vector2.UP: 
			availability[Vector2.DOWN] = AVAILABILITY_CD

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


func spawn_dead_end(not_allowed_dir: Vector2) -> void:
	var dead_end_dir: Vector2 = pick_random()
	while (dead_end_dir == not_allowed_dir):
		print("I recalculate the dead end dirrection (very low possibility)")
		dead_end_dir = pick_random()
	update_available_dirrections()
	floor_part = packed_floor.instantiate()
	map.add_tile(floor_part)
	var dead_end_pos = next_x_position + (dead_end_dir*2)
	floor_part.global_position = Vector3(dead_end_pos.x, 0, dead_end_pos.y)

func calculate_room_size() -> void:
	var variants: int = MAX_ROOM_SIZE / 4
	var current_x_multiplier: int = randi_range(1, variants)
	var current_y_multiplier: int = randi_range(1, variants)
	room_size = Vector2(CORE_TILE_SIZE * current_x_multiplier, CORE_TILE_SIZE * current_y_multiplier)
	print(room_size)
