class_name PlayerSkillController extends Node

var player: Player

var player_skills: Dictionary
var active_skill: Skill

@export var jump_skill: JumpSkillController
@export var run_skill: RunSkillController
@export var aim_skill: AimSkillController
@export var push_skill: PushEnemySkillController


func _ready() -> void:
	player = get_parent()
	GameEvents.add_skill.connect(on_add_skill)


func choose_active_skill(id: String) -> void:
	active_skill = player_skills[id]

func cast_active_skill() -> void:
	if !player:
		return
	var skill_controller: BaseController = get_tree().get_first_node_in_group(active_skill.name)
	skill_controller.start_cast()
	
func use_active_skill() -> void:
	if !player:
		return
	var skill_controller: BaseController = get_tree().get_first_node_in_group(active_skill.name)
	skill_controller.finish_cast()


func on_add_skill(skill: Skill) -> void:
	if !player:
		return
	player_skills[skill.id] = skill;
	var controller_instance: BaseController = skill.controller.instantiate()
	controller_instance.add_to_group(skill.name)
	player.skill_box.add_child(controller_instance)
	map_skill_to_controller(controller_instance, skill)
	controller_instance.player = player
	
	if !active_skill:
		active_skill = skill


func map_skill_to_controller(controller: BaseController, skill: Skill) -> void:
	controller.id = skill.id
	controller.skill_name = skill.name
	controller.description = skill.description
	controller.base_value = skill.base_value
	controller.base_push_value = skill.base_push_value
	controller.base_speed = skill.base_speed
	controller.base_distance = skill.base_distance
	controller.base_energy_cost = skill.base_energy_cost
	controller.base_cast_time = skill.base_cast_time
	controller.base_duration = skill.base_duration
	controller.base_cooldown = skill.base_cooldown



