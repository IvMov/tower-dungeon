extends Node
# TODO: after add saving and different players, add method to update var values from saving

const BASE_SPEED: float = 300.0
const BASE_JUMP_VELOCITY: float = 500.0
const BASE_AIR_SPEED: float = 250.0 # not work as need to adjust velocity in process method for player
const MOVE_SPEED_UP_MOD: float = 2.0

const JUMP_SPEED_UP_MOD: float = 1.2

var current_speed: float = BASE_SPEED
var current_air_speed: float = BASE_AIR_SPEED
var current_jump_velocity: float = BASE_JUMP_VELOCITY
var max_jumps: int = 50
var lock_stamina_skill: bool = false
var lock_mana_skill: bool = false
var is_aiming: bool = false
var is_runing: bool = false


var skill_expirience: Dictionary = {
	"spark_skill": {
		"lvl": 0, 
		"exp" : 0.0, 
		"next_lvl_exp": 10.0, 
		"max_lvl": 10
	}
}


func add_skill_exp(skill_name: String, value: float) -> void:
	var skill: Dictionary = get_skill_data(skill_name)
	if skill.is_empty() || skill["max_lvl"] == skill["lvl"]:
		print("Skill %s is max lvl already or not found - exp lost!" % skill)
		return
		
	var required_exp: float = skill["next_lvl_exp"] - skill["exp"]
	if required_exp <= value :
		skill["exp"] = skill["next_lvl_exp"]
		if lvl_up_skill(skill):
			add_skill_exp(skill_name, value - required_exp)
	else:
		skill["exp"] += value
	print(skill_expirience)

func get_skill_data(skill_name: String) -> Dictionary:
	if !skill_expirience.has(skill_name):
		print("NO SUCH SKILL FOUND TO OBTAIN AN EXP! with name %s" % skill_name)
		return {}
	return skill_expirience[skill_name]


func lvl_up_skill(skill: Dictionary) -> bool:
	if skill["max_lvl"] <= skill["lvl"]:
		print("skill has max lvl already!")
		return false
	else:
		skill["lvl"]+=1
		skill["exp"] = 0.0
		skill["next_lvl_exp"] = skill["next_lvl_exp"] + (skill["lvl"] * skill["max_lvl"]) + skill["max_lvl"]
		return true
