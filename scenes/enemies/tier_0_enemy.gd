class_name Tier0Enemy extends BasicEnemy

@onready var range_attack_controller: RangeAttackController = $Body/SkillBox/RangeAttackController
@onready var idle_moving_controller: IdleMovingController = $Body/SkillBox/IdleMovingController
@onready var call_other_enemies_controller: CallOtherEnemiesController = $Body/SkillBox/CallOtherEnemiesController
@onready var character_ghost_2: Node3D = $"Body/character-ghost2"


func _ready():  
	is_ranged = true
	is_flying = true
	battle_distance = 5
	run_speed = speed * 2
	agr_radius = 8
	chase_player_timer.wait_time = randi_range(1, 10)
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)
	#choose_color()
	choose_position()
	range_attack_controller.cooldown_timer.start()
	range_attack_controller.skill.base_value *= multiply_characteristics()
	print("INFO: tier0 instantiated, speed: %s, health: %s, damage %s " % [speed, health_component.current_value, range_attack_controller.skill.base_value])

func choose_position() -> void: 
	var rand: float = randf_range(0.3, 2.5)
	character_ghost_2.global_position.y = global_position.y + rand
	range_attack_controller.global_position.y = global_position.y + rand
	bars_box.global_position.y = global_position.y + rand - 0.05


#func choose_color() -> void:
	#var material = body_mesh.get_surface_override_material(0)
	#material.albedo_color = Color(randf(), randf(), randf())	


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


func lost_target():
	speed_up_timer.stop()
	is_runing = false
	if agr_area.disable_mode: 
		return
	is_target_detected = false
	chase_player_timer.start()


# timeout and area signals handling
func _on_chase_player_timer_timeout():
	super._on_chase_player_timer_timeout();
	
	if !is_target_detected:
		speed_up_timer.stop()
		is_runing = false
		reset_agr_area_size()
		idle_moving_controller.use_skill()
