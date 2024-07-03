class_name SpawnEnemyController extends BaseController


@export var owner_enemy: BasicEnemy
@export var enemies: Array[PackedScene]
@export var projectile: PackedScene

@onready var enemy_box: Node = get_tree().get_first_node_in_group("enemies")
@onready var ray_cast_3d = $RayCast3D

var attemts = 0
var next_enemy_position: Vector3

func _ready():
	idle_timer.start()
	base_cast_time = 3
	base_cooldown = 2
	base_energy_cost = 10

func get_sign() -> int:
	return -1 if randf() <0.5 else 1

func start_cast() -> void:
	cast_timer.wait_time = base_cast_time
	cooldown_timer.wait_time = base_cooldown
	
	if !owner_enemy.mana_component.minus(base_energy_cost):
		print(owner_enemy.mana_component.current_value)
		print("NO FCKING MANA")
		skill_cast_finished = false
		# TODO: create energy component and health component abstraction layer with minus plus and etc methods.
	else:
		skill_cast_finished = true
		#TODO: play cast animation 
		#TODO: REFACTOR THIS STUF
		next_enemy_position = calc_enemy_position()
		var tween = create_tween()
		var proj_inst = projectile.instantiate()
		enemy_box.add_child(proj_inst)
		proj_inst.global_position = global_position
		
		proj_inst.life_timer.wait_time = base_cast_time
		proj_inst.life_timer.stop()
		proj_inst.life_timer.start()
		tween.tween_property(proj_inst, "global_position", next_enemy_position, base_cast_time-0.3)
		tween.tween_property(proj_inst, "scale", Vector3.ONE * 2, 0.3)
	cast_timer.start()


func use_skill() -> void:
	if !owner_enemy:
		print("NO OWNER NODE SETTED TO CONTROLLER")
		return
	var enemy_packed: PackedScene = enemies.pick_random()
	if !enemy_packed:
		print("NO ENEMIES IN ENEMY SPAWN CONTROLLER")
		return
	var inst = enemy_packed.instantiate()
	enemy_box.add_child(inst)
	inst.global_position = next_enemy_position
	cooldown_timer.start()

func calc_enemy_position() -> Vector3:
	var target: Vector3 = global_position + Vector3(randf_range(0,10)*get_sign(), 5, randf_range(0,10) * get_sign())
	# spend lot of time - TARGET_POSITION is not TARGET but direction VECTOR between target AND SOURCE!
	ray_cast_3d.set_target_position(target - global_position)
	ray_cast_3d.force_raycast_update()
	if !ray_cast_3d.get_collider():
		return target
	else:
		attemts+=1
		if(attemts > 10):
			print("FIX ME - CANT SPAWN ENEMIES NORMALY, TOO MUCH TRIES!")
			return Vector3.ONE
		return calc_enemy_position()


func _on_cast_timer_timeout() -> void:
	if skill_cast_finished:
		use_skill()
		skill_cast_finished = false
		cooldown_timer.start()
	else:
		start_cast()
	attemts = 0


func _on_cooldown_timer_timeout() -> void:
	start_cast()


func _on_idle_timer_timeout() -> void:
	#temporary - replace with agr zone
	start_cast()
