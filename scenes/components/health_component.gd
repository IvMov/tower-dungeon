class_name HealthComponent
extends Node

@export var owner_node: CharacterBody3D
@export var max_hp: float
@export var current_hp: float
@export var hp_regen: float


func minus_hp(value: float):
	current_hp = max(0, current_hp - value)
	if current_hp == 0:
		die()


func plus_hp(value: float):
	if current_hp == max_hp:
		return
	current_hp = min(max_hp, current_hp + value)

func die():
	owner.custom_death_actions()
	owner.is_dying = true
	if owner is BasicEnemy:
		owner.agr_area.disable_mode = true
		owner.death_timer.start()
	
	owner.animation_player.play("die")
	await owner.animation_player.animation_finished
	var tween = create_tween()
	tween.tween_property(owner, "global_position", Vector3(owner.global_position.x, owner.global_position.y+2, owner.global_position.z) , 0.3)
