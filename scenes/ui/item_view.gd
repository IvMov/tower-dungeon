class_name ItemView extends TextureRect

@onready var quantity_label: Label = $Quantity
@onready var color_rect: ColorRect = $ColorRect
@onready var cd_label: Label = $CdLabel
@onready var cd_timer: Timer = $CdTimer
@onready var cd_timer_temp: Timer = $CdTimerTemp

const MAIN_COLOR: Color = Color(0.0, 0.7, 0.7, 0.0)
const HOVER_COLOR: Color = Color(0, 0.7, 0.7, 0.3)
const CD_COLOR: Color = Color(0.3, 0.3, 0.3, 0.8)
const CD_TEMP_COLOR: Color = Color(0.6, 0.1, 0.1, 0.6)

var item_bulk: ItemBulk
var location: Vector3
var dragged: bool = false
var is_disabled: bool = false
var is_on_cd: bool = false



func _ready() -> void:
	GameEvents.skill_on_cd.connect(on_skill_on_cd)
	GameEvents.skill_call_failed.connect(on_skill_call_failed)
	draw_item()

func _physics_process(delta: float) -> void:
	if is_on_cd:
		cd_label.text
		cd_label.text = "%0.2f" % cd_timer.time_left

func _input(event: InputEvent) -> void:
	if dragged && event.is_action_released("LMB"):
		dragged = false
		visible = true


func draw_item() -> void:
	if item_bulk:
		texture = item_bulk.item.image
		quantity_label.text = str(item_bulk.quantity)

func add(new_item_bulk: ItemBulk) -> void:
	item_bulk = new_item_bulk
	texture = item_bulk.item.image
	quantity_label.text = str(item_bulk.quantity)

func clear() -> void:
	dragged = false
	item_bulk = null
	texture = null
	visible = true
	quantity_label.text = ""

func reset() -> void:
	GameEvents.emit_item_remove(location, item_bulk.quantity)
	clear()

func _on_mouse_entered() -> void:
	color_rect.color = HOVER_COLOR

func _on_mouse_exited() -> void:
	if is_on_cd:
		color_rect.color = HOVER_COLOR
	else: 
		color_rect.color = MAIN_COLOR

#drag and drop staff
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !item_bulk || is_disabled:
		return 
		
	var preview: TextureRect = TextureRect.new()
	preview.expand_mode = ExpandMode.EXPAND_IGNORE_SIZE
	preview.texture = item_bulk.item.image
	preview.size = Vector2(GameConfig.grid_block, GameConfig.grid_block)
	var control: Control = Control.new()
	control.add_child(preview)
	set_drag_preview(control)
	visible = false
	dragged = true
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if is_disabled:
		return false
	return data is ItemView

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if is_disabled:
		return
	put_item(data)
	
 
func put_item(item_view: ItemView) -> void:
	if !item_bulk:
		if location.x == 2:
			drop_item(item_view)
			return 
		add(item_view.item_bulk)
		draw_item()
		GameEvents.emit_item_add(location, item_view.item_bulk)
		item_view.reset()
	elif item_bulk.item.id == item_view.item_bulk.item.id:
		GameEvents.emit_item_add(location, item_view.item_bulk)
		draw_item()
		item_view.reset()
	else: 
		var temp_item: ItemBulk = item_bulk;
		reset()
		GameEvents.emit_item_add(location, item_view.item_bulk)
		add(item_view.item_bulk)
		item_view.reset()
		item_view.add(temp_item)
		GameEvents.emit_item_add(item_view.location, temp_item)

func drop_item(item_view: ItemView) -> void: 
	GameEvents.emit_item_add(Vector3(2, 0, 0), item_view.item_bulk)
	item_view.reset()

func on_skill_on_cd(skill_id: int, duration: float):
	if item_bulk && skill_id == item_bulk.item.skill.id:
		cd_timer.wait_time = duration
		color_rect.color = CD_COLOR
		is_on_cd = true
		cd_timer.start()

func on_skill_call_failed(skill_id: int, reason: int):
	if item_bulk && skill_id == item_bulk.item.skill.id && reason == 4:
		color_rect.color = CD_TEMP_COLOR
		cd_label.scale = Vector2.ONE * 1.2
		cd_timer_temp.start()


func _on_cd_timer_temp_timeout() -> void:
	cd_label.scale = Vector2.ONE
	if is_on_cd:
		color_rect.color = CD_COLOR
	else:
		color_rect.color = MAIN_COLOR


func _on_cd_timer_timeout() -> void:
	is_on_cd = false
	color_rect.color = MAIN_COLOR
	cd_label.text = ""
