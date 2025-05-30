class_name MenuScreen extends CanvasLayer

@onready var start_button: Button = $MarginContainer/Bacground/VBoxContainer/StartButton
@onready var restart_button: Button = $MarginContainer/Bacground/VBoxContainer/RestartButton
@onready var give_up_button: Button = $MarginContainer/Bacground/VBoxContainer/GiveUpButton
@onready var v_box_container: VBoxContainer = $MarginContainer/Bacground/VBoxContainer
@onready var bacground: ColorRect = $MarginContainer/Bacground

func _ready():
	GameEvents.change_game_stage.connect(on_game_stage_changed)
	if !get_tree().paused:
		restart_button.visible = false
		give_up_button.visible = false
	
	if get_tree().paused:
		restart_button.visible = true
		give_up_button.visible = true
		start_button.text = "menu_back_to_game_btn"
		start_button.tooltip_text = "menu_back_to_game_btn_d"
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
	queue_free()

func _on_properties_button_pressed() -> void:
	var scene = ScreenTransition.PROPERTIES_SCREEN.instantiate()
	get_parent().add_child(scene)
	scene.last_scene = self
	bacground.color.a = 0
	v_box_container.visible = false

func _on_controls_button_pressed() -> void:
	var scene = ScreenTransition.CONTROL_SCREEN.instantiate()
	get_parent().add_child(scene)
	scene.last_scene = self
	bacground.color.a = 0
	v_box_container.visible = false

func _on_give_up_button_pressed() -> void:
	MetaProgression.save_game()
	get_tree().paused = false 
	get_tree().change_scene_to_packed(ScreenTransition.MENU_SCREEN)

func _on_quit_button_pressed() -> void:
	#await MetaProgression.save_game_on_quit()
	const POP_UP_QUIT = preload("res://scenes/menu/popups/pop_up_quit.tscn")
	var pop = POP_UP_QUIT.instantiate()
	add_child(pop)
	pop.set_texts("quit_confirm_text", "yes", "no")

func on_game_stage_changed(game_stage: GameStage.Stage) -> void:
	if game_stage == GameStage.Stage.GAME:
		MusicPlayer.stop()
		queue_free()

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")


func _on_ukrainian_pressed() -> void:
	TranslationServer.set_locale("uk")


func _on_lithuanian_pressed() -> void:
	TranslationServer.set_locale("lt")
