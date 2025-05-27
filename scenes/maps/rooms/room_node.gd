class_name RoomNode extends Node3D

@onready var timer: Timer = $Timer
var max_room_load: int
var room_load: int = 0
var times_to_skip: int = 0
var room: Room


func set_room(room: Room) -> void:
	self.room = room
	timer.wait_time = randf_range(3,6)
	timer.start()
	max_room_load = room.size.x + room.size.y

func _on_timer_timeout() -> void:
	if room_load >= max_room_load:
		print("INFO: no more additional enemies to spawn in this room")
		return
	var dist: float = (PlayerParameters.get_position() - global_position).length()
	dist = dist if dist > 0 else dist * -1
	if dist < 20:
		if times_to_skip < 3:
			times_to_skip+=1
			timer.wait_time = randf_range(3,6)
			timer.start()
			return
		if randf() < EnemyParameters.random_enemy_spawn_chance:
			room_load+=1
			var inst: BasicEnemy = Constants.TIER_0_ENEMY.instantiate()
			Constants.ENEMIES.add_child(inst)
			inst.coins_drop_component.set_coins(randi_range(0, 2 * EnemyParameters.drop_modifier))
			inst.global_position = global_position
			var rand_x: float = (room.size.x-1) * Constants.CORE_TILE_SIZE/2
			var rand_z: float = (room.size.y-1) * Constants.CORE_TILE_SIZE/2
			inst.global_position.x+=randf_range(-rand_x, rand_x)
			inst.global_position.y+=randf_range(0, 10)
			inst.global_position.z+=randf_range(-rand_z, rand_z)
			inst.agr_on_player()
	timer.wait_time = randf_range(2,5) + room_load
	timer.start()
