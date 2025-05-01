extends CanvasLayer

@onready var start_button = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/StartButton
@onready var back_button = $ScrollContainer/MarginContainer/VBoxContainer/MarginContainer/BackButton

@onready var easy = $ScrollContainer/MarginContainer/VBoxContainer/Difficulties/MarginContainer/Easy
@onready var normal = $ScrollContainer/MarginContainer/VBoxContainer/Difficulties/MarginContainer/Normal
@onready var hard = $ScrollContainer/MarginContainer/VBoxContainer/Difficulties/MarginContainer/Hard

var current_difficulty: int = GameConfig.game_difficulty

func _ready():
	start_button.pressed.connect(on_start_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	easy.pressed.connect(on_difficulty_pressed_easy)
	normal.pressed.connect(on_difficulty_pressed_normal)
	hard.pressed.connect(on_difficulty_pressed_hard)
	toggle_buttons(current_difficulty)

func _unhandled_key_input(event):
	if event.is_action_pressed("exit"):
		on_back_button_pressed()

func toggle_buttons(difficulty: int):
	if current_difficulty == 1:
		easy.button_pressed = !easy.button_pressed
	if current_difficulty == 2:	
		normal.button_pressed = !normal.button_pressed
	if current_difficulty == 3:
		hard.button_pressed = !hard.button_pressed
	current_difficulty = difficulty
	GameConfig.game_difficulty = current_difficulty

func on_start_button_pressed():
	MusicPlayer.stop()
	ScreenTransition.play_transition()
	await ScreenTransition.animation_player.animation_finished
	GameEvents.emit_game_started()
	get_tree().change_scene_to_packed(GameEvents.main_scene)
	ScreenTransition.play_transition_back()
	queue_free()
	
func on_difficulty_pressed_easy():
	toggle_buttons(1)
	
func on_difficulty_pressed_normal():
	toggle_buttons(2)

func on_difficulty_pressed_hard():
	toggle_buttons(3)

func on_back_button_pressed():
	queue_free()
