extends Node

@export var permanent_upgrade_pool: Array[MetaUpgrade]

const PLAYERS_KEY: String = "players"
const PLAYER_NAME_KEY: String = "player_name"
const PROPS_KEY: String = "props"
const STORAGES_KEY: String = "storages"
const META_UPGRADES_KEY: String = "meta_upgrades"
const CONFIG_KEY: String = "config"


const FILE_PATH: String = "user://tower_dungeon.save"

var EMPTY_METADATA: Dictionary = {
	PLAYERS_KEY: {}
}

var NEW_PLAYER: Dictionary = {
	"player_name": "default name",
	"difficulty": 1, # 1, 2, 3
	"kills": 0,
	"death": 0,
	"runs": 0,
	"coins": 0,
	"souls": Vector3.ZERO,
	PROPS_KEY: {
		"lifes": 3,
		"max_jumps": 2,
		"base_speed": 400,
		"base_jump": 500,
		"speed_up_mode": 2.0,
		"jump_speed_up_mode": 1.2,
		"dmg_boost": 1.0,
		"speed_boost": 1.0
	},
	STORAGES_KEY: {
		"inventory": {
			"id": 0,
			"size": Vector2(3, 4),
			"items": {}
		},
		"belt": {
			"id": 1,
			"size": Vector2(3, 4),
			"items": {}
		},
		"hands": {
			"id": 2,
			"size": Vector2(0, 1),
			"items": {}
		}
	},
	"skill_expirience": {},
	META_UPGRADES_KEY: {},
	CONFIG_KEY: {
		"sound": {
			"sfx": 10.0,
			"music": 10.0
		},
		"screen": {
			"resolution": Vector2(1366, 768),
			"full_screen": false
		},
		"graphics": {
			"shaders": false 
		}
	},
}

var meta_upgrade: Dictionary = {
	#contains info about upgrade, maybe resource with link to some upgradeJob
	#upgradeJob runs ones when achieved and add some new to game - higher damage base or new belt section
} 


#wrapper object for all players and configs to be persist
var meta_data: Dictionary = {}


func _ready() -> void:
	meta_data = init_meta_data()
	#reset_file()

func load_available_meta_upgrades() -> void:
	for upgrade in permanent_upgrade_pool:
		meta_data[PLAYERS_KEY]\
		.get(PlayerParameters.player.player_name)[META_UPGRADES_KEY]\
		.set(upgrade.get("id"), upgrade)

func get_players() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for player in meta_data[PLAYERS_KEY].values():
		result.append({
			PLAYER_NAME_KEY: player[PLAYER_NAME_KEY],
			"difficulty": player["difficulty"],
			"kills": player["kills"]
		})
	return result

func get_by_username(username: String) -> Dictionary:
	var player = meta_data[PLAYERS_KEY].get(username)
	return player if player else {}
	
func init_meta_data() -> Dictionary:
	if !FileAccess.file_exists(FILE_PATH):
		return EMPTY_METADATA.duplicate()
	else:
		meta_data = read_file()
		return meta_data


func read_file() -> Dictionary:
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var data = file.get_var()
	file.close()
	return data

func save_file() -> void:
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(meta_data)
	file.close()
	
	
func reset_file():
	if !FileAccess.file_exists(FILE_PATH):
		return
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	meta_data = EMPTY_METADATA.duplicate()
	save_file()


func add_player(username: String, difficulty: int) -> bool:
	var player = get_by_username(username)
	if player:
		print("MetaData ERROR: player with same name already exists")
		return false
	else:
		var new: Dictionary = NEW_PLAYER.duplicate(true)
		new[PLAYER_NAME_KEY] = username
		new["difficulty"] = difficulty
		meta_data["players"].set(username, new)
		save_file()
		return true

func save_player(user_name: String) -> void:
	meta_data[PLAYERS_KEY]
	
func add_empty_upgrade(upgrade: MetaUpgrade):
	return { "lvl": 0, "base": upgrade.base, "value": upgrade.value }
	
	
func add_upgrade(upgrade: MetaUpgrade):
	if meta_data["upgrades"][upgrade.id]["lvl"] < upgrade.max_lvl:
		meta_data["upgrades"][upgrade.id]["lvl"] += 1
		

func on_game_started():
	meta_data["runs"] += 1


func on_game_win():
	meta_data["win_runs"] += 1

func save_game_on_quit() -> void: 
	print("game saved actions started")
	save_game()
	$Timer.start()
	await $Timer.timeout
	print("game saved actions finished")

func save_game():
	
	#meta_data["difficulty"] = GameConfig.game_difficulty
	#meta_data["coins"] += PlayerParameters.coins
	#meta_data["kills"] += PlayerParameters.kills
	#meta_data["souls"] += PlayerParameters.souls
	#var time_manager = get_tree().get_first_node_in_group("arena_time_manager") 
	#if time_manager && meta_data["best_time"] < time_manager.get_time_elapsed():
		#meta_data["best_time"] = time_manager.get_time_elapsed();
	save_file()



func on_permanent_upgrade_buy(upgrade: MetaUpgrade):
	add_upgrade(upgrade)
	
