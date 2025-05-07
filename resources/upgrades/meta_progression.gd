extends Node

@export var upgrade_pool: Dictionary[int, MetaUpgrade]

const PLAYERS_KEY: String = "players"
const PLAYER_NAME_KEY: String = "player_name"
const PROPS_KEY: String = "props"
const STATS_KEY: String = "stats"
const STORAGES_KEY: String = "storages"
const META_UPGRADES_KEY: String = "meta_upgrades"
const CONFIG_KEY: String = "config"

const FILE_PATH: String = "user://tower_dungeon.save"
const START_SKILL: Dictionary = {
	"id": 0,
	"quantity": 1
}
var EMPTY_METADATA: Dictionary = {
	PLAYERS_KEY: {}
}

var NEW_PLAYER: Dictionary = {
	"player_name": "default name",
	"game_lvl": 0, # map stage level ( from 0 to N, after each shop, after M entry)
	"difficulty": 2, # 1, 2, 3
	"kills": 0,
	"death": 0,
	"max_lifes": 3,
	"current_time": 0.0,
	"best_time": 0.0,
	"runs": 0,
	"coins": 100,
	"souls": Vector3.ONE * 100,
	"time_in_game_unix": 0.0,
	"traider_max_items_factor": 1.0,
	"dash" : {
		"time": 0.3,
		"cd": 1.5,
		"value": 10,
		"energy": 5.0
	},
	STATS_KEY: {
		"max_hp": 5,
		"current_hp": 5,
		"regen_hp": 1,
		"max_mana": 50,
		"current_mana": 20,
		"regen_mana": 1,
		"max_stamina": 50,
		"current_stamina": 20,
		"regen_stamina": 1
	},
	PROPS_KEY: {
		"lifes": 0,
		"max_jumps": 2,
		"base_speed": 400,
		"base_jump": 500,
		"speed_up_mode": 2.0,
		"jump_speed_up_mode": 1.2,
		"dmg_boost": 1.0,
		"speed_boost": 1.0,
		"damage_resist_factor": 1.0,
		"price_modifier": 1.0
	},
	STORAGES_KEY: {
		"traider": {
		},
		"traider_core": {
			Constants.ITEM_ZOOM_ID: 1, #zoom
			Constants.ITEM_STONE_ID: randi_range(Constants.items_pool.get(Constants.ITEM_STONE_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_STONE_ID).max_for_trade), # stone
			Constants.ITEM_CRYSTAL_ID: randi_range(Constants.items_pool.get(Constants.ITEM_CRYSTAL_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_CRYSTAL_ID).max_for_trade), # crystals
			Constants.ITEM_SNOWBALL_ID: randi_range(Constants.items_pool.get(Constants.ITEM_SNOWBALL_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_SNOWBALL_ID).max_for_trade), #snowball
			Constants.ITEM_HEAL_ID: randi_range(Constants.items_pool.get(Constants.ITEM_HEAL_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_HEAL_ID).max_for_trade), 
			Constants.ITEM_MANA_ID: randi_range(Constants.items_pool.get(Constants.ITEM_MANA_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_MANA_ID).max_for_trade), 
			Constants.ITEM_STAMINA_ID: randi_range(Constants.items_pool.get(Constants.ITEM_STAMINA_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_STAMINA_ID).max_for_trade), 
			Constants.ITEM_DAMAGE_ID: randi_range(Constants.items_pool.get(Constants.ITEM_DAMAGE_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_DAMAGE_ID).max_for_trade), 
			Constants.ITEM_SPEED_ID: randi_range(Constants.items_pool.get(Constants.ITEM_SPEED_ID).min_for_trade, Constants.items_pool.get(Constants.ITEM_SPEED_ID).max_for_trade), 
		},
		"inventory": {
			"id": 0,
			"size": Vector2(3, 4),
			"items": {}
		},
		"belt": {
			"id": 1,
			"size": Vector2(3, 4),
			"items": {
				Vector2.ZERO: START_SKILL
			}
		},
		"hands": {
			"id": 3,
			"size": Vector2(0, 1),
			"items": {}
		}
	},
	"skill_expirience": {},
	"enemy_expirience": {},
	META_UPGRADES_KEY: {
	},
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
	}
}

var meta_upgrade: Dictionary = {
	#contains info about upgrade, maybe resource with link to some upgradeJob
	#upgradeJob runs ones when achieved and add some new to game - higher damage base or new belt section
} 

