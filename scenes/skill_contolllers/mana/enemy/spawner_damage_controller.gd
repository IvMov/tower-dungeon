class_name SpawnerDamageController extends BaseController

@export var owner_enemy: BasicEnemy
@export var projectiles: Array[PackedScene]
var min: float = 0.5
var max: float = 3
var target_position: Vector3

func _ready() -> void:
	cast_timer.wait_time = randf_range(min, max)


func use_skill() -> void:
	if !owner_enemy:
		print("ERROR: NO OWNER NODE SETTED TO CONTROLLER")
		return
	var proj_packed: PackedScene = projectiles.pick_random()
	if !proj_packed:
		print("ERROR: NO ENEMIES IN ENEMY SPAWN CONTROLLER")
		return

	owner_enemy.animation_player.play("do_damage")
	var proj: Node3D = proj_packed.instantiate()
	Constants.PROJECTILES.add_child(proj)
	proj.global_position = PlayerParameters.get_position()
	proj.run()
	cast_timer.wait_time = randf_range(min, max)
	cast_timer.start()

func _on_cast_timer_timeout() -> void:
	var dist: float = (PlayerParameters.get_position() - global_position).length()
	dist = dist if dist > 0 else dist * -1
	if dist < 20:
		use_skill()
	else:
		cast_timer.wait_time = randf_range(min, max)
		cast_timer.start()
