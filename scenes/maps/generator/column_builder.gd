class_name ColumnBuilder extends Node3D

@export var packed_column: PackedScene
@export var step: int = 16


func add_columns(room:Room, map: BlankMap) -> void:
	var x_num = (round(room.size.x * Constants.CORE_TILE_SIZE / step) - 2)
	var x_margin = room.size.x * Constants.CORE_TILE_SIZE - x_num * step
	var y_num = round((room.size.y * Constants.CORE_TILE_SIZE) / step) - 2
	var y_margin = room.size.y * Constants.CORE_TILE_SIZE - y_num * step
	if x_num * y_num <= 0: 
		print("OMG > to small room for columns")
		return
	var coordinates: Vector2 = Vector2(room.start_point.x + x_margin/2, room.start_point.y + y_margin/2)
	if x_num == 1:
		coordinates+= Vector2(step/2, 0)
	if y_num == 1: 
		coordinates+= Vector2(0, step/2)
	for i in x_num:
		for j in y_num:
			add_column(coordinates, map)
			coordinates+=Vector2(0, step)
		coordinates+=Vector2(step, 0)
		coordinates.y = room.start_point.y + y_margin/2


func add_column(coordinates: Vector2, map: BlankMap)-> void:
	var column: Node3D = packed_column.instantiate()
	map.add_tile(column)
	column.rotate_y(randf_range(-PI, PI))
	column.global_position = Vector3(coordinates.x + randi_range(-2, 2), 0, coordinates.y + randi_range(-2, 2))
