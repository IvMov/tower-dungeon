class_name WallEnemy extends BasicEnemy

@onready var spawn_enemy_controller: SpawnEnemyController = $SkillBox/SpawnEnemyController
var is_player_near: bool = false

#spawner related spagetti
var spawn_distance: float = 4
var min_height: float = -1.5
var max_height: float = 1.5
var spawn_rate: float = 0.4

func _ready():
	agr_radius = 8

func _physics_process(_delta):
	pass

func push_back(_player_position: Vector3, _push_power: float) -> void:
	print("PUSH YOURSELF! I'm static!")

func agr_on_player() -> void:
	print("Agr yourself!")
	pass

func detect_target(_target_player: Player) -> void:
	spawn_enemy_controller.cast_stopped = false
	spawn_enemy_controller.start_cast()
	print("wALL DETECTS me")
	is_player_near = true

func get_damage(_damager_location: Vector3, value: float, _push_power: float) -> bool:
	value = value if is_player_near else value/5
	return health_component.minus(value)

func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
	is_player_near = false
