class_name DashSkillController extends BaseController

@export var player: Player;

var speed: float
var is_dashing: bool 

func _ready() -> void:
	skill = preload("res://resources/skills/stamina/dash.tres")
	cast_timer.wait_time = skill.base_duration

func use_skill() -> void:
	if player.move_direction == Vector3.ZERO:
		return
	if !cooldown_timer.is_stopped() || !cast_timer.is_stopped():
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.ON_CD)
		return
	if !player.stamina_component.minus(skill.base_energy_cost):
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.NO_STAMINA)
	else:
		is_dashing = true
		player.is_immune_to_damage = true
		player.set_collision_mask_value(11, false)
		player.set_collision_layer_value(10, false)
		speed = PlayerParameters.current_speed
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED * skill.base_value
		cast_timer.start()

func stop_skill() -> void:
	if is_dashing:
		player.is_immune_to_damage = false
		player.set_collision_mask_value(11, true)
		player.set_collision_layer_value(10, true)
		idle_timer.stop()
		is_dashing = false
		PlayerParameters.current_speed = speed
		cooldown_timer.start()

func _on_cast_timer_timeout() -> void:
	stop_skill()
	
