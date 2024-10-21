class_name CallOtherEnemiesController extends BaseController

@onready var collision_shape_3d = $CallArea/CollisionShape3D


func _ready():
	skill = Skill.new()
	skill.base_energy_cost = 3

func use_skill() -> void:
	if cooldown_timer.is_stopped():
		var tween: Tween = create_tween()
		tween.tween_property(collision_shape_3d.shape, "radius", 10.0, 1.0)
		tween.tween_property(collision_shape_3d.shape, "radius", 0.1, 1.0)
	cooldown_timer.start()
