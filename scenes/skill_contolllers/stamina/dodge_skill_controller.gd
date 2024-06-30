class_name DodgeSkillController extends BaseController

@export var enemy: BasicEnemy

func _ready():
	base_energy_cost = 3

func use_skill() -> void:
	if enemy.stamina_component.minus(base_energy_cost):
		enemy.is_runing = true
	
		enemy.relocate_enemy()
		cooldown_timer.start()
	else:
		print("NO STAMINA -_-")
		# animate - no stamina

func _on_cooldown_timer_timeout() -> void:
	enemy.is_runing = false
	enemy.player = get_tree().get_first_node_in_group("player")
	enemy.chase_player_timer.start()


func _on_dodge_area_area_entered(area):
	if !enemy.is_runing:
		use_skill()
		
