class_name ItemView extends TextureRect

@onready var quantity_label: Label = $Quantity
@onready var color_rect: ColorRect = $ColorRect

var item_bulk: ItemBulk
var location: Vector3
var dragged: bool = false


func _ready() -> void:
	draw_item()

func _input(event: InputEvent) -> void:
	if dragged && event.is_action_released("LMB"):
		dragged = false
		visible = true


func draw_item() -> void:
	if item_bulk:
		texture = item_bulk.item.image
		quantity_label.text = str(item_bulk.quantity)

func add(item_bulk: ItemBulk) -> void:
	self.item_bulk = item_bulk
	texture = item_bulk.item.image
	quantity_label.text = str(item_bulk.quantity)


func reset() -> void:
	GameEvents.emit_item_remove(location, item_bulk.quantity)
	dragged = false
	item_bulk = null
	texture = null
	visible = true
	quantity_label.text = ""

func _on_mouse_entered() -> void:
	color_rect.color = Color(0, 0.7, 0.7, 0.3)

func _on_mouse_exited() -> void:
	color_rect.color = Color(0, 0.7, 0.7, 0.0)

#drag and drop staff
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !item_bulk:
		return 
		
	var preview: TextureRect = TextureRect.new()
	preview.expand_mode = 1
	preview.texture = item_bulk.item.image
	preview.size = Vector2(GameConfig.grid_block, GameConfig.grid_block)
	var control: Control = Control.new()
	control.add_child(preview)
	set_drag_preview(control)
	visible = false
	dragged = true
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is ItemView

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if !item_bulk:
		add(data.item_bulk)
		draw_item()
		GameEvents.emit_item_add(location, data.item_bulk)
		data.reset()
	elif item_bulk.item.id == data.item_bulk.item.id:
		GameEvents.emit_item_add(location, data.item_bulk)
		draw_item()
		data.reset()
	else: 
		var temp_item: ItemBulk = item_bulk;
		reset()
		GameEvents.emit_item_add(location, data.item_bulk)
		add(data.item_bulk)
		data.reset()
		data.add(temp_item)
		GameEvents.emit_item_add(data.location, temp_item)
 
