extends CharacterBody3D

@onready var animation_player = $AnimationPlayer
@onready var camera_scene = $CameraScene
@onready var player_model = $"character-human"
@onready var jump_gap_timer = $JumpTimer
@onready var muzzle_component = $MuzzleComponent
@onready var gun = $"character-human/Skeleton3D/Gun"


@export var packed_projectile_test: PackedScene

var player_name: String
var last_frame_was_on_floor: bool = true
var jumps: int = 0
var direction: Vector3 = Vector3.ZERO
var is_aming_mode: bool = false

func _ready():
	player_name = "test" # TODO: create simple creation screen with nickname
	GameEvents.emit_change_game_stage(1)
	#camera_scene.rotation.y = 3.14/2


func _physics_process(delta):
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	velocity.x = direction.x * PlayerParameters.current_speed
	velocity.z = direction.z * PlayerParameters.current_speed
	
	# if player change state is_on_floor - then need to handle this event (gives possibility to press jump after not on flor for a while)
	if last_frame_was_on_floor != is_on_floor():
		handle_jump_gap()
	last_frame_was_on_floor = is_on_floor();
	
	# animations and falling calculation
	if is_on_floor():
		animation_player.play("walk" if direction else "idle")
	else:
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta
	move_and_slide()
	

func _unhandled_input(event):
	handle_aiming(event)
	handle_run(event)
	handle_jump(event)
	handle_mouse_rotations(event)
	handle_skill_use(event)
	

func handle_mouse_rotations(event: InputEvent):
	if is_aming_mode:
		aim_weapon(event)
	else: 
		move_player(event)

	
func aim_weapon(event: InputEvent):
	if event is InputEventMouseMotion && event.relative.y + event.relative.x != 0:
		gun.rotate_x(event.relative.y * GameConfig.get_mouse_sensetivity())
		gun.rotate_y(-event.relative.x * GameConfig.get_mouse_sensetivity())

func move_player(event: InputEvent):
	if event is InputEventMouseMotion && event.relative.y + event.relative.x != 0:
		rotate_y(-event.relative.x * GameConfig.get_mouse_sensetivity())
		var new_angle = camera_scene.get_rotation().x - event.relative.y * GameConfig.get_mouse_sensetivity();
		if new_angle < GameConfig.MAX_MOUSE_ROTATION_X && new_angle > GameConfig.MIN_MOUSE_ROTATION_X:
			camera_scene.rotation.x = new_angle
			gun.rotate_x(event.relative.y * GameConfig.get_mouse_sensetivity())

func handle_run(event: InputEvent):
	if event.is_action_pressed("speed_up"):
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED * PlayerParameters.MOVE_SPEED_UP_MOD
	elif event.is_action_released("speed_up"):
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED


func handle_jump(event: InputEvent):
	var is_second_jump_possible = jumps > 0 && jumps < PlayerParameters.max_jumps
	if is_on_floor() || !jump_gap_timer.is_stopped() || is_second_jump_possible:
		if jumps < PlayerParameters.max_jumps && event.is_action_pressed("big_jump"):
			do_jump(PlayerParameters.current_jump_velocity * PlayerParameters.JUMP_SPEED_UP_MOD)
		elif jumps < PlayerParameters.max_jumps && event.is_action_pressed("jump"):
			do_jump(PlayerParameters.current_jump_velocity)


func handle_skill_use(event: InputEvent):
	if event.is_action_pressed("skill_use"):
		var stone = packed_projectile_test.instantiate()
		
		
		
		get_parent().add_child(stone)

		var projectile_direction: Vector3 = (gun.gun_body.global_position - gun.global_position).normalized()
		stone.direction = projectile_direction
		stone.global_position = gun.gun_body.global_position
		# TODO: add muzzle red dot on target when shooting (just trace in same dirrection ray and on collision - show muzzle


func handle_aiming(event: InputEvent):
	if event.is_action_pressed("aiming_mode"):
		is_aming_mode = true
	elif event.is_action_released("aiming_mode"):
		is_aming_mode = false
		gun.rotation = Vector3.ZERO
		

		
func do_jump(power: float):
	animation_player.play("jump")
	jumps += 1
	velocity.y = power * get_physics_process_delta_time()
	velocity.x = direction.x * PlayerParameters.current_air_speed
	velocity.z = direction.z * PlayerParameters.current_air_speed


func handle_jump_gap():
	if is_on_floor():
		jump_gap_timer.stop()
		jumps = 0	
	else: 
		jump_gap_timer.start()
