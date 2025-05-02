extends VBoxContainer

@onready var soul_type_ui: SoulTypeUi = $SoulTypeUi
@onready var soul_type_ui_2: SoulTypeUi = $SoulTypeUi2
@onready var soul_type_ui_3: SoulTypeUi = $SoulTypeUi3
@onready var soul_type_ui_4: SoulTypeUi = $SoulTypeUi4


func _ready() -> void:
	GameEvents.souls_update_view.connect(on_souls_update_view)
	resize()

func resize():
	for child in self.get_children():
		child.sprite.custom_minimum_size =  Vector2(GameConfig.grid_block*0.3, GameConfig.grid_block*0.3)
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*1, 0)

func on_souls_update_view() -> void:
	soul_type_ui.set_value(PlayerParameters.souls.x)
	soul_type_ui_2.set_value(PlayerParameters.souls.y)
	soul_type_ui_3.set_value(PlayerParameters.souls.z)
	soul_type_ui_4.set_value(PlayerParameters.coins)
