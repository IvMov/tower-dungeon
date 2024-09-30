class_name BaseController extends Node3D

#use it like interface - required to be implemented
@onready var cast_timer: Timer = $CastTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var idle_timer: Timer = $IdleTimer


var skill_cast_finished: bool
var is_on_cooldown: bool
var is_idle: bool


var id: String
var skill_name: String
var description: String
var controller: PackedScene

var base_value: float
var base_push_value: float
var base_speed: float
var base_distance: float
var base_energy_cost: float
var base_cast_time: float
var base_duration: float
var base_cooldown: float


func start_cast() -> void:
	cast_timer.start()

func finish_cast() -> void:
	is_idle = true
	idle_timer.start()

func revert_cast() -> void:
	cast_timer.stop()


func use_skill() -> void:
	is_on_cooldown = true
	cooldown_timer.start()

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
