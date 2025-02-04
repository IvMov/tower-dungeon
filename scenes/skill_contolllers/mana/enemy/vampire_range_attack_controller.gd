class_name VampireRangeAttackController extends BaseController

@export var enemy: BasicEnemy
@export var spark_projectile: PackedScene

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
	if player_position == Vector3.ZERO:
		return
	
	if enemy.mana_component.minus(skill.base_energy_cost):
		GameEvents.emit_damage_player(skill.base_value)
		EnemyParameters.add_exp(enemy.enemy_name, skill.base_value)
		player_position.y += 0.5
		var projectile: SparkProjectile = spark_projectile.instantiate()
		
		projectiles_box.add_child(projectile)
		enemy.animation_player.play("attack-melee-right")
		projectile.damage = skill.base_value
		projectile.push_power = 0
		projectile.speed = 50
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
	enemy.is_fighting = false

func _on_cooldown_timer_timeout():
	if enemy.player && enemy.navigation_agent_3d.distance_to_target() <= enemy.battle_distance:
		do_damage()
	elif enemy.player && enemy.is_fighting && enemy.navigation_agent_3d.distance_to_target() > enemy.battle_distance:
		stop_damage()
	cooldown_timer.start()
