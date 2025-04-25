extends Button

@onready var random_audio_player_component = $RandomAudioPlayerComponent

func _ready():
	pressed.connect(on_pressed)
	

func on_pressed():
	pass
	#random_audio_player_component.play_random_stream()
