class_name PlayerBeltBox extends PanelContainer

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var cd_timer: Timer = $CdTimer



func _ready() -> void:
	GameEvents.player_entered.connect(on_player_entered)
	GameEvents.redraw_item.connect(on_redraw_item)
		#add new BeltSections and fill them with data from inventory node 
		#(for instance row 99 will be for belt, and then I can control its lengt)

func draw_belt() -> void:
	for i in PlayerParameters.belt.size.y:
		var item_view_holder: ItemViewHolder = Constants.ITEM_VIEW_HOLDER.instantiate()
		h_box_container.add_child(item_view_holder)
		item_view_holder.info.text = str(i+1)
		item_view_holder.set_location(Vector3(PlayerParameters.belt.id, 0, i))

func draw_belt_items() -> void:
	for coordinate in PlayerParameters.belt.items:
		var item_bulk: ItemBulk = PlayerParameters.belt.items.get(coordinate)
		var item_view: ItemView = h_box_container.get_child(coordinate.y).item_view
		item_view.item_bulk = item_bulk
		item_view.draw_item()

func _unhandled_input(event: InputEvent) -> void:
	if !GameStage.is_stage(GameStage.Stage.INVENTORY) && cd_timer.is_stopped():
		var key: int = int(event.as_text())
		if key > 0 && event.is_released() && key < 6:
			var item_view: ItemView = h_box_container.get_child(key-1).item_view
			if item_view.item_bulk:
				GameEvents.emit_item_to_hand(item_view)
				cd_timer.start()


func resize() -> void:
	for child in h_box_container.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)

func on_player_entered(_player: Player) -> void:
	draw_belt()
	draw_belt_items()

func on_redraw_item(key: Vector3):
	if key.x != 1:
		return
	var item_view: ItemView = h_box_container.get_child(key.z).item_view
	item_view.draw_item()
