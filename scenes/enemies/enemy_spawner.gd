class_name EnemySpawner extends BasicEnemy

@onready var spawn_enemy_controller: SpawnEnemyController = $SkillBox/SpawnEnemyController
var is_player_near: bool = false
var boost_cast: bool = true
var boost_enemies_num: int
var spawn_distance: float = 10

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
		boost_cast = false
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
		
	else:
		spawn_enemy_controller.start_cast()
	is_player_near = true

func get_damage(damager_location: Vector3, value: float, push_power: float) -> bool:
	if boost_cast:
		boost_cast = false
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
		value = value if is_player_near else value/3
	return health_component.minus(value)

func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
	is_player_near = false
