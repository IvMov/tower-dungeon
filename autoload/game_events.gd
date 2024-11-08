extends Node


signal change_game_stage(game_stage)
signal screen_resized()

signal player_entered(player: Player)
signal damage_player(damage: float)
signal run_player(speed: float)
signal aiming_player(aiming: bool)
signal push_player_back()

signal add_skill(hand: int, skill: Skill)
signal remove_skill(hand: int)
signal skill_call_failed(reason: Enums)

signal item_remove(from: Vector3, quantity: int)
signal item_add(to: Vector3, item: ItemBulk, map_pos: Vector3)
signal item_added(location: Vector2)
signal item_to_hand(item_view: ItemView)
signal item_from_hand(hand: int)
signal item_to_map(to: Vector3, item: PackedScene)
signal item_from_map(item: Node3D)
signal cant_pick_item()
signal item_hovered(item: ItemBulk)
signal item_unhovered()
signal item_consumed(position: int, item_id: String)
signal item_update_hand_view(hand: int)
signal redraw_item(key: Vector3)


signal souls_dropped(position: Vector3, value: Vector3)
signal souls_collect(position: Vector3, value: Vector3)

var soul: PackedScene = preload("res://scenes/dropable/soul.tscn")


func emit_change_game_stage(game_stage):
	change_game_stage.emit(game_stage)

func emit_screen_resized():
	screen_resized.emit()

func emit_player_entered(player: Player):
	player_entered.emit(player)

func emit_damage_player(damage: float):
	damage_player.emit(damage)

func emit_run_player(speed: float):
	run_player.emit(speed)

func emit_aiming_player(aiming: bool):
	aiming_player.emit(aiming)

func emit_add_skill(hand: int, skill: Skill):
	add_skill.emit(hand, skill)

func emit_skill_call_failed(reason: Enums.SkillCallFailedReason):
	print("skill usage failed %s " % reason)
	skill_call_failed.emit(reason)

func emit_souls_dropped(position: Vector3, value: Vector3):
	souls_dropped.emit(position, value)


func emit_souls_collect(position: Vector3, value: Vector3):
	souls_collect.emit(position, value)

func emit_item_remove(from: Vector3, quantity: int):
	item_remove.emit(from, quantity)

func emit_item_add(to: Vector3, item: ItemBulk, map_pos = Vector3.ZERO):
	item_add.emit(to, item, map_pos)

func emit_item_added(location: Vector3):
	item_added.emit(location)

func emit_item_to_map(to: Vector3, item: PackedScene):
	item_to_map.emit(to, item)

func emit_item_from_map(item: Node3D):
	item_from_map.emit(item)

func emit_cant_pick_item():
	cant_pick_item.emit()

func emit_item_to_hand(item_view: ItemView):
	item_to_hand.emit(item_view)

func emit_item_from_hand(hand: int):
	item_from_hand.emit(hand)

#related to items (skill_from_hand)
func emit_remove_skill(hand: int): 
	remove_skill.emit(hand)

func emit_item_hovered(item: ItemBulk):
	item_hovered.emit(item)

func emit_item_unhovered():
	item_unhovered.emit()

func emit_item_consumed(position: int, item_id: String):
	item_consumed.emit(position, item_id)

func emit_item_update_hand_view(hand: int):
	item_update_hand_view.emit(hand)

func emit_redraw_item(key: Vector3):
	redraw_item.emit(key)

func emit_push_player_back():
	push_player_back.emit()
