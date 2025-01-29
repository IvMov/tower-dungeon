extends PanelContainer

const key_value_packed: PackedScene = preload("res://scenes/ui/parts/label_key_value.tscn")

@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var description: Label = $MarginContainer/VBoxContainer/Description
@onready var quantity_label: Label = $MarginContainer/VBoxContainer/QuantityLabel
@onready var how_to_use: Label = $MarginContainer/VBoxContainer/HowToUse

#colored lines
@onready var rarity: ColorRect = $MarginContainer/VBoxContainer/Rarity
@onready var rarity_2: ColorRect = $MarginContainer/VBoxContainer/Rarity2
@onready var rarity_3: ColorRect = $MarginContainer/VBoxContainer/Rarity3
@onready var rarity_4: ColorRect = $MarginContainer/VBoxContainer/Rarity4

@onready var characteristic_container: VBoxContainer = $MarginContainer/VBoxContainer/CharacteristicContainer
@onready var lvl_up_container: VBoxContainer = $MarginContainer/VBoxContainer/LvlUpContainer

var item_bulk: ItemBulk
var skill: Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.item_hovered.connect(on_item_hovered)
	GameEvents.item_unhovered.connect(on_item_unhovered)

func resize() -> void:
	custom_minimum_size =  Vector2(GameConfig.grid_block*4, GameConfig.grid_block*2)

func on_item_hovered(item_bulk: ItemBulk):
	self.item_bulk = item_bulk
	skill = item_bulk.item.skill
	visible = true
	
	set_common_fields()
	#var lvl = randi_range(0, 100) # calc lvl for modulation and other things
	var lvl = 0 # calc lvl for modulation and other things
	set_uncommon_fields(lvl)
	var color: Color = calc_color(lvl)
	set_rarity_color(color)
	self_modulate = color
	#if deffensive build one fields
	#	elif offensive build other fields
	


func on_item_unhovered() -> void:
	reset_fields()
	
	visible = false


func set_common_fields() -> void:
	title.text = "- %s -" % tr(skill.title)
	description.text = tr(skill.description)
	how_to_use.text = tr(calc_how_to_use_info())
	quantity_label.text =  "%s: %d" % [tr("quantity"), item_bulk.quantity]

func set_uncommon_fields(lvl: int) -> void:
	if skill.is_offensive:
		var key_value: LabelKeyValue = key_value_packed.instantiate()
		key_value.key = tr("damage") 
		key_value.value = "%2d" % (lvl * skill.value_per_lvl + skill.base_value)
		characteristic_container.add_child(key_value)
	else: 
		var key_value: LabelKeyValue = key_value_packed.instantiate()
		key_value.key = tr("parameter") 
		key_value.value = tr(skill.parameter)
		characteristic_container.add_child(key_value)
	
	if !skill.is_offensive && skill.base_value != 0: 
		var key_value: LabelKeyValue = key_value_packed.instantiate()
		key_value.key = tr("value") 
		key_value.value = "%2d" % (lvl * skill.value_per_lvl + skill.base_value)
		characteristic_container.add_child(key_value)

func calc_color(lvl: int) -> Color:
	if lvl <= 0:
		return Color.WHITE
	elif lvl <= 24:
		return Color.GREEN
	elif lvl <= 49:
		return Color.AQUA
	elif lvl <= 74:
		return Color.ROYAL_BLUE
	else:
		return Color.GOLD

func set_rarity_color(color: Color) -> void:
	rarity.color = color
	rarity_2.color = color
	rarity_3.color = color
	rarity_4.color = color

func calc_how_to_use_info() -> String:
	if skill.is_maintainable:
		return "how_to_use_maintainable"
	elif skill.is_consumable:
		return "how_to_use_click_consumable"
	else:
		return "how_to_use_click"
	

func reset_fields() -> void:
	set_rarity_color(Color.WHITE)
	self_modulate = Color.WHITE
	for child in characteristic_container.get_children():
		characteristic_container.remove_child(child)
	
