extends Node


signal change_game_stage(game_stage)
signal screen_resized()

signal damage_player(damage: float)

signal add_skill(skill: Skill)
signal skill_call_failed(reason: Enums)

signal souls_dropped(position: Vector3, value: Vector3)
signal souls_collect(position: Vector3, value: Vector3)

var soul: PackedScene = preload("res://scenes/dropable/soul.tscn")


func emit_change_game_stage(game_stage):
	change_game_stage.emit(game_stage)

func emit_screen_resized():
	screen_resized.emit()

func emit_damage_player(damage: float):
	damage_player.emit(damage)

func emit_add_skill(skill: Skill):
	add_skill.emit(skill)

func emit_skill_call_failed(reason: Enums.SkillCallFailedReason):
	print("skill usage failed %s " % reason)
	skill_call_failed.emit(reason)

func emit_souls_dropped(position: Vector3, value: Vector3):
	souls_dropped.emit(position, value)


func emit_souls_collect(position: Vector3, value: Vector3):
	souls_collect.emit(position, value)
