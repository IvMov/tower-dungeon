extends Node
var max_lvl: int = 10

var enemy_expirience: Dictionary = {
	"tier_1_enemy": {
		"lvl": 0, 
		"exp" : 0.0, 
		"next_lvl_exp": 10.0, 
		"max_lvl": 10
	}
}


func add_exp(enemy_name: String, value: float) -> void:
	var enemy: Dictionary = get_enemy_data(enemy_name)
	if enemy.is_empty() || enemy["max_lvl"] == enemy["lvl"]:
		print("Enemy %s is max lvl already or not found - exp lost!" % enemy_name)
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
		print("NO SUCH ENEMY FOUND TO OBTAIN AN EXP! with name %s" % enemy_name)
		return {}
	return enemy_expirience[enemy_name]


func lvl_up(enemy: Dictionary) -> bool:
	if enemy["max_lvl"] <= enemy["lvl"]:
		print("enemy has max lvl already!")
		return false
	else:
		enemy["lvl"]+=1
		enemy["exp"] = 0.0
		enemy["next_lvl_exp"] = enemy["next_lvl_exp"] + (enemy["lvl"] * enemy["max_lvl"]) + enemy["max_lvl"]
		return true
