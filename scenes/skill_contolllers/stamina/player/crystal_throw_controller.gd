class_name CrystalThrowController extends BaseController


@export var projectile_pack: PackedScene
@onready var projectiles_box: Node = get_tree().get_first_node_in_group("projectiles")
var player: Player
var cast_enabled: bool = false


func start_cast() -> void:
	cast_timer.wait_time = skill.base_cast_time
	cooldown_timer.wait_time = skill.base_cooldown
	
	if is_idle:
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.IDLE)
	elif !player.stamina_component.minus(skill.base_energy_cost):
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.NO_MANA)
	else:
		cast_enabled = true
		skill_cast_finished = true
		finish_cast()
		is_idle = true
		if skill.is_consumable:
			GameEvents.emit_item_consumed(hand, skill.id)


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
	player.mana_component.plus(skill.base_energy_cost * 0.8)
	super.revert_cast()


func use_skill() -> void:
	if !player:
		print("NO OWNER NODE SETTED TO CONTROLLER")
		return
	
	var projectile: CrystalProjectile = projectile_pack.instantiate()
	var proj_direction: Vector3 = calc_projectile_direction()
	
	projectiles_box.add_child(projectile)
	player.animation_player.play("attack-melee-right")
	projectile.damage = calc_projectile_damage()
	projectile.push_power = skill.base_push_value
	projectile.skill_id = skill.id
	projectile.global_position = player.camera_scene.get_camera_position() + proj_direction * player.camera_scene.get_camera_distance() * 1.01
	projectile.apply_central_impulse(proj_direction * calc_projectile_speed())
	if projectile.global_position.y <= 0:
		projectile.global_position = player.camera_scene.get_camera_position() + proj_direction * 1.01
	

func calc_projectile_damage() -> float:
	#TODO: implement upgrade influence system
	return skill.base_value


func calc_projectile_speed() -> float:
	#TODO: implement upgrade influence system
	return skill.base_speed


func calc_projectile_direction() -> Vector3:
	var cursor: Vector2 = get_viewport().get_mouse_position();
	var ray_origin: Vector3 = player.camera_scene.camera_3d.project_ray_origin(cursor)
	var ray_normal: Vector3 = player.camera_scene.camera_3d.project_ray_normal(cursor)
	var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal*100)
	var collision: Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
	var distance_to_target: int = collision.position.distance_to(ray_origin) if collision else 100
	var cursor_world_position = ray_origin + ray_normal * distance_to_target
	
	return (cursor_world_position - player.camera_scene.get_camera_position()).normalized();
