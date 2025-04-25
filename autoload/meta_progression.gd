extends Node

const FILE_PATH: String = "user://tower_dungeon.save"
@export var permanent_upgrade_pool: Array[MetaUpgrade]

var empty_meta_data: Dictionary = {
	"difficulty": 2,
	"runs": 0,
	"win_runs" : 0,
	"coins": 0,
	"kills": 0,
	"best_time": 0,
	"upgrades": {}
} 

var meta_data: Dictionary

func _ready():
	for upgrade in permanent_upgrade_pool:
		if !empty_meta_data["upgrades"].has(upgrade.id):
			empty_meta_data["upgrades"][upgrade.id] = add_empty_upgrade(upgrade)
	init_meta_data()
	#from old game
	#GameEvents.game_started.connect(on_game_started)
	#GameEvents.game_win.connect(on_game_win)
	#GameEvents.save_game.connect(on_save_game)
	#GameEvents.permanent_upgrade_buy.connect(on_permanent_upgrade_buy)


func init_meta_data():
	if !FileAccess.file_exists(FILE_PATH):
		meta_data = empty_meta_data.duplicate()
		return
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	meta_data = file.get_var()


func save_file():
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(meta_data)
	
	
func reset_file():
	if !FileAccess.file_exists(FILE_PATH):
		return
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_var(empty_meta_data)
	file.close()
	init_meta_data()
	
	
func add_empty_upgrade(upgrade: MetaUpgrade):
	return { "lvl": 0, "base": upgrade.base, "value": upgrade.value }
	
	
func add_upgrade(upgrade: MetaUpgrade):
	if meta_data["upgrades"][upgrade.id]["lvl"] < upgrade.max_lvl:
		meta_data["upgrades"][upgrade.id]["lvl"] += 1
		

func on_game_started():
	meta_data["runs"] += 1


func on_game_win():
	meta_data["win_runs"] += 1


func on_save_game():
	meta_data["difficulty"] = GameConfig.game_difficulty
	meta_data["coins"] += PlayerParameters.coins
	meta_data["kills"] += PlayerParameters.kills
	meta_data["souls"] += PlayerParameters.souls
	var time_manager = get_tree().get_first_node_in_group("arena_time_manager") 
	if time_manager && meta_data["best_time"] < time_manager.get_time_elapsed():
		meta_data["best_time"] = time_manager.get_time_elapsed();
	save_file()


func on_permanent_upgrade_buy(upgrade: MetaUpgrade):
	add_upgrade(upgrade)
	
