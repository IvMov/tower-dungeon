class_name Tier1Enemy extends BasicEnemy

@onready var chase_player_timer = $Timers/ChasePlayerTimer

@onready var kick_skill_controller: KickSkillController = $SkillBox/KickSkillController
@onready var dodge_skill_controller: DodgeSkillController = $SkillBox/DodgeSkillController
@onready var idle_moving_controller: IdleMovingController = $SkillBox/IdleMovingController

func _ready():
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)

# damage things
func do_damage() -> float:
	print(global_position) 
	print(player.global_position)
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
	
func push_back(player_position: Vector3, push_power: float) -> void:
	if is_runing:
		stamina_component.plus(dodge_skill_controller.base_energy_cost)
		is_runing = false
	super.push_back(player_position, push_power)
	
func lost_target():
	if agr_area.disable_mode: 
		return
	is_target_detected = false
	chase_player_timer.start()

# timeout and area signals handling
func _on_chase_player_timer_timeout():
	if !is_target_detected:
		reset_agr_area_size()
		stop_enemy()
		player = null
		idle_moving_controller.use_skill()

