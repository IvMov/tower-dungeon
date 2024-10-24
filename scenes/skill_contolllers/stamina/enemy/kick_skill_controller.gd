class_name KickSkillController extends BaseController

@export var enemy: BasicEnemy

func _ready():
	skill = Skill.new()
	skill.base_value = randf_range(2, 5)
	skill.base_energy_cost = 1

func do_damage() -> float:
	if enemy.is_dying:
		return 0
	damage_player()
	enemy.is_fighting = true
	
	return skill.base_value

func damage_player() -> void:
	cooldown_timer.start()
	if enemy.stamina_component.minus(skill.base_energy_cost):
		GameEvents.emit_damage_player(skill.base_value)
		EnemyParameters.add_exp(enemy.enemy_name, skill.base_value)
		enemy.animation_player.play("attack-kick-left" if randf() > 0.5 else "attack-kick-right")
	else:
		print("NO STAMINA -_-")
		# animate - no stamina

func stop_damage() -> void:
	cooldown_timer.stop()
	enemy.is_fighting = false

func _on_cooldown_timer_timeout():
	damage_player()
