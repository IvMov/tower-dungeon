class_name RunSkillController extends BaseController
# No resource controller

@export var player: Player;

func _ready():
	base_energy_cost = 1 # todo:create normal skill .tres

func use_skill_with_event(event: InputEvent):
	if event.is_action_pressed("speed_up"):
		use_skill()
	elif event.is_action_released("speed_up"):
		stop_skill()


func use_skill() -> void:
	if is_idle: 
		print("IDLE")
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.IDLE)
	elif PlayerParameters.lock_stamina_skill:
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.LOCK)
	elif !player.stamina_component.minus(base_energy_cost):
		GameEvents.emit_skill_call_failed(Enums.SkillCallFailedReason.NO_STAMINA)
	else:
		PlayerParameters.lock_stamina_skill = true
		cooldown_timer.start()
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED * PlayerParameters.MOVE_SPEED_UP_MOD

func stop_skill() -> void:
	if !cooldown_timer.is_stopped():
		PlayerParameters.lock_stamina_skill = false
		PlayerParameters.current_speed = PlayerParameters.BASE_SPEED
		cooldown_timer.stop()

func _on_cooldown_timer_timeout() -> void:
	if player.stamina_component.minus(base_energy_cost):
		cooldown_timer.start()
	else:
		stop_skill()
