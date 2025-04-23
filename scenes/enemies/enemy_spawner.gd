class_name EnemySpawner extends BasicEnemy

@onready var spawn_enemy_controller: SpawnEnemyController = $Body/SkillBox/SpawnEnemyController
@onready var timer: Timer = $Timer
@onready var spawner_body: MeshInstance3D = $Body/SpawnerBody
@onready var check_player: Timer = $CheckPlayer

const MAX_PLAYER_DISTANCE: int = 150

var is_temporary: bool = false
var is_player_near: bool = false
var is_boss_spawner: bool = false
var boost_cast: bool = true
var boost_enemies_num: int

#spawner related spagetti
var spawn_distance: float = 7
var min_height: float = -5
var max_height: float = 5
var spawn_rate: float = 1

func _ready():
	coins_drop_component.set_coins(randi_range(5,10))
	if is_temporary:
		check_player.wait_time = randf_range(4, 6)
		check_player.start()
	agr_radius = 8

func _physics_process(_delta):
	if !animation_player.is_playing():
		animation_player.play("idle")

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

func get_damage(_damager_location: Vector3, value: float, _push_power: float, fire_dmg: float = 0, acid_dmg: float = 0) -> bool:
	if !bars_box.visible:
		bars_box.visible = true
	if boost_cast:
		boost_cast = false
		spawn_enemy_controller.start_boost_cast(boost_enemies_num)
	elif !is_player_near:
		spawn_enemy_controller.start_boost_cast(1)
	value = value if is_player_near else value/5
	animation_player.play("idle")
	if fire_dmg != 0:
		set_in_fire(fire_dmg)
	if acid_dmg != 0:
		set_in_acid(acid_dmg)
	return health_component.minus(value)

func lost_target() -> void:
	spawn_enemy_controller.stop_casting()
	is_player_near = false
	hide_bars()

func spawn_and_disapear() -> void:
	spawn_enemy_controller.is_boss_spawner = is_boss_spawner
	await spawn_enemy_controller.start_boost_cast(boost_enemies_num)
	queue_free()

#change position verticaly randomly in some bounds
func _on_timer_timeout() -> void:
	var rand: float = randf_range(2, 4)
	timer.wait_time = rand

	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(enemy_collision, "global_position:y", global_position.y  + rand, 1.0)
	tween.tween_property(body, "global_position:y", global_position.y + rand, 1.0)
	tween.tween_property(spawner_body, "global_position:y", global_position.y + rand, 1.0)
	tween.tween_property(spawner_body, "rotation", Vector3(rand/PI, rand/PI, rand/PI), 1.0)
	timer.start()


func _on_check_player_timeout() -> void:
	var player_position: Vector3 = PlayerParameters.get_position()
	if (global_position - player_position).length() < MAX_PLAYER_DISTANCE:
		spawn_and_disapear()
