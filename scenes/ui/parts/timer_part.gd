class_name TimerPart extends MarginContainer

@onready var time_label: Label = $TimeLabel
@onready var timer: Timer = $Timer

var is_run: bool
var time: float

func _ready() -> void:
	GameEvents.new_stage.connect(on_new_stage)
	GameEvents.from_stage_to_shop.connect(on_to_shop)
	GameEvents.from_shop_to_stage.connect(on_to_stage)
	GameEvents.game_end.connect(on_game_end)
	if PlayerParameters.player_data["current_time"] != 0.0:
		is_run = true
		time_label.visible = true
		time = PlayerParameters.player_data["current_time"]
		var time_s = Time.get_datetime_string_from_unix_time(time)
		time_label.text = time_s.get_slice("T", 1)

func start_timer() -> void:
	time = 0
	timer.start()
	time_label.visible = true

func pause_timer() -> void:
	timer.stop()
	#time_label.visible = false
func resume_timer() -> void:
	timer.start()

func stop_timer() -> void:
	timer.stop()
	time_label.visible = false


func resize():
	pass


func _on_timer_timeout() -> void:
	time+=timer.wait_time
	var time_s = Time.get_datetime_string_from_unix_time(time)
	time_label.text = time_s.get_slice("T", 1)

func on_new_stage():
	if !is_run:
		is_run = true
		start_timer()
	
func on_to_shop():
	PlayerParameters.save_run_time(time, false)
	pause_timer()
	
func on_to_stage():
	PlayerParameters.save_run_time(0.0, false)
	resume_timer()

func on_game_end():
	is_run = false
	PlayerParameters.save_run_time(time, true)
	stop_timer()
