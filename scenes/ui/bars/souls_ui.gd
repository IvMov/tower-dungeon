extends VBoxContainer

@onready var soul_type_ui: SoulTypeUi = $SoulTypeUi
@onready var soul_type_ui_2: SoulTypeUi = $SoulTypeUi2
@onready var soul_type_ui_3: SoulTypeUi = $SoulTypeUi3


func _ready() -> void:
	GameEvents.souls_update_view.connect(on_souls_update_view)
	resize()

func resize():
	for child in self.get_children():
		child.sprite.custom_minimum_size =  Vector2(GameConfig.grid_block*0.7, GameConfig.grid_block*0.7)
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*2, 0)

func on_souls_update_view(value: Vector3) -> void:
	soul_type_ui.quantity_label.text = str(value.x)
	soul_type_ui_2.quantity_label.text = str(value.y)
	soul_type_ui_3.quantity_label.text = str(value.z)
