extends Node

#TODO: changed to vars but also need to change style
var BASE_SPEED: float = 400.0
var BASE_JUMP_VELOCITY: float = 500.0
var BASE_AIR_SPEED: float = 250.0 # not work as need to adjust velocity in process method for player
var MOVE_SPEED_UP_MOD: float = 2.0
var JUMP_SPEED_UP_MOD: float = 1.2

var player_name: String
var lifes: int = 3
var current_speed: float = BASE_SPEED
var current_air_speed: float = BASE_AIR_SPEED
var current_jump_velocity: float = BASE_JUMP_VELOCITY
var max_jumps: int = 50
var lock_stamina_skill: bool = false
var lock_mana_skill: bool = false
var is_aiming: bool = false
var is_runing: bool = false
var last_position: Vector3 = Vector3.ZERO
var start_game_time: float

var player_data: Dictionary
var player: Player
var inventory: Inventory
var belt: Belt
var hands: Hands



var souls: Vector3 = Vector3.ZERO
var coins: int
var kills: int = 0
var runs: int = 0
var best_time: float = 0
var skill_expirience: Dictionary = {}
var meta_upgrades: Dictionary = {}

#boosters
var damage_boost: float = 1
var speed_boost: float = 1
var damage_resist_factor: float = 1
var price_modifier: float = 1



func _ready() -> void:
	GameEvents.add_skill.connect(on_add_skill)
	GameEvents.player_entered.connect(on_player_entered)

func adjust_difficulty() -> void:
	GameConfig.game_difficulty = player_data["difficulty"]
	if GameConfig.game_difficulty == 2:
		return
	if GameConfig.game_difficulty == 1:
		damage_resist_factor = 0.5
		damage_boost = 1.5
		price_modifier = 0.8
	elif GameConfig.game_difficulty == 3: 
		damage_resist_factor = 1.5

func load_player_by_username(username: String) -> void: 
	player_data = MetaProgression.get_by_username(username)
	souls = player_data["souls"]
	coins = player_data["coins"]
	kills = player_data["kills"]
	runs = player_data["runs"]
	best_time = player_data["best_time"]
	skill_expirience = player_data["skill_expirience"]
	meta_upgrades = player_data[MetaProgression.META_UPGRADES_KEY]
	load_props()

func load_props() -> void:
	var props: Dictionary = player_data[MetaProgression.PROPS_KEY]
	lifes = props["lifes"] if player_data["current_time"] == 0.0 else player_data["max_lifes"]
	max_jumps = props["max_jumps"]
	BASE_SPEED = props["base_speed"]
	BASE_JUMP_VELOCITY = props["base_jump"]
	MOVE_SPEED_UP_MOD = props["speed_up_mode"]
	JUMP_SPEED_UP_MOD = props["jump_speed_up_mode"]
	damage_boost = props["dmg_boost"]
	speed_boost = props["speed_boost"]
	damage_resist_factor = props["damage_resist_factor"]

func save_run_time(time: float, game_over: bool) -> void:
	if game_over:
		player_data["current_time"] = 0.0
		runs+=1
		player_data["death"]+=1
		if best_time > time: 
			return
		else:
			best_time = time
		#TODO: EMIT BEST TIME WINDOW shows
	else:
		player_data["current_time"] = time

func prepare_to_save() -> void: 
	#core
	player_data["souls"] = souls
	player_data["coins"] = coins
	player_data["kills"] = kills
	player_data["best_time"] = best_time
	player_data["skill_expirience"] = skill_expirience
	player_data["time_in_game_unix"] += Time.get_unix_time_from_system() - start_game_time
	player_data[MetaProgression.META_UPGRADES_KEY] = meta_upgrades
	#props
	player_data[MetaProgression.PROPS_KEY]["lifes"] = lifes 
	player_data[MetaProgression.PROPS_KEY]["max_jumps"] = max_jumps 
	player_data[MetaProgression.PROPS_KEY]["base_speed"] = BASE_SPEED 
	player_data[MetaProgression.PROPS_KEY]["base_jump"] = BASE_JUMP_VELOCITY 
	player_data[MetaProgression.PROPS_KEY]["speed_up_mode"] = MOVE_SPEED_UP_MOD 
	player_data[MetaProgression.PROPS_KEY]["jump_speed_up_mode"] = JUMP_SPEED_UP_MOD 
	player_data[MetaProgression.PROPS_KEY]["dmg_boost"] = damage_boost 
	player_data[MetaProgression.PROPS_KEY]["speed_boost"] = speed_boost 
	player_data[MetaProgression.PROPS_KEY]["damage_resist_factor"] = damage_resist_factor 
	#storages
	inventory.save_storage(player_data, inventory.NAME)
	belt.save_storage(player_data, belt.NAME)
	hands.save_storage(player_data, hands.NAME)

