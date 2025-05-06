class_name FireBladeTrapController extends BaseController

@export var projectile_packed: PackedScene

var player: Player
var cast_enabled: bool = false

func start_cast() -> void:
	cast_timer.wait_time = skill.base_cast_time
	cooldown_timer.wait_time = skill.base_cooldown
	
	if is_on_cooldown: 
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.ON_CD)
	elif !player.mana_component.minus(skill.base_energy_cost):
		# TODO: create energy component and health component abstraction layer with minus plus and etc methods.
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.NO_MANA)
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
	damage_boost = PlayerParameters.damage_boost
	var projectile: FireBladeTrapProjectile = projectile_packed.instantiate()
	var proj_direction: Vector3 = calc_projectile_direction()
	Constants.PROJECTILES.add_child(projectile)
	player.animation_player.play("attack-melee-right")
	projectile.damage = calc_projectile_damage()
	projectile.push_power = skill.base_push_value
	projectile.speed = calc_projectile_speed()
	projectile.skill_id = skill.id
	projectile.radius = calc_distance()
	projectile.direction = proj_direction
	projectile.fire_dmg = calc_fire_dmg()
	projectile.rotation_speed = calc_speed()
	var camera_position: Vector3 = player.camera_scene.get_camera_position()
	var camera_distance: float = (player.global_position - camera_position).length()
	projectile.global_position = camera_position + proj_direction * camera_distance * 0.95
	projectile.apply_central_impulse(proj_direction * calc_projectile_speed())
	super.cooldown()

func calc_distance() -> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return skill.base_distance + (skill.distance_per_lvl * skill_exp_data["lvl"])

func calc_speed() -> float:
	#use distance x2 as speed of rotation
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return skill.base_distance * 2 + (skill.distance_per_lvl * skill_exp_data["lvl"])


func calc_fire_dmg() -> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return (skill.base_fire_dmg_value + (skill.base_fire_dmg_per_lvl * skill_exp_data["lvl"])) * damage_boost * (1 + calc_num_of_items()/10)


func calc_projectile_speed() -> float:
	#TODO: implement upgrade influence system
	return skill.base_speed


func calc_projectile_direction() -> Vector3:
	return player.camera_scene.calc_direction()
