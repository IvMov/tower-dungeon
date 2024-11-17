class_name SparkController extends BaseController

@export var spark_projectile: PackedScene
@onready var projectiles_box: Node = get_tree().get_first_node_in_group("projectiles")
var player: Player
var cast_enabled: bool = false


func start_cast() -> void:
	cast_timer.wait_time = skill.base_cast_time
	cooldown_timer.wait_time = skill.base_cooldown
	
	if is_idle: 
		print("IDLE")
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.IDLE)
	elif !player.mana_component.minus(skill.base_energy_cost):
		print("NO MANA")
		# TODO: create energy component and health component abstraction layer with minus plus and etc methods.
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.NO_MANA)
	else:
		cast_enabled = true
		#TODO: play cast animation 
		#no cast required it's instant skill
		skill_cast_finished = true
		finish_cast()
		is_idle = true
		

func finish_cast() -> void:
	if !cast_enabled:
		return
	cast_enabled = false
	super.finish_cast()
	if skill_cast_finished:
		use_skill()
		skill_cast_finished = false
	else:
		revert_cast()
	is_idle = false

func revert_cast() -> void:
	player.mana_component.plus(skill.base_energy_cost*0.8)
	super.revert_cast()


func use_skill() -> void:
	if !player:
		print("NO OWNER NODE SETTED TO CONTROLLER")
		return
	var projectile: SparkProjectile = spark_projectile.instantiate()
	var proj_direction: Vector3 = calc_projectile_direction()
	
	projectiles_box.add_child(projectile)
	player.animation_player.play("attack-melee-right")
	projectile.damage = calc_projectile_damage()
	projectile.push_power = skill.base_push_value
	projectile.speed = calc_projectile_speed()
	projectile.skill_id = skill.id
	projectile.direction = proj_direction
	projectile.global_position = player.camera_scene.get_camera_position() + proj_direction * player.camera_scene.get_camera_distance() * 1.01
	if projectile.global_position.y <= 0:
		projectile.global_position = player.camera_scene.get_camera_position() + proj_direction * 1.01
	

func calc_projectile_damage() -> float:
	#TODO: implement upgrade influence system
	return skill.base_value


func calc_projectile_speed() -> float:
	#TODO: implement upgrade influence system
	return skill.base_speed


func calc_projectile_direction() -> Vector3:
	return player.camera_scene.calc_direction()
