extends AudioStreamPlayer

@export var sounds: Dictionary[String, AudioStream]

func click() -> void:
	stream = sounds["click"]
	play()
	await finished
