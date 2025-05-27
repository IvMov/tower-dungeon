extends Node
var max_lvl: int = 10

#persist
var hp_modifier: float = 1.0
var dmg_resist_modifier: float = 1.0
var stamina_modifier: float = 1.0
var hp_regen_modifier: float = 1.0
var stamina_regen_modifier: float = 1.0
var drop_modifier: float = 1
var random_enemy_spawn_chance: float = 0.5

var enemies_data: Dictionary = {}
var enemy_expirience: Dictionary = {
	"tier_1_enemy": {
		"lvl": 0, 
		"exp" : 0.0, 
		"next_lvl_exp": 10.0, 
		"max_lvl": 10
	}
}



func load_enemies_data(player_data: Dictionary) -> void:
	enemy_expirience = player_data["enemy_expirience"]
	random_enemy_spawn_chance = calc_random_enemy_spawn_chance()
	adjust_difficulty()

func calc_random_enemy_spawn_chance() -> float:
	#TODO: implement when gameStage will be present
	#some calculation to get float 0-1 
	#GameConfig.game_difficulty
	#GameConfig.game_stage (represents stage of game)
	return 0.5
	
func adjust_difficulty() -> void:
	if GameConfig.game_difficulty == 2:
		return
	if GameConfig.game_difficulty == 1:
		hp_modifier = 0.8
		hp_regen_modifier = 0.5
		stamina_regen_modifier = 0.5
	elif GameConfig.game_difficulty == 3:
		drop_modifier = 1.5
		hp_modifier = 1.5
		dmg_resist_modifier = 1.2
		hp_regen_modifier = 1.5
		stamina_modifier = 1.5
		stamina_regen_modifier = 1.5

func add_exp(enemy_name: String, value: float) -> void:
	var enemy: Dictionary = get_enemy_data(enemy_name)
	if enemy.is_empty() || enemy["max_lvl"] == enemy["lvl"]:
		print("EXCEPTION: Enemy %s is max lvl already or not found - exp lost!" % enemy_name)
		return
		
	var required_exp: float = enemy["next_lvl_exp"] - enemy["exp"]
	if required_exp <= value :
		enemy["exp"] = enemy["next_lvl_exp"]
		if lvl_up(enemy):
			add_exp(enemy_name, value - required_exp)
	else:
		enemy["exp"] += value

func get_enemy_data(enemy_name: String) -> Dictionary:
	if !enemy_expirience.has(enemy_name):
		print("EXCEPTION: NO SUCH ENEMY FOUND TO OBTAIN AN EXP! with name %s" % enemy_name)
		return {}
	return enemy_expirience[enemy_name]


func lvl_up(enemy: Dictionary) -> bool:
	if enemy["max_lvl"] <= enemy["lvl"]:
		print("INFO: enemy has max lvl already!")
		return false
	else:
		enemy["lvl"]+=1
		enemy["exp"] = 0.0
		enemy["next_lvl_exp"] = enemy["next_lvl_exp"] + (enemy["lvl"] * enemy["max_lvl"]) + enemy["max_lvl"]
		return true
