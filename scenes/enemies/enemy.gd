class_name BasicEnemy
extends CharacterBody3D

@onready var animation_player = $"character-orc2/AnimationPlayer"
@onready var agr_area = $AgrArea
@onready var agr_collision = $AgrArea/AgrCollision
@onready var ray_cast_3d = $RayCast3D

@onready var chase_player_timer = $Timers/ChasePlayerTimer
@onready var idle_moving_timer = $Timers/IdleMovingTimer
@onready var idle_cooldown_timer = $Timers/IdleCooldownTimer
@onready var navigation_agent_3d = $NavigationAgent3D


var speed: float = 90.0
var player: Player
var direction: Vector3
var rotation_speed: float = 5
var idle_radius: float = 2
var should_move: bool = true


func _ready():
	idle_cooldown_timer.wait_time = randf_range(2,4)
	idle_cooldown_timer.start()

func _physics_process(delta):
	if is_on_floor():
		animation_player.play("walk" if velocity.length() > 0.1 else "idle")
		if ray_cast_3d.get_collider() && !player:
			relocate_enemy(delta)
	else:
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta

	
	if player:
		chase_player(delta)
	move_and_slide()


func detect_target(target_player: Player):
	player = target_player
	idle_moving_timer.stop()
	idle_cooldown_timer.stop()
	chase_player_timer.stop()
	expand_agr_area_size()


func chase_player(delta:float):
	
	navigation_agent_3d.target_position = player.global_position
	
	#navigation_agent_3d.target_position = Vector3.ZERO
	var next_position = navigation_agent_3d.get_next_path_position()
	direction = (next_position - global_position).normalized()
	velocity.x = direction.x * speed * delta
	velocity.z = direction.z * speed * delta
	var target_rotation = (next_position - global_transform.origin).normalized()
	var current_rotation = global_transform.basis.z.normalized()
	var new_rotation = current_rotation.lerp(target_rotation, rotation_speed * delta)
	look_at(global_transform.origin + new_rotation, Vector3.UP)
	self.rotate_object_local(Vector3.UP, PI)
	rotation.x = 0 # fix vertical rotation


func lost_target():
	chase_player_timer.start()


func expand_agr_area_size():
	agr_collision.shape.height+=4
	agr_collision.shape.radius+=4


func reset_agr_area_size():
	agr_collision.shape.height = 4
	agr_collision.shape.radius = 4

func get_random_sign() -> int:
	return -1 if randf() <=0.5 else 1;

func stop_enemy():
	direction = Vector3.ZERO
	velocity = Vector3.ZERO

func relocate_enemy(delta: float) -> void:
	var target_point: Vector3 = Vector3(global_position.x + (idle_radius * randf() * get_random_sign()), global_position.y, global_position.z + (get_random_sign()* idle_radius * randf())) 
	direction = (target_point - transform.origin).normalized()
	var up = Vector3(0, 1, 0) # Assuming up is the Y-axis
	var right = up.cross(direction).normalized()
	var forward = direction
	var new_basis = Basis(right, up, forward)
	transform.basis = new_basis
	velocity.x = direction.x * speed * delta
	velocity.z = direction.z * speed * delta


func _on_chase_player_timer_timeout():
	reset_agr_area_size()
	player = null
	stop_enemy()
	idle_cooldown_timer.start()



func _on_idle_moving_timer_timeout():
	stop_enemy()
	idle_cooldown_timer.start()


func _on_idle_cooldown_timer_timeout():
	if should_move:
		relocate_enemy(get_physics_process_delta_time())
		idle_moving_timer.start()
	else:
		idle_cooldown_timer.start()
	should_move = !should_move
