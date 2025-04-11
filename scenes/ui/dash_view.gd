class_name DashView extends PanelContainer

@export var dash: Skill

@onready var title: Label = $Title
@onready var cd_label: Label = $CdLabel
@onready var cd_timer: Timer = $CdTimer
@onready var cd_timer_temp: Timer = $CdTimerTemp

const MAIN_COLOR: Color = Color(0.4, 0.5, 0.4)
const CD_COLOR: Color = Color.ALICE_BLUE
const CD_TEMP_COLOR: Color = Color(0.9, 0.5, 0.5)

var is_on_cd: bool = false

func _ready() -> void:
	GameEvents.skill_on_cd.connect(on_skill_on_cd)
	GameEvents.skill_call_failed.connect(on_skill_call_failed)
	set_text_color(MAIN_COLOR)
	title.text = tr(dash.title)

func _physics_process(delta: float) -> void:
	if is_on_cd:
		cd_label.text
		cd_label.text = "%0.2f" % cd_timer.time_left

func on_skill_on_cd(skill_id: int, duration: float):
	if skill_id == dash.id:
		cd_timer.wait_time = duration
		set_text_color(CD_COLOR)
		is_on_cd = true
		cd_timer.start()

func on_skill_call_failed(skill_id: int, reason: int):
	if skill_id == dash.id && reason == 4:
		set_text_color(CD_TEMP_COLOR)
		cd_label.scale = Vector2.ONE * 1.2
		cd_timer_temp.start()


func _on_cd_timer_temp_timeout() -> void:
	cd_label.scale = Vector2.ONE
	if is_on_cd:
		set_text_color(CD_COLOR)
	else:
		set_text_color(MAIN_COLOR)


func _on_cd_timer_timeout() -> void:
	is_on_cd = false
	set_text_color(MAIN_COLOR)
	cd_label.text = "ready"

func set_text_color(color: Color) -> void:
	title.add_theme_color_override("font_color", color)
	cd_label.add_theme_color_override("font_color", color)
