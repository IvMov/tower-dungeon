class_name BattleMoveController extends BaseController

@export var enemy: BasicEnemy

var distance: float
var radial_moving_time: float
var direction: int
var kicks: int
var time_attack: float


func use_skill() -> void:
	cast_timer.wait_time = 4
	cooldown_timer.wait_time = 2
	idle_timer.wait_time = 2
	enemy.is_side_move = true
	cooldown_timer.start()
	enemy.is_battle_move = true

func stop_skill() -> void:
	# time spending in attack
	cast_timer.stop()
	# time of moving radial
	cooldown_timer.stop()
	# time returning to new radial startpoint
	idle_timer.stop()
	enemy.is_side_move = false
	enemy.is_back_move = false
	enemy.is_front_move = false
	enemy.is_battle_move = false

func _on_cooldown_timer_timeout() -> void:
	if !enemy.player:
		stop_skill()
	else:
		cast_timer.start()
		enemy.is_back_move = false
		enemy.is_side_move = false
		enemy.is_front_move = true
		cooldown_timer.wait_time = randf_range(1, 6)

func _on_cast_timer_timeout() -> void:
	if !enemy.player:
		stop_skill()
	else:
		enemy.is_back_move = true
		enemy.is_side_move = false
		enemy.is_front_move = false
		idle_timer.start()
		cast_timer.wait_time = randf_range(3, 6)


func _on_idle_timer_timeout():
	if !enemy.player:
		stop_skill()
	else:
		enemy.is_back_move = false
		enemy.is_front_move = false
		enemy.is_side_move = true
		cooldown_timer.start()
		idle_timer.wait_time = randf_range(1, 3)
