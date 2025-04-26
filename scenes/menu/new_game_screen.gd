extends CanvasLayer

const EASY_DESCRIPTION: String = "easy_difficulty_description"
const NORMAL_DESCRIPTION: String = "nomal_difficulty_description"
const HARD_DESCRIPTION: String= "hard_difficulty_description"

@onready var line_edit: LineEdit = $MarginContainer/Bacground/VBoxContainer/LineEdit
@onready var easy: SoundButton = $MarginContainer/Bacground/VBoxContainer/Difficulties/MarginContainer/Easy
@onready var normal: SoundButton = $MarginContainer/Bacground/VBoxContainer/Difficulties/MarginContainer/Normal
@onready var hard: SoundButton = $MarginContainer/Bacground/VBoxContainer/Difficulties/MarginContainer/Hard
@onready var error_label: Label = $MarginContainer/Bacground/ErrorLabel
@onready var difficulty_description: Label = $MarginContainer/Bacground/VBoxContainer/DifficultyDescription

var user_name: String
var current_difficulty: int

func _ready() -> void:
	set_default_difficulty()

func set_default_difficulty() -> void:
	current_difficulty = 2
	GameConfig.game_difficulty = current_difficulty
	normal.button_pressed = true
	difficulty_description.text = tr(NORMAL_DESCRIPTION)
	
func  _unhandled_input(event):
	if event.is_action_pressed("exit"):
		_on_back_button_pressed()

func is_valid_name() -> bool: 
	return user_name && !user_name.strip_edges().is_empty()

func toggle_buttons(difficulty: int):
	if current_difficulty == difficulty:
		return
	
	if current_difficulty == 1:
		easy.button_pressed = !easy.button_pressed
		difficulty_description.text = tr(EASY_DESCRIPTION)
	if current_difficulty == 2:	
		normal.button_pressed = !normal.button_pressed
		difficulty_description.text = tr(NORMAL_DESCRIPTION)
	if current_difficulty == 3:
		hard.button_pressed = !hard.button_pressed
		difficulty_description.text = tr(HARD_DESCRIPTION)
	current_difficulty = difficulty
	GameConfig.game_difficulty = current_difficulty
 
func start_game():
	MusicPlayer.stop()
	await ScreenTransition.play_transition()
	GameEvents.emit_change_game_stage(GameStage.Stage.GAME)
	get_tree().change_scene_to_packed(ScreenTransition.MAIN)
	PlayerParameters.player_name = user_name
	await ScreenTransition.play_transition_back()
	queue_free()

func _on_line_edit_text_changed(new_text: String) -> void:
	user_name = new_text
	error_label.visible = false

func _on_line_edit_text_submitted(new_text: String) -> void:
	_on_create_button_pressed()

func _on_create_button_pressed() -> void:
	if is_valid_name(): 
		if MetaProgression.add_player(user_name, current_difficulty):
			start_game()
		else:
			error_label.text = tr("error_username_exists")
			error_label.visible = true
	else:
		error_label.text = tr("error_username_not_emtpy")
		error_label.visible = true
		line_edit.clear()

func _on_easy_pressed() -> void:
	toggle_buttons(1)

func _on_normal_pressed() -> void:
	toggle_buttons(2)

func _on_hard_pressed() -> void:
	toggle_buttons(3)

func _on_back_button_pressed() -> void:
	queue_free()
