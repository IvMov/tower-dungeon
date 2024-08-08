class_name ColumnBuilder extends Node3D

@export var packed_column: PackedScene
@export var step: int = 5

const CORE_TILE_SIZE: int = 2

func add_columns(room:Room, map: BlankMap) -> void:
	var x_num = round(room.size.x / step)
	var y_num = round(room.size.x / step)
	if x_num * y_num == 0: 
		print("OMG > to small room for columns")
		return
	for i in x_num-1:
		for j in y_num-1:
			var coordinates: Vector2 = Vector2(room.start_point.x + step * ((i+1) * CORE_TILE_SIZE) , room.start_point.y + step * ((j+1)* CORE_TILE_SIZE))
			var column: Node3D = packed_column.instantiate()
			map.add_tile(column)
			column.rotate_y(randf_range(-PI, PI))
			column.global_position = Vector3(coordinates.x, 0, coordinates.y)
	
