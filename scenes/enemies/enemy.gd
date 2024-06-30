class_name BasicEnemy extends CharacterBody3D

@onready var animation_player = $"character-orc2/AnimationPlayer"
@onready var agr_area = $AgrArea
@onready var agr_collision = $AgrArea/AgrCollision
@onready var ray_cast_3d = $RayCast3D

@onready var chase_player_timer = $Timers/ChasePlayerTimer
@onready var navigation_agent_3d = $NavigationAgent3D

@onready var health_component: HealthComponent = $StatsBox/HealthComponent
@onready var mana_component: ManaComponent = $StatsBox/ManaComponent
@onready var stamina_component: StaminaComponent = $StatsBox/StaminaComponent

@onready var hp_bar: Healthbar = $BarsBox/HPBar
@onready var stamina_bar: StaminaBar = $BarsBox/StaminaBar

@onready var soul_component: SoulComponent = $SoulComponent
@onready var souls_drop_component: SoulsDropComponent = $SoulsDropComponent

@onready var kick_skill_controller: KickSkillController = $SkillBox/KickSkillController
@onready var dodge_skill_controller: DodgeSkillController = $SkillBox/DodgeSkillController
@onready var idle_moving_controller: IdleMovingController = $SkillBox/IdleMovingController

var enemy_name: String = "tier_1_enemy"
var speed: float = 150.0
var run_speed: float = speed * 1.5
var current_speed: float = speed
var damage: float = randf()*2 + 1
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

var is_runing: bool = false
var is_dying: bool = false
var is_fighting: bool = false
var is_target_detected: bool = false


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

	chase_player()
	accelerate_to_player(delta)
	move_and_slide()

# damage things
func do_damage() -> float:
	return kick_skill_controller.do_damage()

func stop_damage() -> void:
	kick_skill_controller.stop_damage()

func get_damage(value: float) -> bool:
	return health_component.minus(value)


# targeting and movement
func detect_target(target_player: Player):
#need to refactor cause now enemy chase player infinitelly
	is_target_detected = true
	player = target_player
	idle_moving_controller.stop_skill()
	chase_player_timer.stop()
	expand_agr_area_size()

func lost_target():
	if agr_area.disable_mode: 
		return
	is_target_detected = false
	chase_player_timer.start()

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
	current_speed = speed if !is_runing else run_speed
	velocity.x = direction.x * current_speed * delta
	velocity.z = direction.z * current_speed * delta

func stop_enemy():
	direction = Vector3.ZERO
	velocity = Vector3.ZERO


# agr area handling
func expand_agr_area_size():
	agr_collision.shape.height=8
	agr_collision.shape.radius=8

func reset_agr_area_size():
	agr_collision.shape.height = 4
	agr_collision.shape.radius = 4


# trash
func custom_death_actions():
	# required by health component, welcome to spagetti code
	pass

func get_random_sign() -> int:
	return -1 if randf() <=0.5 else 1;


# timeout and area signals handling
func _on_chase_player_timer_timeout():
	print(is_target_detected)
	if !is_target_detected:
		reset_agr_area_size()
		stop_enemy()
		player = null
		idle_moving_controller.use_skill()



