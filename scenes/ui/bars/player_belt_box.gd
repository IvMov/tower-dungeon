extends PanelContainer

@onready var h_box_container: HBoxContainer = $HBoxContainer

func resize() -> void:
	for child in h_box_container.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)
