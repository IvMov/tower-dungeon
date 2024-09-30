class_name TorchBuilder extends Node3D


@export var torch_height: int = 5
@export var margin: float = 0.1
@export var torch_step: int = 12
@export var packed_torch: PackedScene


var old_remainder: float
var remainder: float 
var map: BlankMap

#API for build torch
func add_torches(room: Room, target_map: BlankMap)-> void:
	map = target_map
	
	#left side
	var torch_position = room.start_point + Vector2(-Constants.CORE_TILE_SIZE/2, -Constants.CORE_TILE_SIZE/2 + margin)
	var num: int = calc_num(room.size.x)
	place_torches(torch_position, num, 1, 1, 0)
	
	#front side
	torch_position = room.start_point + Vector2(room.size.x * Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2 - margin, -Constants.CORE_TILE_SIZE/2)
	num = calc_num(room.size.y)
	place_torches(torch_position, num, 1, 0, 1)

	#right side
	torch_position = room.start_point + Vector2(room.size.x * Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2, room.size.y * Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2 - margin)
	num = calc_num(room.size.x)
	place_torches(torch_position, num, -1, 1, 0)

	#back side
	torch_position = room.start_point + Vector2(-Constants.CORE_TILE_SIZE/2 + margin, room.size.y * Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2)
	num = calc_num(room.size.y)
	place_torches(torch_position, num, -1, 0, 1)
	


#  order ->  1 or -1 to achieve minus functionality(stepback order)
#  x_step and or y_step 1 yes 0 no
func place_torches(start_pos: Vector2, num: int, order: int, x_step: int, y_step: int) -> void:
	var core_step: float = Constants.CORE_TILE_SIZE * (torch_step - old_remainder)
	var torch_position: Vector2 = start_pos
	for i in num:
		torch_position += Vector2(core_step * x_step * order, core_step * y_step * order)
		create_torch(torch_position)
		if i == 0:
			core_step = Constants.CORE_TILE_SIZE * torch_step


func calc_num(side_length: float)-> int:
	old_remainder = remainder
	remainder = fmod(side_length + old_remainder, torch_step)
	return round((side_length + old_remainder - remainder) / torch_step)


func create_torch(torch_position: Vector2) -> void: 
	var torch: Node3D = packed_torch.instantiate()
	map.add_tile(torch)
	torch.global_position = Vector3(torch_position.x, torch_height, torch_position.y)
