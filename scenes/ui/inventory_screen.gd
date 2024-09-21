class_name InventoryScreen extends Node2D

@export var item_view: PackedScene

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var rows: VBoxContainer = $CanvasLayer/MarginContainer/VBoxContainer/Rows

var inventory: Inventory
var done: bool = false

func _ready() -> void:
	GameEvents.player_entered.connect(on_player_entered)
	GameEvents.change_game_stage.connect(on_change_game_stage)
	GameEvents.screen_resized.connect(on_screen_resized)

func draw_inventory() -> void: 
	if done:
		canvas_layer.visible = true
	else:
		canvas_layer.visible = true
		init_inventory()
		done = true

func init_inventory() -> void:
	draw_inventory_grid()
	draw_items()
	

func draw_inventory_grid() -> void:
	for i in inventory.HEIGHT:
		var vbox: HBoxContainer = HBoxContainer.new()
		for j in inventory.WIDTH:
			var panel: PanelContainer = PanelContainer.new()
			panel.custom_minimum_size =  Vector2(GameConfig.grid_block, GameConfig.grid_block)
			vbox.add_child(panel)
		rows.add_child(vbox)


func draw_items() -> void:
	var items: Dictionary = inventory.items;
	for coordinate in items:
		var item_view_inst: ItemView = item_view.instantiate()
		var item: Item = items[coordinate]["item"]
		item_view_inst.item  = item
		item_view_inst.quantity = items[coordinate]["quantity"]
		rows.get_child(coordinate.x).get_child(coordinate.y).add_child(item_view_inst)


func on_player_entered(player: Player) -> void:
	inventory = player.inventory


func on_change_game_stage(game_stage: GameStage.Stage):
	if game_stage == GameStage.Stage.INVENTORY:
		draw_inventory()
	else: 
		canvas_layer.visible = false


func on_screen_resized():
	done = false
	for child in rows.get_children():
		rows.remove_child(child)
		child.queue_free()
	if GameStage.is_stage(GameStage.Stage.INVENTORY):
		draw_inventory()
