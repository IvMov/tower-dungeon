extends CanvasLayer

@onready var save_box: VBoxContainer = $MarginContainer/Bacground/VBoxContainer/Saves/Saves

var saves: Array[Dictionary]

func _ready() -> void:
	saves = load_saves()
	for player in saves: 
		var btn: SoundButton = Constants.SOUND_BUTTON.instantiate()
		save_box.add_child(btn)
		btn.text = "%s, difficulty: %s, kills: %d " % [player[MetaProgression.PLAYER_NAME_KEY], player["difficulty"], player["kills"]]
		btn.pressed.connect(on_btn_pressed.bind(player[MetaProgression.PLAYER_NAME_KEY]))


func start_game(player: Dictionary):
	MusicPlayer.stop()
	await ScreenTransition.play_transition()
	#GameEvents.emit_game_started()
	GameEvents.emit_change_game_stage(1)
	get_tree().change_scene_to_packed(ScreenTransition.MAIN)
	PlayerParameters.player_name = player[MetaProgression.PLAYER_NAME_KEY]
	await ScreenTransition.play_transition_back()
	queue_free()
	
func load_saves() -> Array[Dictionary]:
	return MetaProgression.get_players()

func  _unhandled_input(event):
	if event.is_action_pressed("exit"):
		_on_back_button_pressed()


func on_btn_pressed(name: String) -> void:
	start_game(MetaProgression.get_by_username(name))
	print(MetaProgression.get_by_username(name))

func _on_back_button_pressed() -> void:
	queue_free()
