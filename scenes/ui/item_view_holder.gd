class_name ItemViewHolder extends PanelContainer

@onready var info: Label = $Info
@onready var item_view: ItemView = $ItemView
var item_info_plate: PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)

func set_location(location: Vector3) -> void:
	item_view.location = location


func _on_mouse_entered() -> void:
	if item_view.item_bulk:
		GameEvents.emit_item_hovered(item_view.item_bulk)


func _on_mouse_exited() -> void:
	if item_view.item_bulk:
		GameEvents.emit_item_unhovered()
