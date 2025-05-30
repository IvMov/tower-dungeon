class_name Tier0Enemy extends BasicEnemy

@onready var range_attack_controller: RangeAttackController = $Body/SkillBox/RangeAttackController
@onready var idle_moving_controller: IdleMovingController = $Body/SkillBox/IdleMovingController
@onready var call_other_enemies_controller: CallOtherEnemiesController = $Body/SkillBox/CallOtherEnemiesController
@onready var character_ghost_2: Node3D = $"Body/character-ghost2"
@onready var timer: Timer = $Timer
@onready var timer_disapear: Timer = $TimerDisapear

@onready var area_3d: Area3D = $"Body/character-ghost2/Area3D"
@onready var collision_shape_3d: CollisionShape3D = $"Body/character-ghost2/Area3D/CollisionShape3D"

@onready var torso: MeshInstance3D = $"Body/character-ghost2/character-ghost/root/torso"
@onready var arm_left: MeshInstance3D = $"Body/character-ghost2/character-ghost/root/torso/arm-left"
@onready var arm_right: MeshInstance3D = $"Body/character-ghost2/character-ghost/root/torso/arm-right"

var rand_a: float

func _ready():  
	is_ranged = true
	is_flying = true
	battle_distance = 10
	
	run_speed = speed * 2
	agr_radius = 8
	chase_player_timer.wait_time = randi_range(1, 10)
	hp_bar.update(health_component.current_value, health_component.max_value)
	stamina_bar.update(stamina_component.current_value, stamina_component.max_value)
	mana_bar.update(mana_component.current_value, mana_component.max_value)
	choose_color()
	range_attack_controller.cooldown_timer.start()
	if is_boss:
		range_attack_controller.skill.base_distance *= 2
	range_attack_controller.skill.base_value *= multiply_characteristics()
	choose_position()
	print("INFO: tier0 instantiated, speed: %s, health: %s, damage %s " % [speed, health_component.current_value, range_attack_controller.skill.base_value])

func choose_position() -> void: 
	var rand: float = randf_range(0.3, 2.5)
	if !is_boss:
		rand *= 2
	character_ghost_2.global_position.y = global_position.y + rand
	effect_flash_component.global_position.y = global_position.y + rand
	range_attack_controller.global_position.y = global_position.y + rand
	bars_box.global_position.y = global_position.y + rand - 0.05


func choose_color() -> void:
	var rand_color: Color = Color(randf_range(0.7,1.0), randf_range(0.7,1.0), randf_range(0.7,1.0), randf_range(0.4, 0.8))
	torso.get_surface_override_material(0).albedo_color = rand_color
	arm_left.get_surface_override_material(0).albedo_color = rand_color
	arm_right.get_surface_override_material(0).albedo_color = rand_color


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
	if !is_fighting:
		random_speed()
	call_other_enemies_controller.use_skill()


func lost_target():
	if is_dying:
		return
	speed_up_timer.stop()
	is_runing = false
	if agr_area.disable_mode: 
		return
	is_target_detected = false
	if chase_player_timer.is_inside_tree():
		chase_player_timer.start()


# timeout and area signals handling
func _on_chase_player_timer_timeout():
	super._on_chase_player_timer_timeout();
	
	if !is_target_detected:
		hide_bars()
		speed_up_timer.stop()
		is_runing = false
		reset_agr_area_size()
		idle_moving_controller.use_skill()


#change position verticaly randomly in some bounds
func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(2, 6)
	var rand: float = randf_range(0.8, 2.5)
	if is_boss:
		rand *= 2

	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(character_ghost_2, "global_position:y", global_position.y  + rand, 1.0)
	tween.tween_property(range_attack_controller, "global_position:y", global_position.y + rand, 1.0)
	var height: float = 3 if is_boss else 1
	tween.tween_property(effect_flash_component, "global_position:y", global_position.y + rand + height, 1.0)
	tween.tween_property(bars_box, "global_position:y", global_position.y + rand, 1.0)
	await tween.finished
	timer.start()
	


func _on_timer_disapear_timeout() -> void:
	rand_a = 0.01 if rand_a != 0.01 else randf_range(0.4,0.8)
	var tween: Tween = create_tween().set_parallel().set_ease(Tween.EASE_IN)
	tween.tween_property(torso.get_surface_override_material(0), "albedo_color:a", rand_a, 0.5)
	tween.tween_property(arm_left.get_surface_override_material(0), "albedo_color:a", rand_a, 0.5)
	tween.tween_property(arm_right.get_surface_override_material(0), "albedo_color:a", rand_a, 0.5)
	await tween.finished
	timer_disapear.wait_time = randf_range(1, 4) if rand_a == 0.01 else randf_range(6, 12)
	timer_disapear.start()
	
