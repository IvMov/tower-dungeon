class_name UiBar extends ProgressBar

@onready var current: Label = $Current
@onready var regen: Label = $Regen

const TIER_1: float = -2.0
const TIER_2: float = -5.0
const TIER_3: float = -10.0
const TIER_4: float = -20.0

var start_position: Vector2

func _ready() -> void:
	start_position = current.position

func animate_minus(value: float) -> void:
	var minus: Label = Label.new()
	add_calc_text_color(value, minus)
	add_child(minus)
	minus.position = current.position
	minus.text = "%.2f" % value
	var tween: Tween = create_tween()
	minus.position.x = current.position.x + randf_range(GameConfig.grid_block/2, GameConfig.grid_block/1.5)
	#TODO: fix the normal reaction on the damage and usage of stats
	var time: float = max(0.3, min(value * -1 / 10, 1))
	tween.tween_property(minus, "position", Vector2(minus.position.x, minus.position.y + randf_range(GameConfig.grid_block/8, GameConfig.grid_block/4)), time)
	tween.tween_property(minus, "scale", Vector2.ONE * 0.1, time)
	await tween.finished
	minus.queue_free()

func add_calc_text_color(value: float, label: Label) -> void:
	if value <= TIER_4:
		label.add_theme_color_override("font_color", Color.LIGHT_PINK)
		label.add_theme_font_size_override("font_size", 22)
	elif value <= TIER_3:
		label.add_theme_color_override("font_color", Color.LIGHT_SALMON)
		label.add_theme_font_size_override("font_size", 22)
	elif value <= TIER_2:
		label.add_theme_color_override("font_color", Color.LIGHT_BLUE)
	elif value <= TIER_1:
		label.add_theme_color_override("font_color", Color.LIGHT_GOLDENROD)
	else: 
		label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
