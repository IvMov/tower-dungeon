class_name ItemViewHolder extends PanelContainer

@onready var info: Label = $Info
@onready var item_view: ItemView = $ItemView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)
	
func set_location(location: Vector3) -> void:
	item_view.location = location
	if item_view.location.x == 3:
		item_view.connect_to_item_add()
