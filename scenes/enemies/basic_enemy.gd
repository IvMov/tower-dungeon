class_name BasicEnemy extends CharacterBody3D
# How to extend?
# adjust bars global position
# add mesh with animation player and export it
# add skills to skillbox
# assign to skills the enemy
# assign to EffectFlashComponent the enemy meshes
# add missing animations to actions_animations and animation-player

@onready var call_enemy_area_client: Area3D = $CallEnemyAreaClient
@onready var agr_area: Area3D = $AgrArea
@onready var agr_collision = $AgrArea/AgrCollision
@onready var ray_cast_3d = $RayCast3D

@onready var navigation_agent_3d = $NavigationAgent3D

@onready var health_component: HealthComponent = $StatsBox/HealthComponent
@onready var mana_component: ManaComponent = $StatsBox/ManaComponent
@onready var stamina_component: StaminaComponent = $StatsBox/StaminaComponent

@onready var hp_bar: Healthbar = $BarsBox/HPBar
@onready var stamina_bar: StaminaBar = $BarsBox/StaminaBar
@onready var mana_bar: ManaBar = $BarsBox/ManaBar

@onready var soul_component: SoulComponent = $SoulComponent
@onready var souls_drop_component: SoulsDropComponent = $SoulsDropComponent
@onready var push_timer: Timer = $Timers/PushTimer
@onready var chase_player_timer: Timer = $Timers/ChasePlayerTimer
@onready var start_timer: Timer = $Timers/StartTimer
@onready var speed_up_timer = $Timers/SpeedUpTimer


@export var enemy_name: String
@export var speed: float
@export var animation_player: AnimationPlayer

var start_position: Vector3
var run_speed: float = speed * 2
var current_speed: float = speed
var actions_animations: Array[String] = [
	"attack-melee-right", 
	"attack-melee-left", 
	"take-damage-1", 
	"take-damage-2", 
	"die", 
	"sprint", 
	"fall"]

var player: Player
var direction: Vector3
var rotation_speed: float = 10
var idle_radius: float = 2
var agr_radius: float = 4
var angular_velocity: float = 1.0
var current_angle: float
var battle_move_radius: float =  randf_range(2, 6)
var battle_direction_when_radial: int = get_random_sign()

var can_move: bool = true
var is_runing: bool = false
var is_dodging: bool = false
var is_pushed: bool = false
var is_dying: bool = false
var is_fighting: bool = false

var is_battle_move: bool = false
var is_side_move: bool = false
var is_back_move: bool = false
var is_front_move: bool = false

var is_target_detected: bool = false


func _ready():
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)

func _physics_process(delta):
	if is_dying:
		return

	if is_runing:
		animation_player.play("sprint")

	if !is_on_floor():
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta
	
	if !actions_animations.has(animation_player.get_current_animation()):
		if !is_fighting:
			animation_player.play("walk" if velocity.length() > 0.1 else "idle")
	if ray_cast_3d.get_collider() && !player:
		relocate_enemy()
	if !is_pushed:
		current_speed = speed if !is_runing else run_speed
		current_speed = speed * 1.5 if is_dodging else current_speed
		chase_player()
	if player:
		accelerate_to_player(delta)
	move_and_slide()

# damage things
func do_damage() -> float:
	# to be implemented in child regarding skills
	return 0

func stop_damage() -> void:
	# to be implemented in child regarding skills
	pass

func get_damage(damager_location: Vector3, value: float, push_power: float) -> bool:
	if push_power > 0:
		push_back(damager_location, push_power)
	return health_component.minus(value)

func push_back(player_position: Vector3, push_power: float) -> void:
	direction = global_position - player_position
	current_speed = push_power
	is_pushed = true
	push_timer.start()

# targeting and movement
func detect_target(_target_player: Player) -> void:
	# to be implemented in child regarding skills
	pass

func lost_target() -> void:
	# to be implemented in child regarding skills
	pass

func agr_on_player() -> void:
	random_speed()
	if speed_up_timer.is_stopped():
		speed_up_timer.start()
	is_dodging = false
	player = get_tree().get_first_node_in_group("player")
	chase_player_timer.start()

func chase_player() -> void:
	if !player || is_dodging:
		return
	
	if speed_up_timer.is_stopped():
		speed_up_timer.start()
		random_speed()

	var next_position: Vector3
	if is_front_move:
		navigation_agent_3d.target_position = player.global_position
		next_position = navigation_agent_3d.get_next_path_position()
		direction = (next_position - global_position).normalized()
	elif is_back_move:
		current_speed = speed
		navigation_agent_3d.target_position = player.global_position
		next_position = navigation_agent_3d.get_next_path_position()
		direction = (next_position - global_position).normalized()
		direction = Vector3(-direction.x, direction.y, -direction.z)
	elif is_side_move: 
		current_speed = speed
		next_position = player.global_position
		direction = (next_position - global_position).normalized()
		direction = (next_position - global_position).normalized()
		direction = direction.rotated(Vector3.UP, battle_direction_when_radial * PI/2)
	else:
		navigation_agent_3d.target_position = player.global_position
		next_position = navigation_agent_3d.get_next_path_position()
		direction = (next_position - global_position).normalized()
	var target_rotation = (next_position - global_transform.origin).normalized()
	var current_rotation = global_transform.basis.z.normalized()
	var new_rotation = current_rotation.lerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	look_at(global_transform.origin + new_rotation, Vector3.UP)
	self.rotate_object_local(Vector3.UP, PI)
	rotation.x = 0 # fix vertical rotation

func relocate_enemy() -> void:
	if is_front_move || is_back_move || is_side_move:
		return
	current_speed = run_speed
	var target_point: Vector3 = Vector3(global_position.x + (idle_radius * randf() * get_random_sign()), global_position.y, global_position.z + (get_random_sign()* idle_radius * randf())) 
	direction = (target_point - transform.origin).normalized()
	var up = Vector3(0, 1, 0) 
	var right = up.cross(direction).normalized()
	var forward = direction
	var new_basis = Basis(right, up, forward)
	transform.basis = new_basis

func accelerate_to_player(delta: float) -> void:
	velocity.x = direction.x * current_speed * delta
	velocity.z = direction.z * current_speed * delta


func stop_enemy() -> void:
	direction = Vector3.ZERO
	velocity = Vector3.ZERO

func random_speed() -> void:
	is_runing = randf() < 0.2 && is_front_move
	

# agr area handling
func expand_agr_area_size() -> void:
	agr_collision.shape.radius = agr_radius * 2

func reset_agr_area_size() -> void:
	agr_collision.shape.radius = agr_radius


# trash
func custom_death_actions() -> void:
	# required by health component, welcome to spagetti code
	pass

func get_random_sign() -> int:
	return -1 if randf() <=0.5 else 1;


func _on_push_timer_timeout():
	is_pushed = false

func _on_chase_player_timer_timeout():
	if !is_target_detected:
		stop_enemy()
		player = null


func _on_call_enemy_area_client_area_exited(_area):
	if !is_dying && start_timer.is_stopped():
		agr_on_player()


func _on_speed_up_timer_timeout():
	random_speed()
	if player:
		speed_up_timer.start()
	else:
		is_runing = false
