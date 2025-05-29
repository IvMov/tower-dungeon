extends CanvasLayer

@onready var load_save_button: SoundButton = $MarginContainer/Bacground/VBoxContainer/LoadSaveButton
@onready var save_box: VBoxContainer = $MarginContainer/Bacground/VBoxContainer/Saves/Saves

var user_name: String
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
	GameEvents.emit_change_game_stage(1)
	get_tree().change_scene_to_packed(ScreenTransition.MAIN)
	PlayerParameters.load_player_by_username(player[MetaProgression.PLAYER_NAME_KEY])
	await ScreenTransition.play_transition_back()
	queue_free()
	
func load_saves() -> Array[Dictionary]:
	return MetaProgression.get_players()

func on_btn_pressed(name: String) -> void:
	if load_save_button.disabled:
		load_save_button.disabled = false
	user_name = name

func _on_back_button_pressed() -> void:
	queue_free()


func _on_load_save_button_pressed() -> void:
	start_game(MetaProgression.get_by_username(user_name))
