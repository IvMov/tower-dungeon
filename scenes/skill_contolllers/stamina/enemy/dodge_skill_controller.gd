class_name DodgeSkillController extends BaseController

@export var enemy: BasicEnemy

func _ready():
	skill = Skill.new()
	skill.base_energy_cost = 3

func use_skill() -> void:
	if enemy.stamina_component.minus(skill.base_energy_cost): 
		enemy.is_runing = true
		enemy.is_dodging = true
		enemy.relocate_enemy()
		cooldown_timer.start()
	else:
		print("NO STAMINA -_-")
		# animate - no stamina

func _on_cooldown_timer_timeout() -> void:
	enemy.agr_on_player()

func _on_dodge_area_area_entered(_area: Area3D):
	if !enemy.is_runing:
		use_skill()
