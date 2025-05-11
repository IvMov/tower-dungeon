class_name SparkPermanentController extends Node3D

@onready var cast_timer: Timer = $CastTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var spark_projectile: SparkProjectile = $SparkProjectile
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var projectile_packed: PackedScene
var dmg: float
var distance: float 
var enemies: Array[BasicEnemy]
var target_enemy: BasicEnemy
var spark_position_factor: int
var spark_position_factor_x: float = 0
var spark_position_factor_z: float = 0

func _ready() -> void:
	cooldown_timer.wait_time = PlayerParameters.player_data["spark_permanent"]["cd"]
	cooldown_timer.wait_time+= randf_range(-0.1, 0.1)
	cast_timer.wait_time+= randf_range(-0.1, 0.1)
	dmg = PlayerParameters.player_data["spark_permanent"]["dmg"]
	distance = PlayerParameters.player_data["spark_permanent"]["distance"]
	collision_shape_3d.shape.radius = distance
	spark_projectile.set_disabled()
	caalc_factors()
	print()
	spark_projectile.global_position.x+= spark_position_factor_x
	spark_projectile.global_position.z+= spark_position_factor_z

func caalc_factors() -> void:
	match spark_position_factor:
		0, 1:
			spark_position_factor_x = -.5 if spark_position_factor == 1 else .5
		2, 3:
			spark_position_factor_z = -.5 if spark_position_factor == 3 else .5


func _on_cooldown_timer_timeout() -> void:
	if enemies.is_empty():
		cooldown_timer.start()
		return
	else:
		cast_timer.start()
		print(enemies)
		enemies.shuffle()
		target_enemy = enemies.get(0)
		


func _on_cast_timer_timeout() -> void:
	if target_enemy && !target_enemy.is_dying:
			var tween: Tween = create_tween()
			tween.tween_property(spark_projectile, "scale", Vector3.ONE * 3, randf_range(0.1, 0.2))
			tween.tween_property(spark_projectile, "scale", Vector3.ONE, randf_range(0.05, 0.1))
			animation_player.play("orbit")
			var projectile: SparkProjectile = projectile_packed.instantiate()
			var start: Vector3 = PlayerParameters.player.global_position
			var end: Vector3 = target_enemy.global_position
			if target_enemy.is_flying:
				end = target_enemy.character_ghost_2.global_position
			end.y += .2
			
			start.y -= .2
			var proj_direction: Vector3 = (end - start).normalized()
			Constants.PROJECTILES.add_child(projectile)
			projectile.damage = dmg * PlayerParameters.damage_boost
			projectile.push_power = 50
			projectile.speed = 20
			projectile.direction = proj_direction
			projectile.global_position = global_position
	cooldown_timer.start()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !area.get_parent() || !area.get_parent().get_parent():
		return
	var body: Node = area.get_parent().get_parent().get_parent();
	if body is BasicEnemy:
		enemies.append(body)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is BasicEnemy:
		enemies.append(body)
	


func _on_area_3d_area_exited(area: Area3D) -> void:
	if !area.get_parent() || !area.get_parent().get_parent():
		return
	var body: Node = area.get_parent().get_parent().get_parent();
	if body is BasicEnemy:
		enemies.remove_at(enemies.find(body))


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is BasicEnemy:
		enemies.remove_at(enemies.find(body))
