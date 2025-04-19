class_name VampireRangeAttackController extends BaseController

@export var enemy: BasicEnemy
@export var vampire_projectile: PackedScene

@onready var projectiles_box: Node = get_tree().get_first_node_in_group("projectiles")

var cast_time: float

func _ready():
	skill = Skill.new()
	skill.base_value = randf_range(3, 5)
	skill.base_energy_cost = 1
	cast_time = cast_timer.wait_time

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
	if player_position == Vector3.ZERO:
		return

	
	if enemy.mana_component.minus(skill.base_energy_cost):
		player_position.y += 0.5
		var projectile: VampireProjectile = vampire_projectile.instantiate()
		
		projectiles_box.add_child(projectile)
		enemy.animation_player.play("attack-melee-right")
		projectile.damage = skill.base_value if !enemy.is_boss else skill.base_value * 2
		projectile.push_power = 0
		projectile.enemy_name = enemy.enemy_name
		projectile.speed = 10
		projectile.direction = (player_position - global_position).normalized()
		if enemy.is_boss:
			projectile.scale = Vector3.ONE * 2
		projectile.global_position = global_position
		
	else:
		print("NO STAMINA -_-")
		# animate - no stamina

func calc_player_position() -> Vector3:
	if enemy.player:
		return enemy.player.global_transform.origin
	return Vector3.ZERO


func stop_damage() -> void:
	idle_timer.stop()
	enemy.is_fighting = false
	enemy.ray_cast_3d.target_position.z = 1


#used for check is it possible to start damage timer
func _on_cooldown_timer_timeout():
	if enemy.player && enemy.navigation_agent_3d.distance_to_target() <= enemy.battle_distance:
		do_damage()
		
		cast_timer.start()
	else:
		cooldown_timer.start()
	


func _on_cast_timer_timeout() -> void: 
	if is_idle:
		idle_timer.start()
	elif enemy.player && enemy.navigation_agent_3d.distance_to_target() <= enemy.battle_distance:
		do_damage()
		cast_timer.wait_time = randf_range(cast_time/2, cast_time*2)
		cast_timer.start()
		if idle_timer.is_stopped():
			idle_timer.start()
	else: 
		stop_damage()
		cooldown_timer.start()
		
		
#used for relocation
func _on_idle_timer_timeout() -> void:
	idle_timer.wait_time = randf_range(1, 2)
	if !is_idle:
		enemy.ray_cast_3d.target_position.z = 10
		if enemy.ray_cast_3d.get_collider():
			is_idle = true
			enemy.battle_direction_when_radial = enemy.get_random_sign()
			enemy.is_fighting = false
			enemy.is_side_move = true
			enemy.ray_cast_3d.target_position.z = 1
	else:
		cast_timer.start()
		is_idle = false
		enemy.is_fighting = true
		enemy.is_side_move = false
	