#parrent wrapper object for all players and configs to be persist
var meta_data: Dictionary = {}


func _ready() -> void:
	meta_data = init_meta_data()
	#reset_file() #uncomit to erase all saves

func init_meta_data() -> Dictionary:
	if !FileAccess.file_exists(FILE_PATH):
		return EMPTY_METADATA.duplicate()
	else:
		meta_data = read_file()
		return meta_data

func apply_meta_upgrade(id: int) -> void:
	PlayerParameters.player.upgrade_done_particles.emitting = true
	match id:
		Constants.ITEM_ACID_METEOR_ID:
			PlayerParameters.player_data[MetaProgression.STORAGES_KEY]["traider_core"].set(Constants.ITEM_ACID_METEOR_ID, 1)
		Constants.ITEM_FIREBALL_ID:
			PlayerParameters.player_data[MetaProgression.STORAGES_KEY]["traider_core"].set(Constants.ITEM_FIREBALL_ID, 1)
		Constants.ITEM_FIRE_BLADE_TRAP_ID:
			PlayerParameters.player_data[MetaProgression.STORAGES_KEY]["traider_core"].set(Constants.ITEM_FIRE_BLADE_TRAP_ID, 1)
		Constants.HP_UP_1_UPGRADE_ID, Constants.HP_UP_2_UPGRADE_ID:
			PlayerParameters.player.health_component.max_value += MetaProgression.upgrade_pool[id].value
			PlayerParameters.player.health_component.emit_max_value_changed(PlayerParameters.player.health_component.max_value)
			PlayerParameters.player.health_component.minus(0)
		Constants.HP_REGEN_1_UPGRADE_ID, Constants.HP_REGEN_2_UPGRADE_ID:
			PlayerParameters.player.health_component.regen += MetaProgression.upgrade_pool[id].value
			PlayerParameters.player.health_component.emit_regen_changed(PlayerParameters.player.health_component.regen)
		Constants.DASH_CD_1_UPGRADE_ID, Constants.DASH_CD_2_UPGRADE_ID:
			var new_cd: float = PlayerParameters.player_data["dash"]["cd"] * MetaProgression.upgrade_pool[id].value
			PlayerParameters.player_data["dash"]["cd"] = new_cd
			GameEvents.emit_dash_upgrade(new_cd, 0)
		Constants.TRAIDER_1_UPGRADE_ID, Constants.TRAIDER_2_UPGRADE_ID:
			var new_mod: float = PlayerParameters.player_data["traider_max_items_factor"] * MetaProgression.upgrade_pool[id].value
			PlayerParameters.player_data["traider_max_items_factor"] = new_mod
	
func build_meta_upgrade(id: int) -> Dictionary:
	return {
		"id": id,
		"required": upgrade_pool[id].price,
		"real": Vector4.ZERO,
		"is_done": false
	}

func load_available_meta_upgrades(username: String) -> void:
	for id in upgrade_pool:
		meta_data[PLAYERS_KEY][username][META_UPGRADES_KEY]\
		.set(id, build_meta_upgrade(id))

func get_players() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for player in meta_data[PLAYERS_KEY]:
		result.append({
			PLAYER_NAME_KEY: player,
			"difficulty": meta_data[PLAYERS_KEY][player]["difficulty"],
			"kills": meta_data[PLAYERS_KEY][player]["kills"]
		})
	return result

func get_by_username(username: String) -> Dictionary:
	var player = meta_data[PLAYERS_KEY].get(username)
	return player if player else {}


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
		new[PROPS_KEY]["lifes"] = 0 # temporary to fast death
		#new[PROPS_KEY]["lifes"] = new["max_lifes"]
		new[PLAYER_NAME_KEY] = username
		new["difficulty"] = difficulty
		meta_data["players"].set(username, new)
		load_available_meta_upgrades(username)
		save_file()
		return true

func save_game_on_quit() -> void: 
	if PlayerParameters.player_name:
		print("MetaData INFO: game saved actions started")
		save_game()
		$Timer.start()
		await $Timer.timeout
		print("MetaData INFO: game saved actions finished")

func save_game():
	PlayerParameters.prepare_to_save()
	print(PlayerParameters.player_data)
	meta_data[PLAYERS_KEY].set(PlayerParameters.player_name, PlayerParameters.player_data)
	save_file()
