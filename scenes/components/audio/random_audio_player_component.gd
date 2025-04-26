extends AudioStreamPlayer

@export var streams: Array[AudioStream]

func play_random_stream():
	if !streams || streams.size() == 0:
		return
	stream = streams.pick_random()
	play()
