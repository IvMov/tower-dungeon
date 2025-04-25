extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]
var min_pitch = 0.8
var max_pitch = 1.2

func play_random_stream():
	if !streams || streams.size() == 0:
		return
	
	pitch_scale = randf_range(min_pitch, max_pitch)
	stream = streams.pick_random()
	play()
