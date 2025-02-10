class_name TierVampireEnemy extends BasicEnemy

@onready var character_vampire_2: Node3D = $"Body/character-vampire2"
@onready var dodge_skill_controller: DodgeSkillController = $Body/SkillBox/DodgeSkillController
@onready var idle_moving_controller: IdleMovingController = $Body/SkillBox/IdleMovingController
@onready var call_other_enemies_controller: CallOtherEnemiesController = $Body/SkillBox/CallOtherEnemiesController
@onready var vampire_range_attack_controller: VampireRangeAttackController = $Body/SkillBox/VampireRangeAttackController

@onready var body_mesh: MeshInstance3D = $"Body/character-vampire2/character-vampire/root/torso"

func _ready():
	is_ranged = true
	run_speed = speed * 2
	agr_radius = 8
	
	battle_distance = agr_radius+2
	
	
	chase_player_timer.wait_time = randi_range(2, 5)
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)
	#choose_color()
	vampire_range_attack_controller.cooldown_timer.start()
	vampire_range_attack_controller.skill.base_value *= multiply_characteristics()

func _physics_process(delta: float) -> void:
	is_runing = false
	super._physics_process(delta)

func choose_color() -> void:
	var material = body_mesh.get_surface_override_material(0)
	material.albedo_color = Color(randf(), randf(), randf())	


# targeting and movement
func detect_target(target_player: Player):
	is_target_detected = true
	player = target_player
	idle_moving_controller.stop_skill()
	chase_player_timer.stop()
	expand_agr_area_size()
	call_other_enemies_controller.use_skill()
	
	vampire_range_attack_controller.damage_player()
	
	

func agr_on_player():
	super.agr_on_player()
	call_other_enemies_controller.use_skill()

func push_back(player_position: Vector3, push_power: float) -> void:
	if is_runing:
		stamina_component.plus(dodge_skill_controller.skill.base_energy_cost)
		is_runing = false
	super.push_back(player_position, push_power)
	
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


func _on_speed_up_timer_timeout():
	if is_fighting:
		is_runing = false
		return
	if player:
		random_speed()
		speed_up_timer.start()
	else:
		is_runing = false
