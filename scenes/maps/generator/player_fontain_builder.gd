class_name PlayerFontainBuilder extends Node3D

@onready var shape_cast_3d = $ShapeCast3D
@export var packed_fontain: PackedScene
var base_fontain_cd: int = 1
var fontain_cd: int = 1
var attempts: int = 10

func add_fontain(room:Room, map: BlankMap, wall_enemy: WallEnemy) -> void: 
	fontain_cd -= 1
	if fontain_cd == 0:
		fontain_cd = base_fontain_cd
		put_fontain(room, map, wall_enemy)


func put_fontain(room:Room, map: BlankMap, wall_enemy: WallEnemy) -> void:
	if attempts <= 0:
		print("Too much tries, no fontain here, sorry!")
		return 
	var coord: Vector2 = Vector2(room.start_point.x + randf_range(1, room.size.x-1) * Constants.CORE_TILE_SIZE, room.start_point.y + randf_range(1, room.size.y-1) * Constants.CORE_TILE_SIZE)
	shape_cast_3d.global_position = Vector3(coord.x, 1.5, coord.y)
	shape_cast_3d.force_shapecast_update()
	attempts-=1
	if shape_cast_3d.is_colliding():
		put_fontain(room, map, wall_enemy)
	var fontain = packed_fontain.instantiate()
	map.add_object(fontain)
	fontain.global_position = shape_cast_3d.global_position
	fontain.fire.wall_enemy = wall_enemy
	fontain.rotation.y = randf_range(-PI, PI)
	shape_cast_3d.queue_free()
	attempts = 10
	
