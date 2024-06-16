extends Node


signal change_game_stage(game_stage)
signal screen_resized()
signal damage_player(damage: float)
signal add_skill(skill: Skill)
signal skill_call_failed(reason: Enums)

func emit_change_game_stage(game_stage):
	change_game_stage.emit(game_stage)

func emit_screen_resized():
	screen_resized.emit()

func emit_damage_player(damage: float):
	damage_player.emit(damage)

func emit_add_skill(skill: Skill):
	add_skill.emit(skill)

func emit_skill_call_failed(reason: Enums.SkillCallFailedReason):
	skill_call_failed.emit(reason)
