class_name ItemViewHolder extends PanelContainer

@onready var info: Label = $Info
@onready var item_view: ItemView = $ItemView

func _ready() -> void:
	GameEvents.skill_lvl_up.connect(on_skill_lvl_up)
	custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)

func resize() -> void: 
	custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)


func set_location(location: Vector3) -> void:
	item_view.location = location


func _on_mouse_entered() -> void:
	if item_view.item_bulk:
		GameEvents.emit_item_hovered(item_view.item_bulk)


func _on_mouse_exited() -> void:
	if item_view.item_bulk:
		GameEvents.emit_item_unhovered()

func on_skill_lvl_up(id: int):
	if item_view.item_bulk && item_view.item_bulk.item.id == id:
		var tween: Tween = create_tween()
		var color_before: Color = item_view.color_rect.color
		tween.tween_property(item_view.color_rect, "color", Color.GOLD, 0.3)
		tween.tween_property(item_view.color_rect, "color", color_before, 0.1)
