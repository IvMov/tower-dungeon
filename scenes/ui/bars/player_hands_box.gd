extends PanelContainer

@onready var hands: HBoxContainer = $VBoxContainer/Hands
@onready var left_hand: ItemViewHolder = $VBoxContainer/Hands/LeftHand
@onready var right_hand: ItemViewHolder = $VBoxContainer/Hands/RightHand


func _ready() -> void:
	GameEvents.player_entered.connect(on_player_entered)
	GameEvents.item_to_hand.connect(on_item_to_hand)
	GameEvents.item_update_hand_view.connect(on_item_update_hand_view)
	GameEvents.item_from_storage.connect(on_item_from_storage)
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	GameEvents.game_end.connect(on_game_end)

func draw_items() -> void:
	for coordinate in PlayerParameters.hands.items:
		var item_bulk: ItemBulk = PlayerParameters.hands.items.get(coordinate)
		var item_view: ItemView = hands.get_child(coordinate.y).item_view
		item_view.item_bulk = item_bulk
		item_view.draw_item()

func resize():
	for child in hands.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*1.2, GameConfig.grid_block*1.2)

func on_player_entered(_player: Player):
	left_hand.set_location(Vector3(PlayerParameters.hands.id, 0, 0))
	right_hand.set_location(Vector3(PlayerParameters.hands.id, 0, 1))
	draw_items()

func on_item_to_hand(item_view: ItemView):
	left_hand.item_view.put_item(item_view)

func on_item_from_storage(from: Vector3):
	if from.x != 3:
		return
	if from.z == 0:
		left_hand.item_view.clear()
	else:
		right_hand.item_view.clear()
	GameEvents.emit_remove_skill(from.z)

func on_item_update_hand_view(hand: int):
	if hand == 0:
		left_hand.item_view.draw_item()
	else:
		right_hand.item_view.draw_item()


func on_item_remove(from: Vector3, _quantity: int):
	if from.x == 3 && !left_hand.item_view.item_bulk:
		GameEvents.emit_remove_skill(0)
	elif from.x == 3 && !right_hand.item_view.item_bulk:
		GameEvents.emit_remove_skill(1)

func on_item_add(to: Vector3, new_item_bulk: ItemBulk, _map_pos: Vector3):
	if to.x == 3:
		GameEvents.emit_add_skill(to.z, new_item_bulk.item.skill)

func on_game_end():
	GameEvents.emit_remove_skill(0)
	GameEvents.emit_remove_skill(1)
	left_hand.item_view.clear()
	right_hand.item_view.clear()
