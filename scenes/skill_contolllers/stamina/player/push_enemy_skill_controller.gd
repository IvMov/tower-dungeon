class_name PushEnemySkillController extends BaseController

@onready var area_3d = $Area3D

func use_skill() -> void:
	var bodies = area_3d.get_overlapping_bodies()
	for body in bodies:
		if body is BasicEnemy:
			body.push_back(global_position, 300)