func get_current_speed() -> float:
	return current_speed * speed_boost

func add_skill_exp(skill_id: int, value: float) -> void:
	var skill: Dictionary = get_skill_data(skill_id)
	if skill.is_empty() || skill["max_lvl"] == skill["lvl"]:
		print("EXCEPTION: Skill %s is max lvl already or not found - exp lost!" % skill)
		return
		
	var required_exp: float = skill["next_lvl_exp"] - skill["exp"]
	if required_exp <= value :
		skill["exp"] = skill["next_lvl_exp"]
		if lvl_up_skill(skill):
			add_skill_exp(skill_id, value - required_exp)
	else:
		skill["exp"] += value

func get_skill_data(skill_id: int) -> Dictionary:
	if !skill_expirience.has(skill_id):
		print("EXCEPTION: NO SUCH SKILL FOUND TO OBTAIN AN EXP! with name %d" % skill_id)
		return {}
	return skill_expirience[skill_id]

func find_item(position: Vector3) -> ItemBulk:
	var result: ItemBulk = inventory.items.get(position)
	if position.x == 0:
		result = inventory.items.get(position)
	elif position.x == 1:
		result = belt.items.get(position)
	elif position.x == 3:
		result = hands.items.get(position)
	return result

func find_item_position_by_id(item_id: int) -> Vector3:
	var negative_result = Vector3.ONE * -1
	var result: Vector3 = inventory.find_location_by_id(item_id)
	if result == Vector3(-1,-1,-1):
		result = belt.find_location_by_id(item_id)
	if result == Vector3(-1,-1,-1):
		result = hands.find_location_by_id(item_id) 
	return result

func lvl_up_skill(skill: Dictionary) -> bool:
	if skill["max_lvl"] <= skill["lvl"]:
		print("INFO: skill has max lvl already!")
		return false
	else:
		skill["lvl"]+=1
		skill["exp"] = 0.0
		skill["next_lvl_exp"] = skill["next_lvl_exp"] * skill["exp_multiplier"]
		return true


func add_coin() -> void:
	coins += 1
	print(coins)

func add_soul(soul_type: Enums.SoulType) -> void:
	if soul_type == Enums.SoulType.GREEN:
		souls.x += 1
	elif soul_type == Enums.SoulType.BLUE:
		souls.y += 1
	elif soul_type == Enums.SoulType.RED:
		souls.z += 1
	GameEvents.emit_souls_update_view()

#before close entry room save data for each meta data
func add_meta_upgrade_val(key: int, value: Vector4) -> void:
	if meta_upgrades.has(key):
		var upgrade_data: Dictionary = meta_upgrades.get(key)
		if value == upgrade_data["real"]:
			return
		upgrade_data["real"] = value
		if upgrade_data["real"] >= upgrade_data["required"]:
			upgrade_data["done"] = true


func get_position(height: float = 0) -> Vector3:
	if player && player.is_inside_tree():
		last_position = player.global_position
		last_position.y += height
	else:
		print("ERROR: NO PLAYER found in tree!")
	return last_position

func on_player_entered(player: Player) -> void:
	player_name = player_data[MetaProgression.PLAYER_NAME_KEY]
	player_data["time_in_game_unix"]
	if player_data["time_in_game_unix"] == 0.0:
		adjust_difficulty()
	EnemyParameters.load_enemies_data(player_data)
	start_game_time = Time.get_unix_time_from_system()
	self.player = player
	inventory = player.inventory
	belt = player.belt
	hands = player.hands


func on_add_skill(_hand:int, skill: Skill) -> void:
	if skill.is_upgradable && !skill_expirience.has(skill.id):
		skill_expirience[skill.id] =  {
				"lvl": 0, 
				"exp" : 0.0, 
				"exp_multiplier": skill.exp_multiplier,
				"next_lvl_exp": skill.base_value * 10, 
				"max_lvl": skill.max_lvl
			}
