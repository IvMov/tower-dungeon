extends Node

const COIN: PackedScene = preload("res://scenes/dropable/coin.tscn")
const SOUL_PART: PackedScene = preload("res://scenes/dropable/soul_part.tscn")

#infrastructure
const ITEM_VIEW_SCENE: PackedScene = preload("res://scenes/ui/item_view.tscn")
const ITEM_VIEW_HOLDER: PackedScene = preload("res://scenes/ui/item_view_holder.tscn")
const FIRE_PROJECTILE: PackedScene = preload("res://scenes/projectiles/fire_projectile.tscn")
const TRAIDER_ITEM: PackedScene = preload("res://scenes/screens/traider_item.tscn")
const TEXT: PackedScene = preload("res://scenes/ui/parts/text.tscn")
const SOUND_BUTTON: PackedScene = preload("res://scenes/ui/sound_button.tscn")
const META_UPGRADE_VIEW = preload("res://scenes/meta_progression/meta_upgrade_view.tscn")
# items
const ITEM_SPARK_ID: int = 0
const ITEM_ZOOM_ID: int = 1
const ITEM_STONE_ID: int = 6
const ITEM_CRYSTAL_ID: int = 7
const ITEM_SNOWBALL_ID: int = 8
const ITEM_FIREBALL_ID: int = 9
const ITEM_ACID_METEOR_ID: int = 10
const ITEM_FIRE_BLADE_TRAP_ID: int = 11
const ITEM_HEAL_ID: int = 30
const ITEM_MANA_ID: int = 31
const ITEM_STAMINA_ID: int = 32
const ITEM_DAMAGE_ID: int = 33
const ITEM_SPEED_ID: int = 34

const HP_UP_1_UPGRADE_ID: int = 60
const HP_UP_2_UPGRADE_ID: int = 61
const HP_REGEN_1_UPGRADE_ID: int = 62
const HP_REGEN_2_UPGRADE_ID: int = 63

const DASH_CD_1_UPGRADE_ID: int = 104
const DASH_CD_2_UPGRADE_ID: int = 1004

@export var items_pool: Dictionary[int, Item]

#map_generator
const CORE_TILE_SIZE: float = 8.0
const TUNEL_PADDING: float = 1.0
const WALL_HALF: float = 0.5

const GREEN_SOUL_COLOR: Color = Color(0, 10, 0, 0.3)
const BLUE_SOUL_COLOR: Color = Color(0, 0, 10, 0.3)
const RED_SOUL_COLOR: Color = Color(10, 0, 0, 0.3)

#parent locations for main game
var PROJECTILES: Node
var ENEMIES: Node
var SOULS: Node

func get_item_by_id(id: int) -> Item:
	return items_pool.get(id)
