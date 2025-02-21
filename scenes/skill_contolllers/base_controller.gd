class_name BaseController extends Node3D

#use it like interface - required to be implemented
@onready var cast_timer: Timer = $CastTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var idle_timer: Timer = $IdleTimer


var skill: Skill
var skill_cast_finished: bool
var is_on_cooldown: bool
var is_idle: bool
var hand: int = -1


func start_cast() -> void:
	cast_timer.start()

func finish_cast() -> void:
	is_idle = true
	idle_timer.start()

func revert_cast() -> void:
	cast_timer.stop()

func calc_projectile_damage() -> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	return skill.base_value if skill_exp_data.is_empty() else skill_exp_data["lvl"] * skill.value_per_lvl + skill.base_value


func use_skill() -> void:
	is_on_cooldown = true
	cooldown_timer.start()
	if skill.is_consumable:
			GameEvents.emit_item_consumed(0, skill.id)

func stop_skill() -> void:
	pass

func use_skill_with_event(_event: InputEvent) -> void:
	is_on_cooldown = true
	cooldown_timer.start()

func _on_cast_timer_timeout() -> void:
	skill_cast_finished = true


func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false


func _on_idle_timer_timeout() -> void:
	is_idle = false
