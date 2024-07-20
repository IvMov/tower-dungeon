class_name Room extends Node

var id: int
var previous_room_id: int
var floor_height: int
var ceil_height: int
var entrance: Vector2
var exit: Vector2
var deadend_exit: Vector2
var size: Vector2
var start_point: Vector2

func _to_string():
	return "room: \
	{id: %d, previous_room_id: %d, floor_height: %d, \
	ceil_height: %d, entrance: %s, exit: %s, deadend_exit: %s size: %s, start_point: %s \
	}"  % [id, previous_room_id, floor_height, ceil_height, entrance, exit, deadend_exit, size,start_point]
