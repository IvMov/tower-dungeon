class_name BaseStatBar extends Node3D

@onready var sprite_3d = $Sprite3D
@onready var sub_viewport = $Sprite3D/SubViewport
@onready var enemy_progress_bar = $Sprite3D/SubViewport/EnemyProgressBar

@export var bar_color: Color

func _ready():
	enemy_progress_bar.modulate = bar_color
	sprite_3d.texture = sub_viewport.get_texture()

func disable() -> void:
	sprite_3d.visible = false

func enable() -> void:
	sprite_3d.visible = true

func update(current_value: float, max_value: float):
	if max_value == 0 && current_value == 0:
		disable()
	elif !enemy_progress_bar.visible: 
		enable()
	# order important - first max value then value
	enemy_progress_bar.max_value = max_value
	enemy_progress_bar.value = current_value
