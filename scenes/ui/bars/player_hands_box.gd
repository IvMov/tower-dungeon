extends PanelContainer

@onready var hands: HBoxContainer = $Hands

func resize():
	for child in hands.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*1.2, GameConfig.grid_block*1.2)
