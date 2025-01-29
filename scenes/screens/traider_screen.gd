extends MarginContainer

var items: Array[ItemBulk]

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

func resize() -> void:
	custom_minimum_size =  Vector2(GameConfig.grid_block*4, GameConfig.grid_block*2)
	for child in traider_items.get_children():
		if child is TraiderItem:
			child.resize()

func load_items() -> void:
	items.append(ItemBulk.new(Constants.ITEM_CRYSTAL, randi_range(1,20)))
	items.append(ItemBulk.new(Constants.ITEM_STONE, randi_range(1,20)))

func prepare_view() -> void:
	for item in items:
		var traider_item: TraiderItem = Constants.TRAIDER_ITEM.instantiate()
		traider_items.add_child(traider_item)
		traider_item.build(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	load_items()
	prepare_view()
	

	
	
	
	
