class_name RunSkillController extends BaseController
# No resource controller

@export var player: Player;

var is_run: bool = false

func _ready():
	skill = Skill.new()
	skill.base_energy_cost = 1 # todo:create normal skill .tres

func use_skill_with_event(event: InputEvent):
	if event.is_action_pressed("speed_up"):
		use_skill()
	elif event.is_action_released("speed_up"):
		stop_skill()


func use_skill() -> void:
	if is_idle: 
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.IDLE)
	elif PlayerParameters.lock_stamina_skill:
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.LOCK)
	elif !player.stamina_component.minus(skill.base_energy_cost):
		GameEvents.emit_skill_call_failed(skill.id, Enums.SkillCallFailedReason.NO_STAMINA)
	else:
		is_run = true
		PlayerParameters.lock_stamina_skill = true
		cooldown_timer.start()
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED * PlayerParameters.MOVE_SPEED_UP_MOD
		GameEvents.emit_run_player(PlayerParameters.current_speed)

func stop_skill() -> void:
	if is_run:
		is_run = false
		if !cooldown_timer.is_stopped():
			cooldown_timer.stop()
		PlayerParameters.lock_stamina_skill = false
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED
		GameEvents.emit_run_player(PlayerParameters.current_speed)
		

func _on_cooldown_timer_timeout() -> void:
	if player.stamina_component.minus(skill.base_energy_cost):
		cooldown_timer.start()
	else:
		GameEvents.emit_run_player(PlayerParameters.current_speed)
		stop_skill()
