class_name SparkController extends BaseController

@export var spark_projectile: PackedScene
@onready var projectiles_box: Node = get_tree().get_first_node_in_group("projectiles")

func use_skill(player: Player) -> void:
	if !player:
		return
	var projectile: SparkProjectile = spark_projectile.instantiate()
	var proj_direction: Vector3 = calc_projectile_direction(player)
	
	projectiles_box.add_child(projectile)
	player.animation_player.play("attack-melee-right")
	projectile.damage = calc_projectile_damage()
	projectile.speed = calc_projectile_speed()
	projectile.direction = proj_direction
	projectile.global_position = player.camera_scene.get_camera_position() + proj_direction  * player.camera_scene.get_camera_distance() * 1.2

func calc_projectile_damage() -> float:
	#TODO: implement upgrade influence system
	return base_value


func calc_projectile_speed() -> float:
	#TODO: implement upgrade influence system
	return base_speed


func calc_projectile_direction(player: Player) -> Vector3:
	var cursor: Vector2 = get_viewport().get_mouse_position();
	var ray_origin: Vector3 = player.camera_scene.camera_3d.project_ray_origin(cursor)
	var ray_normal: Vector3 = player.camera_scene.camera_3d.project_ray_normal(cursor)
	var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal*100)
	var collision: Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
	var distance_to_target: int = collision.position.distance_to(ray_origin) if collision else 100
	var cursor_world_position = ray_origin + ray_normal * distance_to_target
	
	return (cursor_world_position - player.camera_scene.get_camera_position()).normalized();
