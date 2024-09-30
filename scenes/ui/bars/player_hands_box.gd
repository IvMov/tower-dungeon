extends PanelContainer

@onready var hands: HBoxContainer = $Hands
@onready var left_hand: ItemViewHolder = $Hands/LeftHand
@onready var right_hand: ItemViewHolder = $Hands/RightHand

func _ready() -> void:
	GameEvents.player_entered.connect(on_player_entered)
	GameEvents.item_to_hand.connect(on_item_to_hand)

func draw_items() -> void:
	for coordinate in PlayerParameters.hands.items:
		var item_bulk: ItemBulk = PlayerParameters.belt.items.get(coordinate)
		var item_view: ItemView = hands.get_child(coordinate.y).item_view
		item_view.item_bulk = item_bulk
		item_view.draw_item()

func resize():
	for child in hands.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*1.2, GameConfig.grid_block*1.2)

func on_player_entered(_player: Player) -> void:
	left_hand.set_location(Vector3(PlayerParameters.hands.id, 0, 0))
	right_hand.set_location(Vector3(PlayerParameters.hands.id, 0, 1))
	draw_items()

func on_item_to_hand(item_view: ItemView) -> void:
	left_hand.item_view.put_item(item_view)
