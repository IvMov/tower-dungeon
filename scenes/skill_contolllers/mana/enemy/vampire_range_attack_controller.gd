class_name VampireRangeAttackController extends BaseController

@export var enemy: BasicEnemy
@export var vampire_projectile: PackedScene

@onready var projectiles_box: Node = get_tree().get_first_node_in_group("projectiles")


func _ready():
	skill = Skill.new()
	skill.base_value = randf_range(3, 5)
	skill.base_energy_cost = 1

func do_damage() -> float:
	if enemy.is_dying:
		return 0
	enemy.velocity = Vector3.ZERO
	damage_player()
	if !enemy.is_fighting:
		enemy.is_fighting = true
	return skill.base_value

func damage_player() -> void:
	var player_position: Vector3 = calc_player_position()
	print(player_position)
	if player_position == Vector3.ZERO:
		return

	
	if enemy.mana_component.minus(skill.base_energy_cost):
		player_position.y += 0.5
		var projectile: VampireProjectile = vampire_projectile.instantiate()
		
		projectiles_box.add_child(projectile)
		enemy.animation_player.play("attack-melee-right")
		projectile.damage = skill.base_value
		projectile.push_power = 0
		projectile.enemy_name = enemy.enemy_name
		projectile.speed = 10
		projectile.direction = (player_position - global_position).normalized()
		projectile.global_position = global_position
		
	else:
		print("NO STAMINA -_-")
		# animate - no stamina

func calc_player_position() -> Vector3:
	if enemy.player:
		return enemy.player.global_transform.origin
	return Vector3.ZERO


func stop_damage() -> void:
	print("stopped?")
	cast_timer.stop()
	idle_timer.stop()
	enemy.is_fighting = false
	enemy.ray_cast_3d.target_position.z = 1


#used for check is it possible to start damage timer
func _on_cooldown_timer_timeout():
	print("cooldown")
	if enemy.player && enemy.navigation_agent_3d.distance_to_target() <= enemy.battle_distance:
		do_damage()
		print("cooldown")
		enemy.ray_cast_3d.target_position.z = 10
		print(enemy.ray_cast_3d.target_position)
		if enemy.ray_cast_3d.get_collider():
			print("collider?")
			enemy.battle_direction_when_radial = enemy.get_random_sign()
			enemy.is_fighting = false
			enemy.is_side_move = true
		else:
			if enemy.is_side_move:
				enemy.battle_direction_when_radial = enemy.get_random_sign()
				enemy.is_fighting = true
				enemy.is_side_move = false
			cooldown_timer.wait_time = 0.5
		
		
	elif enemy.player && enemy.is_fighting && enemy.navigation_agent_3d.distance_to_target() >= enemy.battle_distance:
		stop_damage()
		cooldown_timer.wait_time = 1
	cooldown_timer.start()


#used for relocation
func _on_idle_timer_timeout() -> void:

	#how often vampire change his position in radial
	idle_timer.wait_time = randf_range(2, 4)
	print("idle called")

	if enemy.player && enemy.navigation_agent_3d.distance_to_target() <= enemy.battle_distance:
		idle_timer.start()
	#print( "z %f" % enemy.ray_cast_3d.target_position.z)
	#if enemy.is_fighting || enemy.ray_cast_3d.get_collider():
		#print("if?")
		#enemy.battle_direction_when_radial = enemy.get_random_sign()
		#enemy.is_fighting = false
		#enemy.is_side_move = true
		#cast_timer.stop()
	#else:
		#print("else")
		##THE PROBLEM IS THAT TOO SHORT MOVE IN SIDE
		#enemy.is_side_move = false
		#cast_timer.start()
	#enemy.ray_cast_3d.target_position.z = 1
	#idle_timer.start()
