class_name InventoryScreen extends PanelContainer

@onready var label: Label = $VBoxContainer/Label
@onready var rows: VBoxContainer = $VBoxContainer/Rows

var done: bool = false

func _ready() -> void:
	GameEvents.change_game_stage.connect(on_change_game_stage)


func draw_inventory() -> void: 
	if done:
		visible = true
	else:
		visible = true
		init_inventory()
		done = true

func init_inventory() -> void:
	draw_inventory_grid()
	draw_items()
	

func draw_inventory_grid() -> void:
	for i in PlayerParameters.inventory.size.x:
		var vbox: HBoxContainer = HBoxContainer.new()
		rows.add_child(vbox)
		for j in PlayerParameters.inventory.size.y:
			var item_view_holder: ItemViewHolder = Constants.ITEM_VIEW_HOLDER.instantiate()
			vbox.add_child(item_view_holder)
			item_view_holder.set_location(Vector3(PlayerParameters.inventory.id, i, j))



func draw_items() -> void:
	for coordinate in PlayerParameters.inventory.items:
		var item_bulk: ItemBulk = PlayerParameters.inventory.items.get(coordinate)
		var item_view: ItemView = rows.get_child(coordinate.x).get_child(coordinate.y).item_view
		item_view.item_bulk = item_bulk
		item_view.draw_item()
		


func resize() -> void:
	label.add_theme_font_size_override("font_size", GameConfig.grid_block/4)
	for row in rows.get_children():
		for child in row.get_children():
			child.custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)



func on_change_game_stage(game_stage: GameStage.Stage):
	if game_stage == GameStage.Stage.INVENTORY:
		draw_inventory()
	else: 
		visible = false
