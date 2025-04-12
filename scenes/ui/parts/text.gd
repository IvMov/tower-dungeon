class_name Text extends Node3D

@onready var label: Label = $Sprite3D/SubViewport/MarginContainer/Label

const ANIMATION_TIME: float = 0.6

var tier_1: float = -2.0
var tier_2: float = -4.0
var tier_3: float = -5.0
var tier_4: float = -10.0

func set_text(text: String) -> void:
	label.text = text

func set_float(value: float, is_player: bool) -> void:
	label.text = "%0.2f" % value
	if !is_player:
		if value <= tier_4:
			label.add_theme_color_override("font_color", Color.ORANGE_RED)
			label.add_theme_font_size_override("font_size", 32)
		elif value <= tier_3:
			label.add_theme_color_override("font_color", Color.ORANGE)
			label.add_theme_font_size_override("font_size", 28)
		elif value <= tier_2:
			label.add_theme_color_override("font_color", Color.YELLOW)
			label.add_theme_font_size_override("font_size", 22)
		elif value <= tier_1:
			label.add_theme_color_override("font_color", Color.SKY_BLUE)
	else:
		label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		label.add_theme_font_size_override("font_size", 12)


func play(is_player: bool) -> void:
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_parallel()
	tween.tween_property(self, "global_position:y", global_position.y + 1, ANIMATION_TIME)
	tween.tween_property(self, "global_position:x", global_position.x + randf_range(-0.5, 0.5), ANIMATION_TIME)
	tween.tween_property(self, "global_position:z", global_position.z + randf_range(-0.5, 0.5), ANIMATION_TIME)
	tween.chain()
	tween.tween_property(label, "scale", Vector2.ZERO, ANIMATION_TIME)
	await tween.finished
	queue_free()
	
