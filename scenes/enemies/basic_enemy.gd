class_name BasicEnemy extends CharacterBody3D
# How to extend?
# adjust bars global position
# add mesh with animation player and export it
# add skills to skillbox
# assign to skills the enemy
# assign to EffectFlashComponent the enemy meshes
# add missing animations to actions_animations and animation-player


@onready var agr_area = $AgrArea
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


@export var enemy_name: String
@export var speed: float
@export var animation_player: AnimationPlayer

var run_speed: float = speed * 1.5
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
var rotation_speed: float = 5
var idle_radius: float = 2

var can_move: bool = true
var is_runing: bool = false
var is_pushed: bool = false
var is_dying: bool = false
var is_fighting: bool = false
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
			current_speed = speed
	if !is_pushed:
		chase_player()
		current_speed = speed if !is_runing else run_speed
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
func detect_target(target_player: Player) -> void:
	# to be implemented in child regarding skills
	pass

func lost_target() -> void:
	# to be implemented in child regarding skills
	pass

func chase_player() -> void:
	if !player:
		return
	navigation_agent_3d.target_position = player.global_position
	var next_position = navigation_agent_3d.get_next_path_position()
	direction = (next_position - global_position).normalized()
	var target_rotation = (next_position - global_transform.origin).normalized()
	var current_rotation = global_transform.basis.z.normalized()
	var new_rotation = current_rotation.lerp(target_rotation, rotation_speed * get_physics_process_delta_time())
	look_at(global_transform.origin + new_rotation, Vector3.UP)
	self.rotate_object_local(Vector3.UP, PI)
	rotation.x = 0 # fix vertical rotation

func relocate_enemy() -> void:
	var target_point: Vector3 = Vector3(global_position.x + (idle_radius * randf() * get_random_sign()), global_position.y, global_position.z + (get_random_sign()* idle_radius * randf())) 
	direction = (target_point - transform.origin).normalized()
	var up = Vector3(0, 1, 0) # Assuming up is the Y-axis
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


# agr area handling
func expand_agr_area_size() -> void:
	agr_collision.shape.height = 8
	agr_collision.shape.radius = 8

func reset_agr_area_size() -> void:
	agr_collision.shape.height = 4
	agr_collision.shape.radius = 4


# trash
func custom_death_actions() -> void:
	# required by health component, welcome to spagetti code
	pass

func get_random_sign() -> int:
	return -1 if randf() <=0.5 else 1;


func _on_push_timer_timeout():
	is_pushed = false
