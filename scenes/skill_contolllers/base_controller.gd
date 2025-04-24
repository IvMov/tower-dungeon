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
var damage_boost: float = 1


func start_cast() -> void:
	cast_timer.start()

func finish_cast() -> void:
	is_idle = true
	idle_timer.start()

func revert_cast() -> void:
	cast_timer.stop()

func calc_projectile_damage() -> float:
	return calc_value_exponentially()

func calc_value_exponentially()-> float:
	var skill_exp_data: Dictionary = PlayerParameters.get_skill_data(skill.id)
	if skill.is_offensive:
		return (skill.base_value * pow(skill.value_per_lvl, skill_exp_data["lvl"]+1)) * PlayerParameters.damage_boost
	else:
		return skill.base_value * pow(skill.value_per_lvl, skill_exp_data["lvl"]+1)
		
func add_warning(text: String) -> void:
	var text_holder: Text = Constants.TEXT.instantiate()
	add_child(text_holder)
	text_holder.set_text(tr(text))
	text_holder.play(true)

func use_skill() -> void:
	cooldown()
	if skill.is_consumable:
			GameEvents.emit_item_consumed(0, skill.id)

func cooldown() -> void: 
	is_on_cooldown = true
	cooldown_timer.start()
	GameEvents.emit_skill_on_cd(skill.id, cooldown_timer.wait_time)


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
