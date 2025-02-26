class_name PlayerSkillController extends Node

var player: Player

var player_skills: Dictionary

var primary_skill: Skill
var secondary_skill: Skill

var primary_skill_controller: BaseController
var secondary_skill_controller: BaseController

@export var jump_skill: JumpSkillController
@export var run_skill: RunSkillController
@export var push_skill: PushEnemySkillController
@export var dash_skill: DashSkillController


func _ready() -> void:
	player = get_parent()
	GameEvents.add_skill.connect(on_add_skill)
	GameEvents.remove_skill.connect(on_remove_skill)


func choose_active_skill(id: String) -> void:
	primary_skill = player_skills[id]

func cast_active_skill(hand: int, is_pressed: bool) -> void:
	var skill: Skill = primary_skill if hand == 0 else secondary_skill
	var skill_controller: BaseController = primary_skill_controller if hand == 0 else secondary_skill_controller
	if !player || !skill_controller:
		return
	if skill.is_maintainable && is_pressed:
		skill_controller.use_skill()
	else:
		skill_controller.start_cast()


func use_active_skill(hand: int, is_pressed: bool) -> void:
	var skill: Skill = primary_skill if hand == 0 else secondary_skill
	
	var skill_controller: BaseController = primary_skill_controller if hand == 0 else secondary_skill_controller
	if !player || !skill_controller:
		return
	if skill.is_maintainable && !is_pressed:
		skill_controller.stop_skill()
	else:
		skill_controller.finish_cast()



func map_skill_to_controller(controller: BaseController, skill: Skill) -> void:
	controller.skill = skill


func on_add_skill(hand:int, skill: Skill) -> void:
	if !player:
		return
	
	if !player_skills.has(skill.id):
		player_skills[skill.id] = skill;
		var controller_instance: BaseController = skill.controller.instantiate()
		controller_instance.add_to_group(skill.title)
		player.skill_box.add_child(controller_instance)
		map_skill_to_controller(controller_instance, skill)
		controller_instance.player = player
	
	if !primary_skill && hand == 0:
		primary_skill = skill
		primary_skill_controller = get_tree().get_first_node_in_group(skill.title)
		primary_skill_controller.hand = 0;
	elif !secondary_skill && hand == 1:
		secondary_skill = skill
		secondary_skill_controller = get_tree().get_first_node_in_group(skill.title)
		secondary_skill_controller.hand = 1;

func on_remove_skill(hand: int):
	if hand == 0:
		primary_skill = null
		primary_skill_controller = null
	elif hand == 1:
		secondary_skill = null
		secondary_skill_controller = null
