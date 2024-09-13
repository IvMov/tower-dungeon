class_name InventoryScreen extends Node2D

@onready var rows: VBoxContainer = $CanvasLayer/MarginContainer/Rows

@export var inventory: Inventory
var done: bool = false

func draw_inventory() -> void: 
	if done:
		visible = true
	else:
		init_inventory()
		done = true

func init_inventory():
	for i in inventory.HEIGHT:
		var vbox: HBoxContainer = HBoxContainer.new()
		for j in inventory.WIDTH:
			var panel: PanelContainer = PanelContainer.new()
			panel.custom_minimum_size =  Vector2(100, 100)
			vbox.add_child(panel)
		rows.add_child(vbox)
