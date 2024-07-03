class_name JumpSkillController extends BaseController

# No resource controller
@export var player: Player
var last_frame_was_on_floor: bool = true
var jumps: int = 0

func _physics_process(_delta):
# if player change state is_on_floor - then need to handle this event (gives possibility to press jump after not on floor for a while)
	handle_jump_gap()


func use_skill_with_event(event) -> void:
	var is_second_jump_possible = jumps > 0 && jumps < PlayerParameters.max_jumps
	if player.is_on_floor() || !idle_timer.is_stopped() || is_second_jump_possible:
		if jumps < PlayerParameters.max_jumps && event.is_action_pressed("big_jump"):
			do_jump(PlayerParameters.current_jump_velocity * PlayerParameters.JUMP_SPEED_UP_MOD)
		elif jumps < PlayerParameters.max_jumps && event.is_action_pressed("jump"):
			do_jump(PlayerParameters.current_jump_velocity)


func handle_jump_gap():
	if last_frame_was_on_floor != player.is_on_floor():
		if player.is_on_floor():
			idle_timer.stop()
			jumps = 0	
		else: 
			idle_timer.start()
	last_frame_was_on_floor = player.is_on_floor();



func do_jump(power: float):
	player.animation_player.play("jump")
	jumps += 1
	var fiz_delta = get_physics_process_delta_time()
	player.velocity.y = power * fiz_delta
	player.velocity.x = player.move_direction.x * PlayerParameters.current_air_speed * fiz_delta
	player.velocity.z = player.move_direction.z * PlayerParameters.current_air_speed * fiz_delta
