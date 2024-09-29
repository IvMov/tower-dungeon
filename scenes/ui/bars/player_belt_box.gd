class_name PlayerBeltBox extends PanelContainer

@onready var h_box_container: HBoxContainer = $HBoxContainer



func _ready() -> void:
	GameEvents.player_entered.connect(on_player_entered)
	
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
	#OUTDATED CODE REWRITE to change LMB skill
	if GameStage.is_stage(GameStage.Stage.INVENTORY) && GameCache.preselected_item:
		if event.is_action_released("1"):
			var child: PanelContainer = h_box_container.get_child(0)
			var item_view: ItemView = Constants.ITEM_VIEW_SCENE.instantiate()
			item_view.item = GameCache.preselected_item
			GameCache.preselected_item = null
			child.add_child(item_view)

func resize() -> void:
	for child in h_box_container.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)

func on_player_entered(player: Player) -> void:
	draw_belt()
	draw_belt_items()
