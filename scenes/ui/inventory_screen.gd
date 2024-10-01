class_name InventoryScreen extends PanelContainer

@onready var label: Label = $VBoxContainer/Label
@onready var rows: VBoxContainer = $VBoxContainer/Rows
@onready var drop_item_block: ItemViewHolder = $VBoxContainer/DropItemBlock

var done: bool = false

func _ready() -> void:
	GameEvents.change_game_stage.connect(on_change_game_stage)
	config_drop_on_floor_box()


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
	PlayerParameters.inventory.item_added.connect(on_item_added)
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
		
func config_drop_on_floor_box() -> void:
	drop_item_block.info.size_flags_vertical = 4
	drop_item_block.info.text = "Drop item here to drop it out"
	drop_item_block.set_location(Vector3(2, 0, 0))

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


func on_item_added(to: Vector2):
	var item_bulk: ItemBulk = PlayerParameters.inventory.items.get(to)
	var item_view: ItemView = rows.get_child(to.x).get_child(to.y).item_view
	item_view.item_bulk = item_bulk
	item_view.draw_item()
