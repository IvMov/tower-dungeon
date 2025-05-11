class_name ColumnBuilder extends Node3D

@export var packed_column: PackedScene
@export var packed_stone: PackedScene
@export var packed_crystal: PackedScene
@export var step: int = 16



func add_columns(room:Room, map: BlankMap) -> void:
	var x_num = (round(room.size.x * Constants.CORE_TILE_SIZE / step) - 2)
	var x_margin = room.size.x * Constants.CORE_TILE_SIZE - x_num * step
	var y_num = round((room.size.y * Constants.CORE_TILE_SIZE) / step) - 2
	var y_margin = room.size.y * Constants.CORE_TILE_SIZE - y_num * step
	if x_num * y_num <= 0: 
		print("MapGen EXCEPTION: OMG > to small room for columns")
		return
	var coordinates: Vector2 = Vector2(room.start_point.x + x_margin/2, room.start_point.y + y_margin/2)
	if x_num == 1:
		coordinates+= Vector2(step/2, 0)
	if y_num == 1: 
		coordinates+= Vector2(0, step/2)
	for i in x_num:
		for j in y_num:
			add_column(coordinates, map, room.exit == Vector2.ZERO)
			coordinates+=Vector2(0, step)
		coordinates+=Vector2(step, 0)
		coordinates.y = room.start_point.y + y_margin/2


func add_column(coordinates: Vector2, map: BlankMap, is_deadend: bool)-> void:
	var column: Node3D = packed_column.instantiate()
	map.add_tile(column)
	column.rotate_y(randf_range(-PI, PI))
	column.global_position = Vector3(coordinates.x + randi_range(-2, 2), 0, coordinates.y + randi_range(-2, 2))
	add_crystals(is_deadend, column)
	add_stones(is_deadend, column)
	
func add_crystals(is_deadend: bool, column: Node3D) -> void:
	if (is_deadend && randf() > 0.2) || (!is_deadend && randf() > 0.8): 
		for i in randi_range(0, 7 if is_deadend else 2):
			var crystal: Node3D = packed_crystal.instantiate()
			column.add_child(crystal)
			crystal.rotate_random()
			var crystal_position = column.global_position + Vector3(rand_sign() * 0.6, randf_range(0, 2),rand_sign() * 0.6)
			var item_bulk: ItemBulk = ItemBulk.new(Constants.items_pool[Constants.ITEM_CRYSTAL_ID], randi_range(1, 5))
			GameEvents.emit_item_add(Vector3(2, 0, 0), item_bulk ,crystal_position)

func add_stones(is_deadend: bool, column: Node3D) -> void:
	if (is_deadend && randf() > 0.2) || (!is_deadend && randf() > 0.8): 
		for i in randi_range(0, 7 if is_deadend else 2):
			var stone_position = column.global_position + Vector3(rand_sign() * (0.55 + randf()), 0,rand_sign() * (0.55 + randf()))
			var item_bulk: ItemBulk = ItemBulk.new(Constants.items_pool[Constants.ITEM_STONE_ID], randi_range(1, 20))
			GameEvents.emit_item_add(Vector3(2, 0, 0), item_bulk ,stone_position)


func rand_sign() -> int:
	return -1 if randf() > 0.5 else 1
