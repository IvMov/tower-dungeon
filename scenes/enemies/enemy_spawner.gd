class_name EnemySpawner extends BasicEnemy

@onready var spawn_enemy_controller = $SkillBox/SpawnEnemyController


func push_back(player_position: Vector3, push_power: float) -> void:
	print("PUSH YOURSELF! I'm static!")

func detect_target(target_player: Player) -> void:
	spawn_enemy_controller.start_cast()


func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
