class_name MenuScreen extends CanvasLayer

@onready var start_button: Button = $MarginContainer/Bacground/VBoxContainer/StartButton
@onready var restart_button: Button = $MarginContainer/Bacground/VBoxContainer/RestartButton
@onready var give_up_button: Button = $MarginContainer/Bacground/VBoxContainer/GiveUpButton
@onready var bacground: ColorRect = $MarginContainer/Bacground

func _ready():
	GameEvents.change_game_stage.connect(on_game_stage_changed)
	if !get_tree().paused:
		restart_button.visible = false
		give_up_button.visible = false
	
	if get_tree().paused:
		restart_button.visible = true
		give_up_button.visible = true
		start_button.text = tr("menu_back_to_game_btn")
	if !MusicPlayer.playing:
		MusicPlayer.play()


func _on_start_button_pressed() -> void:
	if !get_tree().paused:
		get_parent().add_child(ScreenTransition.PLAY_SCREEN.instantiate())
	else:
		GameEvents.emit_change_game_stage(GameStage.Stage.GAME)

func _on_restart_button_pressed() -> void:
	GameEvents.emit_save_game()
	MusicPlayer.stop()
	get_tree().paused = false
	ScreenTransition.play_transition()
	await ScreenTransition.animation_player.animation_finished
	GameEvents.emit_game_started()
	get_tree().change_scene_to_packed(ScreenTransition.MAIN)
	ScreenTransition.play_transition_back()

func _on_properties_button_pressed() -> void:
	get_parent().add_child(ScreenTransition.PROPERTIES_SCREEN.instantiate())


func _on_controls_button_pressed() -> void:
	get_parent().add_child(ScreenTransition.CONTROL_SCREEN.instantiate())

func _on_give_up_button_pressed() -> void:
	MetaProgression.save_game()
	get_tree().paused = false 
	get_tree().change_scene_to_packed(ScreenTransition.MENU_SCREEN)

func _on_quit_button_pressed() -> void:
	await MetaProgression.save_game_on_quit()
	get_tree().quit()

func on_game_stage_changed(game_stage: GameStage.Stage) -> void:
	if game_stage == GameStage.Stage.GAME:
		MusicPlayer.stop()
		queue_free()
	
