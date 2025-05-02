class_name FlyingUpgradeView extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var flying_2d_view: Flying2dView = $Sprite3D/SubViewport/Flying2dView

var is_done: bool = false

func set_rich_text(text: String) -> void:
	flying_2d_view.rich_text_label.text = text

func set_coins_progress(real: int, expected: int) -> void:
	flying_2d_view.set_coins(real, expected)

func set_green_souls_progress(real: int, expected: int) -> void:
	flying_2d_view.set_green_souls(real, expected)

func set_blue_souls_progress(real: int, expected: int) -> void:
	flying_2d_view.set_blue_souls(real, expected)

func set_red_souls_progress(real: int, expected: int) -> void:
	flying_2d_view.set_red_souls(real, expected)

func set_is_done() -> void:
	is_done = true
	flying_2d_view.rich_text_label.visible = false
	flying_2d_view.bars.visible = false
	flying_2d_view.done_label_container.visible = true
	

func hide_bars() -> void:
	if !is_done:
		flying_2d_view.bars.visible = false
	
	

func show_bars() -> void:
	if !is_done:
		flying_2d_view.bars.visible = true
