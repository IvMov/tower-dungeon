class_name  RangeAttackController extends BaseController

@export var enemy: BasicEnemy
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


func _ready():
	gpu_particles_3d.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	gpu_particles_3d.process_material.direction = Vector3.FORWARD
	skill = Skill.new()
	skill.base_value = randf_range(0.5, 2)
	skill.base_energy_cost = 0.3

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
	player_position.y += 0.5
	if enemy.stamina_component.minus(skill.base_energy_cost):
		GameEvents.emit_damage_player(skill.base_value)
		EnemyParameters.add_exp(enemy.enemy_name, skill.base_value)
		enemy.animation_player.play("pick-up")
		gpu_particles_3d.global_transform.origin = player_position
		gpu_particles_3d.look_at(global_transform.origin, Vector3.UP)
		gpu_particles_3d.process_material.direction = Vector3.FORWARD
		if !gpu_particles_3d.emitting:
			gpu_particles_3d.emitting = true
		else:
			gpu_particles_3d.restart()
		
		print("emmit? ")
		print(gpu_particles_3d.emitting)
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
		print("damage?")
	elif enemy.player && enemy.is_fighting && enemy.navigation_agent_3d.distance_to_target() > enemy.battle_distance:
		stop_damage()
	cooldown_timer.start()
	print("timeout? ")


func _on_cast_timer_timeout() -> void:
	pass

func _on_idle_timer_timeout() -> void:
	pass
