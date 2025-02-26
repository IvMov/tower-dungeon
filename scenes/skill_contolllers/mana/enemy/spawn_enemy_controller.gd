class_name SpawnEnemyController extends BaseController


@export var owner_enemy: BasicEnemy
@export var enemies: Array[PackedScene]
@export var projectile: PackedScene

@onready var enemy_box: Node = get_tree().get_first_node_in_group("enemies")
@onready var ray_cast_3d: RayCast3D = $RayCast3D

var fast_cast: bool = false
var attemts: int = 0
var next_enemy_position: Vector3
var positions: Array[Vector3]
var cast_stopped: bool = false
var is_boss_spawner: bool = false


func _ready():
	skill = Skill.new()
	
	#skill.base_cast_time = 3
	#skill.base_cooldown = 2
	skill.base_energy_cost = 5
	
	skill.base_cast_time = owner_enemy.spawn_rate * 2
	skill.base_cooldown = owner_enemy.spawn_rate
	idle_timer.wait_time = skill.base_cast_time
	cast_timer.wait_time = skill.base_cast_time
	cooldown_timer.wait_time = skill.base_cooldown

func get_sign() -> int:
	return -1 if randf() <0.5 else 1
	
func start_boost_cast(num: int) -> void:
	fast_cast = true
	for i in num:
		start_cast()
	idle_timer.start()
	await idle_timer.timeout
	for i in num:
		use_skill()
	if owner_enemy.is_player_near:
		cast_timer.start()
	fast_cast = false

func cast_lot(num: int) -> void:
	for i in num:
		start_cast()

func start_cast() -> void:
	if !fast_cast && !owner_enemy.mana_component.minus(skill.base_energy_cost):
		skill_cast_finished = false
	else:
		skill_cast_finished = true
		#TODO: play cast animation 
		#TODO: REFACTOR THIS STUF
		next_enemy_position = calc_enemy_position(owner_enemy.spawn_distance, owner_enemy.min_height, owner_enemy.max_height)
		var tween = create_tween()
		var proj_inst = projectile.instantiate()
		enemy_box.add_child(proj_inst)
		proj_inst.global_position = global_position
		
		proj_inst.life_timer.wait_time = skill.base_cast_time
		proj_inst.life_timer.stop()
		proj_inst.life_timer.start()
		tween.tween_property(proj_inst, "global_position", next_enemy_position, skill.base_cast_time-0.3)
		tween.tween_property(proj_inst, "scale", Vector3.ONE * 2, 0.3)
		positions.append(next_enemy_position)
	if !fast_cast:
		cast_timer.start()
		


func stop_casting() -> void:
	cast_stopped = true

func use_skill() -> void:
	if !owner_enemy:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
		return
	var enemy_packed: PackedScene = enemies.pick_random()
	if !enemy_packed:
		print("ERROR: NO ENEMIES IN ENEMY SPAWN CONTROLLER")
		return
	
	if !positions.is_empty():
		var inst: BasicEnemy = enemy_packed.instantiate()
		inst.is_boss = is_boss_spawner
		enemy_box.add_child(inst)
		
		inst.global_position = positions.pop_front()
		if randf() < 0.5:
			inst.agr_on_player()
	else: 
		print("ERROR: not found position for next enemy!")
	if cooldown_timer.is_stopped():
		cooldown_timer.start()

func calc_enemy_position(max_distanse: float, min_height: float, max_height: float) -> Vector3:
	var target: Vector3 = global_position + Vector3(randf_range(0.1, max_distanse) * get_sign(), randf_range(min_height, max_height), randf_range(0.1, max_distanse) * get_sign())
	# spend lot of time - TARGET_POSITION is not TARGET but direction VECTOR between target AND SOURCE!
	ray_cast_3d.set_target_position(target - global_position)
	ray_cast_3d.force_raycast_update()
	if !ray_cast_3d.get_collider():
		attemts = 0
		return target
	else:
		attemts+=1
		if(attemts > 10):
			print("ERROR: FIX ME - CANT SPAWN ENEMIES NORMALY, TOO MUCH TRIES!")
			return Vector3.ONE
		return calc_enemy_position(max(1, max_distanse - 1), min_height, max_height)


func _on_cast_timer_timeout() -> void:
	if fast_cast:
		use_skill()
		attemts = 0
		return
	if skill_cast_finished:
		use_skill()
		skill_cast_finished = false
		cooldown_timer.start()
	elif !cast_stopped:
		start_cast()
	if cast_stopped:
		cooldown_timer.stop()
		cast_timer.stop()
	attemts = 0


func _on_cooldown_timer_timeout() -> void:
	start_cast()
