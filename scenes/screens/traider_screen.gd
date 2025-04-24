extends MarginContainer

var items: Array[ItemBulk]

@onready var image: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Image
@onready var title: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Title
@onready var type: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Type
@onready var price: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Price
@onready var quantity: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Quantity
@onready var total_price: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/TotalPrice
@onready var buy: Label = $Shop/MarginContainer/ScrollContainer/TraiderItems/MarginContainer/HeaderOfTable/Buy

@onready var margin_container: MarginContainer = $Shop/MarginContainer
@onready var color_rect: ColorRect = $Shop/ColorRect
@onready var traider_items: VBoxContainer = $Shop/MarginContainer/ScrollContainer/TraiderItems
var shield_color: Color = Color(0.18, 0.20, 0.22, 0.87)
var disabled_shield_color: Color = Color(0.18, 0.20, 0.22, 0.0)
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.change_game_stage.connect(on_change_game_stage)
	GameEvents.item_hovered.connect(on_item_hovered)
	GameEvents.item_unhovered.connect(on_item_unhovered)
	GameEvents.from_stage_to_shop.connect(on_from_stage_to_shop)
	GameEvents.update_items_prices.connect(on_update_items_prices)

func resize() -> void:
	change_margins()
	resize_header()
	for child in traider_items.get_children():
		if child is TraiderItem:
			child.resize()

func resize_header() -> void:
	image.custom_minimum_size = Vector2(GameConfig.grid_block, 0)
	quantity.custom_minimum_size =  Vector2(GameConfig.grid_block * 1.5, 0)
	price.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)
	total_price.custom_minimum_size =  Vector2(GameConfig.grid_block * 2.5 , 0)
	type.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)
	title.custom_minimum_size =  Vector2(GameConfig.grid_block * 3.5 , 0)
	buy.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)

func change_margins() -> void:
	add_theme_constant_override("margin_top", GameConfig.grid_block*1.3)
	add_theme_constant_override("margin_left", GameConfig.grid_block * 2.1)
	add_theme_constant_override("margin_bottom", GameConfig.grid_block*2)
	add_theme_constant_override("margin_right", GameConfig.grid_block/10)
	
	margin_container.add_theme_constant_override("margin_top", GameConfig.grid_block/4)
	margin_container.add_theme_constant_override("margin_left", GameConfig.grid_block/8)
	margin_container.add_theme_constant_override("margin_bottom", GameConfig.grid_block/4)
	margin_container.add_theme_constant_override("margin_right", GameConfig.grid_block/8)


func load_items() -> void:
	items.append(ItemBulk.new(Constants.ITEM_CRYSTAL, randi_range(1,20)))
	items.append(ItemBulk.new(Constants.ITEM_STONE, randi_range(1,20)))
	items.append(ItemBulk.new(Constants.HEAL_TABLET, randi_range(5,20)))
	items.append(ItemBulk.new(Constants.MANA_TABLET, randi_range(5,20)))
	items.append(ItemBulk.new(Constants.STAMINA_TABLET, randi_range(5,20)))


func prepare_view() -> void:
	for item in items:
		var traider_item: TraiderItem = Constants.TRAIDER_ITEM.instantiate()
		traider_items.add_child(traider_item)
		traider_item.build(item)

func clear_old_shop() -> void:
	items.clear()
	for child in traider_items.get_children():
		if child is TraiderItem:
			child.queue_free()

func update_availability() -> void:
	for child in traider_items.get_children():
		if child is TraiderItem:
			child.update_availability()
		

func on_item_hovered(item: ItemBulk): 
	if GameStage.current_game_stage != GameStage.Stage.TRAIDER:
		return
	if tween && tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(color_rect, "color", shield_color, 0.5)
	color_rect.visible = true

func on_item_unhovered():
	if GameStage.current_game_stage != GameStage.Stage.TRAIDER:
		return
	if tween && tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(color_rect, "color", disabled_shield_color, 0.5)
	await tween.finished
	color_rect.visible = false

func on_change_game_stage(game_stage: GameStage.Stage):
	if game_stage == GameStage.Stage.TRAIDER:
		visible = true
	elif visible:
		visible = false

func on_from_stage_to_shop():
	clear_old_shop()
	load_items()
	prepare_view()
	
func on_update_items_prices():
	update_availability()
