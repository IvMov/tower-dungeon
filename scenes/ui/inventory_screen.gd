class_name InventoryScreen extends PanelContainer

@onready var label: Label = $VBoxContainer/Label
@onready var rows: VBoxContainer = $VBoxContainer/Rows
@onready var drop_item_block: ItemViewHolder = $VBoxContainer/DropItemBlock

var done: bool = false

func _ready() -> void:
	GameEvents.change_game_stage.connect(on_change_game_stage)
	GameEvents.item_added.connect(on_item_added)
	GameEvents.redraw_item.connect(on_redraw_item)
	GameEvents.item_from_storage.connect(on_item_from_storage)
	GameEvents.player_entered.connect(on_player_entered)
	GameEvents.game_end.connect(on_game_end)
	config_drop_on_floor_box()


func draw_inventory() -> void: 
	visible = true


func init_inventory() -> void:
	draw_inventory_grid()
	draw_items()
	
func do_done() -> void:
	if !done: 
		init_inventory()
		done = true

func draw_inventory_grid() -> void:
	for i in PlayerParameters.inventory.size.x:
		var hbox: HBoxContainer = HBoxContainer.new()
		rows.add_child(hbox)
		for j in PlayerParameters.inventory.size.y:
			var item_view_holder: ItemViewHolder = Constants.ITEM_VIEW_HOLDER.instantiate()
			hbox.add_child(item_view_holder)
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
			child.custom_minimum_size = Vector2(GameConfig.grid_block, GameConfig.grid_block)

func clear() -> void:
	for row in rows.get_children():
		for child in row.get_children():
			child.item_view.clear()


func on_change_game_stage(game_stage: GameStage.Stage):
	if game_stage == GameStage.Stage.INVENTORY:
		draw_inventory()
	else: 
		visible = false


func on_item_added(to: Vector3):
	if to.x == 0:
		var item_bulk: ItemBulk = PlayerParameters.inventory.items.get(Vector2(to.y, to.z))
		var item_view: ItemView = rows.get_child(to.y).get_child(to.z).item_view
		item_view.item_bulk = item_bulk
		item_view.draw_item()

func on_redraw_item(key: Vector3):
	if key.x != 0 || rows.get_children().size() == 0:
		return
		
	var item_view: ItemView = rows.get_child(key.y).get_child(key.z).item_view
	item_view.draw_item()


func on_item_from_storage(from: Vector3):
	if from.x != 0:
		return
	rows.get_child(from.y).get_child(from.z).item_view.clear()

func on_player_entered(_player: Player):
	do_done()

func on_game_end():
	clear()
