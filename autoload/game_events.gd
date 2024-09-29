extends Node


signal change_game_stage(game_stage)
signal screen_resized()

signal player_entered(player: Player)
signal damage_player(damage: float)
signal run_player(speed: float)
signal aiming_player(aiming: bool)

signal add_skill(skill: Skill)
signal skill_call_failed(reason: Enums)

signal item_remove(from: Vector3, quantity: int)
signal item_add(to: Vector3, item: ItemBulk)

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

func emit_add_skill(skill: Skill):
	add_skill.emit(skill)

func emit_skill_call_failed(reason: Enums.SkillCallFailedReason):
	print("skill usage failed %s " % reason)
	skill_call_failed.emit(reason)

func emit_souls_dropped(position: Vector3, value: Vector3):
	souls_dropped.emit(position, value)


func emit_souls_collect(position: Vector3, value: Vector3):
	souls_collect.emit(position, value)

func emit_item_remove(from: Vector3, quantity: int):
	item_remove.emit(from, quantity)

func emit_item_add(to: Vector3, item: ItemBulk):
	item_add.emit(to, item)
