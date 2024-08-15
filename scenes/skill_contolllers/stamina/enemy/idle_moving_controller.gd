class_name IdleMovingController extends BaseController

@export var enemy: BasicEnemy
var should_move: bool = false

func _ready():
	base_cooldown = 2
	base_cast_time = 3
	# cooldown - changes walking and not walking periods
	cooldown_timer.wait_time = randf_range(base_cooldown/2, base_cooldown*2)
	#cast is a "walking" timer
	cast_timer.wait_time = randf_range(base_cast_time/2, base_cast_time*2)

func use_skill() -> void:
	cooldown_timer.start()

func stop_skill() -> void:
	cast_timer.stop()
	cooldown_timer.stop()

func _on_cooldown_timer_timeout() -> void:
	if should_move:
		enemy.relocate_enemy()
		cast_timer.start()
	else:
		cooldown_timer.start()
	should_move = !should_move

func _on_cast_timer_timeout() -> void:
	enemy.stop_enemy()
	cooldown_timer.start()

