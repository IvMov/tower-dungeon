class_name Player
extends CharacterBody3D


@onready var animation_player = $AnimationPlayer
@onready var camera_scene = $CameraScene
@onready var player_model = $"character-human"
@onready var jump_gap_timer = $JumpTimer
@onready var weapon = $"character-human/Skeleton3D/Weapon"
@onready var agr_area = $AgrArea


@export var packed_projectile_test: PackedScene

var player_name: String
var last_frame_was_on_floor: bool = true
var jumps: int = 0
var move_direction: Vector3 = Vector3.ZERO

func _ready():
	player_name = "test" # TODO: create simple creation screen with nickname
	GameEvents.emit_change_game_stage(1)
	agr_area.body_entered.connect(on_body_entered)
	agr_area.body_exited.connect(on_body_exited)
	agr_area.area_entered.connect(on_area_entered)
	agr_area.area_exited.connect(on_area_exited)
	#camera_scene.rotation.y = 3.14/2



func _physics_process(delta):
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	velocity.x = move_direction.x * PlayerParameters.current_speed * delta
	velocity.z = move_direction.z * PlayerParameters.current_speed * delta
	
	# if player change state is_on_floor - then need to handle this event (gives possibility to press jump after not on flor for a while)
	if last_frame_was_on_floor != is_on_floor():
		handle_jump_gap()
	last_frame_was_on_floor = is_on_floor();
	
	# animations and falling calculation
	if is_on_floor():
		animation_player.play("walk" if move_direction else "idle")
	else:
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta
		
	move_and_slide()


func _unhandled_input(event):
	# right click
	handle_aiming(event)
	# shift
	handle_run(event)
	# space
	handle_jump(event)
	# movement
	handle_mouse_rotations(event)
	# left click
	handle_skill_use(event)
	

func handle_mouse_rotations(event: InputEvent):
	move_player(event)


func move_player(event: InputEvent):
	if event is InputEventMouseMotion && event.relative.y + event.relative.x != 0:
		rotate_y(-event.relative.x * GameConfig.get_mouse_sensetivity())
		var new_angle = camera_scene.get_rotation().x - event.relative.y * GameConfig.get_mouse_sensetivity();
		if new_angle < GameConfig.MAX_MOUSE_ROTATION_X && new_angle > -GameConfig.MAX_MOUSE_ROTATION_X:
			camera_scene.rotation.x = new_angle


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
	# TODO: REFACTOR!!!!! its mess but it works!
	if event.is_action_pressed("skill_use"):
		var stone = packed_projectile_test.instantiate()
		get_parent().add_child(stone)
		var cursor = get_viewport().get_mouse_position();
		var ray_origin = camera_scene.camera_3d.project_ray_origin(cursor)
		var ray_normal = camera_scene.camera_3d.project_ray_normal(cursor)

		var params = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal*50)
		var collision = get_world_3d().direct_space_state.intersect_ray(params)
		var some_distance: int
		if collision:
			some_distance = collision.position.distance_to(ray_origin)
			if some_distance < 10:
				some_distance = 10
		else: 
			some_distance = 100
		
		var cursor_world_position = ray_origin + ray_normal * some_distance
		

		var proj_direction = (cursor_world_position - weapon.global_position).normalized()
		
		stone.direction = proj_direction
		stone.global_position = weapon.global_position + proj_direction*0.1
		print(global_position)


func handle_aiming(event: InputEvent):
	if event.is_action_pressed("aiming_mode"):
		camera_scene.aiming_mode_in()
	elif event.is_action_released("aiming_mode"):
		camera_scene.aiming_mode_out()
	

		
func do_jump(power: float):
	animation_player.play("jump")
	jumps += 1
	var fiz_delta = get_physics_process_delta_time()
	velocity.y = power * fiz_delta
	velocity.x = move_direction.x * PlayerParameters.current_air_speed * fiz_delta
	velocity.z = move_direction.z * PlayerParameters.current_air_speed * fiz_delta


func handle_jump_gap():
	if is_on_floor():
		jump_gap_timer.stop()
		jumps = 0	
	else: 
		jump_gap_timer.start()


func on_body_entered(body: Node3D):
	print("SDD1")


func on_body_exited(body: Node3D):
	print("exited body")


func on_area_entered(area: Area3D):
	var area_owner: Node3D = area.get_parent()
	if area_owner is BasicEnemy:
		area_owner.detect_target(self)
	print("entered area")


func on_area_exited(area: Area3D):
	var area_owner: Node3D = area.get_parent()
	if area_owner is BasicEnemy:
		area_owner.lost_target()
	print("exited")
