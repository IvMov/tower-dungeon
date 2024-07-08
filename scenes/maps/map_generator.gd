class_name MapGenerator extends Node3D

@export var packed_floor: PackedScene
@export var packed_tunel: PackedScene
@export var paked_blank_map: PackedScene


var next_x_position: Vector2 = Vector2.ZERO
var next_y_position: Vector2 = Vector2(0, 2)
var avaliability_cd: int = 5 # how long steps the oposite tile could not be installed

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


func _ready():
	generate_map()
	#generate_level()
	
	#map_inst.bake_navigation()


# that test method that spawns tiles in random order, to check random algorythmh
func generate_map() -> void:
	prepare_blank_map()
	
	for i in 20:
		# handle cd of availability dirrections 
		for dir in availability:
			if availability[dir] > 0:
				availability[dir]-=1

		# handle cd of availability dirrections 
		directions = basic_directions.duplicate()
		current_direction = pick_random()

		# add availability cd for new dirrection oposite dir
		match current_direction:
			Vector2.LEFT: 
				availability[Vector2.RIGHT] = avaliability_cd
			Vector2.RIGHT:
				availability[Vector2.LEFT] = avaliability_cd
			Vector2.DOWN:
				availability[Vector2.UP] = avaliability_cd
			Vector2.UP: 
				availability[Vector2.DOWN] = avaliability_cd

		floor_part = packed_floor.instantiate()
		map.add_tile(floor_part)
		
		floor_part.global_position = Vector3(next_x_position.x, 0, next_x_position.y)
		
		if randi_range(0, 10) < 1:
			spawn_additional_room(current_direction)
			
		next_x_position += (current_direction*2)

func pick_random() -> Vector2:
	if directions.is_empty():
		print("FCK - something wrong! CHECK SPAWNER OF MAP!")
		return Vector2(0, 0)
	directions.shuffle()
	var direction: Vector2 = directions.pop_front()
	if availability[direction] > 0:
		return pick_random()
	return direction


func spawn_additional_room(not_allowed_dir: Vector2) -> void:
	var dead_end_dir: Vector2 = pick_random()
	while (dead_end_dir == not_allowed_dir):
		print("I recalculate the dead end dirrection (very low possibility)")
		dead_end_dir = pick_random()

	floor_part = packed_floor.instantiate()
	map.add_tile(floor_part)
	var dead_end_pos = next_x_position + (dead_end_dir*2)
	floor_part.global_position = Vector3(dead_end_pos.x, 0, dead_end_pos.y)



func generate_level() -> void:
	prepare_blank_map()
	#generate_room(randf_range(4, 10), randf_range(4, 10))
	generate_room(8, 12)


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
	#choose_room_exit_direction
	var tuner_position: Vector2 = next_x_position + Vector2(1, calc_rand_y_door_position())
	var tunel = packed_tunel.instantiate()
	map.add_tile(tunel)
	tunel.global_position = Vector3(tuner_position.x, 0, tuner_position.y)
	print(next_x_position)
	print(next_y_position)


func calc_rand_y_door_position() -> int:
	var current_y: int = next_y_position.y
	print(current_y)
	var possible_locations = (int) (current_y / 4)	
	print(possible_locations)
	return (randi_range(0, possible_locations) * 4) + 1


func prepare_blank_map() -> void:
	map = paked_blank_map.instantiate()
	get_tree().get_first_node_in_group("maps").add_child(map)
