class_name Tier1Enemy extends BasicEnemy

@onready var kick_skill_controller: KickSkillController = $SkillBox/KickSkillController
@onready var dodge_skill_controller: DodgeSkillController = $SkillBox/DodgeSkillController
@onready var idle_moving_controller: IdleMovingController = $SkillBox/IdleMovingController
@onready var call_other_enemies_controller: CallOtherEnemiesController = $SkillBox/CallOtherEnemiesController
@onready var battle_move_controller: BattleMoveController = $SkillBox/BattleMoveController

func _ready():
	run_speed = speed * 2
	agr_radius = 8
	chase_player_timer.wait_time = randi_range(1, 10)
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)

func chase_player() -> void:
	super.chase_player()
	if player && is_instance_valid(player) && !is_battle_move && battle_move_radius >= global_position.distance_to(player.global_position):
		battle_move_controller.use_skill()
	
# damage things
func do_damage() -> float:
	battle_direction_when_radial = get_random_sign()
	return kick_skill_controller.do_damage()

func stop_damage() -> void:
	kick_skill_controller.stop_damage()

# targeting and movement
func detect_target(target_player: Player):
	is_target_detected = true
	player = target_player
	idle_moving_controller.stop_skill()
	chase_player_timer.stop()
	expand_agr_area_size()
	call_other_enemies_controller.use_skill()
	

func agr_on_player():
	super.agr_on_player()
	call_other_enemies_controller.use_skill()

func push_back(player_position: Vector3, push_power: float) -> void:
	if is_runing:
		stamina_component.plus(dodge_skill_controller.base_energy_cost)
		is_runing = false
	super.push_back(player_position, push_power)
	
func lost_target():
	speed_up_timer.stop()
	is_runing = false
	if agr_area.disable_mode: 
		return
	is_target_detected = false
	chase_player_timer.start()
	battle_move_controller.stop_skill()


# timeout and area signals handling
func _on_chase_player_timer_timeout():
	super._on_chase_player_timer_timeout();
	
	if !is_target_detected:
		speed_up_timer.stop()
		is_runing = false
		reset_agr_area_size()
		idle_moving_controller.use_skill()

