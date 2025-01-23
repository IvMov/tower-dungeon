class_name EnemySpawner extends BasicEnemy

@onready var spawn_enemy_controller: SpawnEnemyController = $SkillBox/SpawnEnemyController
var is_player_near: bool = false
var boost_cast: bool = true
var boost_enemies_num: int

#spawner related spagetti
var spawn_distance: float = 10
var min_height: float = 3
var max_height: float = 15
var spawn_rate: float = 1

func _ready():
	agr_radius = 8

func _physics_process(_delta):
	pass

func push_back(_player_position: Vector3, _push_power: float) -> void:
	pass

func agr_on_player() -> void:
	pass

func detect_target(_target_player: Player) -> void:
	if boost_cast:
		boost_cast = false
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
	else:
		spawn_enemy_controller.cast_stopped = false
		spawn_enemy_controller.start_cast()
	is_player_near = true

func get_damage(_damager_location: Vector3, value: float, _push_power: float) -> bool:
	if boost_cast:
		boost_cast = false
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
	
	elif !is_player_near:
		spawn_enemy_controller.start_boost_cast(1)
	value = value if is_player_near else value/5
	return health_component.minus(value)

func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
	is_player_near = false
