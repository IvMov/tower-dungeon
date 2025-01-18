extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var timer: Timer = $Timer

func random_color() -> Color:
	return Color(randf(), randf(), randf())


func _on_timer_timeout() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(omni_light_3d, "light_color", Color.BLACK, 1).set_ease(Tween.EASE_OUT)
	tween.tween_property(omni_light_3d, "light_color", random_color(), 1).set_ease(Tween.EASE_IN)
	timer.start()
