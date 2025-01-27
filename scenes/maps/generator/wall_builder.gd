class_name WallBuilder extends Node3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var timer: Timer = $Timer

# WallBuilder - can build walls around the room, avoiding tunels with height of 4 m
const WALL_TUNEL_MARGIN: float = Constants.WALL_HALF + Constants.CORE_TILE_SIZE/2

@export var packed_wall_20: PackedScene
@export var packed_wall_16: PackedScene
@export var walls_color: Color

var wall_front: Node3D
var wall_back: Node3D

func add_walls(room: Room, map: BlankMap) -> void:
	timer.start() # give time to create previous tiles or parts
	await timer.timeout
	var wall_front_pos = room.start_point + Vector2(0, -Constants.CORE_TILE_SIZE/2 - Constants.WALL_HALF)
	var wall_back_pos = room.start_point + Vector2(0, room.size.y*Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2 + Constants.WALL_HALF)
	var is_ocupied: bool
	var y_position: int
	
	for i in room.size.x:
		# front side
		if i != 0:
			wall_front_pos += Vector2(Constants.CORE_TILE_SIZE, 0)
		is_ocupied = check_is_ocupied_position(room, wall_front_pos)
		y_position = 4 if is_ocupied else 0
		wall_front = instantiate_wall(is_ocupied)
		map.add_tile(wall_front)
		wall_front.global_position = Vector3(wall_front_pos.x, y_position, wall_front_pos.y)
		wall_front.rotate_y(PI/2)
		# back side
		if i != 0:
			wall_back_pos += Vector2(Constants.CORE_TILE_SIZE, 0)
		is_ocupied = check_is_ocupied_position(room, wall_back_pos)
		y_position = 4 if is_ocupied else 0
		wall_back = instantiate_wall(is_ocupied)
		map.add_tile(wall_back)
		wall_back.global_position = Vector3(wall_back_pos.x, y_position, wall_back_pos.y)
		wall_back.rotate_y(PI/2)
		

	wall_front_pos = room.start_point + Vector2(-Constants.CORE_TILE_SIZE/2 - Constants.WALL_HALF, 0)
	wall_back_pos = room.start_point + Vector2(room.size.x*Constants.CORE_TILE_SIZE - Constants.CORE_TILE_SIZE/2 + Constants.WALL_HALF, 0)
	
	for i in room.size.y:
		# front side
		if i != 0:
			wall_front_pos += Vector2(0, Constants.CORE_TILE_SIZE)
			wall_back_pos += Vector2(0, Constants.CORE_TILE_SIZE)
		is_ocupied = check_is_ocupied_position(room, wall_front_pos)
		y_position = 4 if is_ocupied else 0
		wall_front = instantiate_wall(is_ocupied)
		map.add_tile(wall_front)
		wall_front.global_position = Vector3(wall_front_pos.x, y_position, wall_front_pos.y)
		
		is_ocupied = check_is_ocupied_position(room, wall_back_pos)
		wall_back = instantiate_wall(is_ocupied)
		map.add_tile(wall_back)
		y_position = 4 if is_ocupied else 0
		wall_back.global_position = Vector3(wall_back_pos.x, y_position, wall_back_pos.y)

#returns ready to locate wall
func instantiate_wall(is_ocupied: bool) -> Node3D:
	var wall: Node3D = packed_wall_20.instantiate() if !is_ocupied else packed_wall_16.instantiate()
	recolor_wall(wall)
	
	return wall

#recolor walls to active color of the stage
func recolor_wall(wall: Node3D) -> void:
	wall.get_child(0).get_active_material(0).albedo_color = walls_color

func check_is_ocupied_position(_room: Room, desired_position: Vector2) -> bool:
	ray_cast_3d.transform.origin = Vector3(desired_position.x, 6, desired_position.y)
	ray_cast_3d.set_target_position(Vector3(desired_position.x, 2, desired_position.y) - ray_cast_3d.global_position)
	ray_cast_3d.force_raycast_update()

	return ray_cast_3d.is_colliding()
