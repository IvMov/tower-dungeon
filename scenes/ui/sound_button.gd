class_name SoundButton extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_pressed() -> void:
	SfxPlayer.click()
