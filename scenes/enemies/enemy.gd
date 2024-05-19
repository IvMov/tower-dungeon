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
@onready var dodging_timer = $Timers/DodgingTimer
@onready var death_timer = $Timers/DeathTimer
@onready var do_damage_timer = $Timers/DoDamageTimer


var speed: float = 90.0
var damage: float = randf()*2 + 1
var damage_frequency: float = randf() + 0.2

var player: Player
var direction: Vector3
var rotation_speed: float = 5
var idle_radius: float = 2

var should_move: bool = true
var is_dodging: bool = false
var is_dying: bool = false
var is_fighting: bool = false


func _ready():
	idle_cooldown_timer.wait_time = randf_range(2,4)
	idle_cooldown_timer.start()
	#do_damage_timer.wait_time = damage_frequency

func _physics_process(delta):
	if is_dying:
		return
	if is_dodging && dodging_timer.is_stopped():
		dodging_timer.start()
		relocate_enemy(delta)
	if is_on_floor():
		if !is_fighting:
			animation_player.play("walk" if velocity.length() > 0.1 else "idle")
		if ray_cast_3d.get_collider() && !player:
			relocate_enemy(delta)
	else:
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta

	
	if player && dodging_timer.is_stopped():
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
	if agr_area.disable_mode:
		return
	chase_player_timer.start()

func do_damage() -> float:
	do_damage_timer.start()
	is_fighting = true
	
	return damage

func stop_damage() -> void:
	do_damage_timer.stop()
	is_fighting = false


func get_damage():
	is_dying = true
	agr_area.disable_mode = true
	death_timer.start()
	
	animation_player.play("die")
	await animation_player.animation_finished
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector3(global_position.x, global_position.y+2, global_position.z) , 0.3)
	

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
	var current_speed = speed*3 if is_dodging else speed
	velocity.x = direction.x * current_speed * delta
	velocity.z = direction.z * current_speed * delta


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


func _on_dodging_timer_timeout():
	is_dodging = false
	player = get_tree().get_first_node_in_group("player")
	chase_player(get_physics_process_delta_time())
	chase_player_timer.start()


func _on_dodge_area_area_entered(area):
	if dodging_timer.is_stopped():
		is_dodging = true


func _on_death_timer_timeout():
	queue_free()


func _on_do_damage_timer_timeout():
	print(do_damage_timer.wait_time)
	if is_dying:
		return
	GameEvents.emit_damage_player(damage)
	animation_player.play("attack-kick-left" if randf() > 0.5 else "attack-kick-right")
	
