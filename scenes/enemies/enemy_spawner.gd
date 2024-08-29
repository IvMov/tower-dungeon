class_name EnemySpawner extends BasicEnemy

@onready var spawn_enemy_controller = $SkillBox/SpawnEnemyController
var is_player_near: bool = false
var boost_cast: bool = true
var boost_enemies_num: int

func _ready():
	agr_radius = 8

func _physics_process(delta):
	pass

func push_back(player_position: Vector3, push_power: float) -> void:
	print("PUSH YOURSELF! I'm static!")

func agr_on_player() -> void:
	print("Agr yourself! I'm spawner - i'm not chasing player")

func detect_target(target_player: Player) -> void:
	if boost_cast:
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
		boost_cast = false
	else:
		spawn_enemy_controller.start_cast()
	is_player_near = true


func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
	is_player_near = false
