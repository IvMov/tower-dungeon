class_name AimSkillController extends BaseController

@export var player: Player;

var is_aiming: bool = false

func _ready():
	base_energy_cost = 1 # todo:create normal skill .tres

func use_skill_with_event(event: InputEvent):
	if event.is_action_pressed("aiming_mode"):
		use_skill()
	elif event.is_action_released("aiming_mode"):
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
		is_aiming = true
		PlayerParameters.lock_stamina_skill = true
		cooldown_timer.start()
		player.camera_scene.aiming_mode_in()
		GameEvents.emit_aiming_player(true)

func stop_skill() -> void:
	if is_aiming:
		is_aiming = false
		if !cooldown_timer.is_stopped():
			cooldown_timer.stop()
		PlayerParameters.lock_stamina_skill = false
		super.finish_cast()
		player.camera_scene.aiming_mode_out()
		GameEvents.emit_aiming_player(false)

# consume stamina each time after timeout
func _on_cooldown_timer_timeout() -> void:
	if player.stamina_component.minus(base_energy_cost):
		cooldown_timer.start()
	else:
		stop_skill()
