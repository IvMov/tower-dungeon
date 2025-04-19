extends Node

#parent locations
@onready var PROJECTILES: Node = get_tree().get_first_node_in_group("projectiles")
@onready var ENEMIES: Node = get_tree().get_first_node_in_group("projectiles")


#infrastructure
const ITEM_VIEW_SCENE: PackedScene = preload("res://scenes/ui/item_view.tscn")
const ITEM_VIEW_HOLDER: PackedScene = preload("res://scenes/ui/item_view_holder.tscn")
const FIRE_PROJECTILE: PackedScene = preload("res://scenes/projectiles/fire_projectile.tscn")
const TRAIDER_ITEM: PackedScene = preload("res://scenes/screens/traider_item.tscn")
const TEXT: PackedScene = preload("res://scenes/ui/parts/text.tscn")

#weapons
const ITEM_STONE: Item = preload("res://resources/items/consumables/stone.tres")
const ITEM_CRYSTAL: Item = preload("res://resources/items/consumables/crystal.tres")
const ITEM_SNOWBALL_TABLET: Item = preload("res://resources/items/snowball_tablet.tres")
const FIREBALL_TABLET = preload("res://resources/items/fireball_tablet.tres")
const ACID_METEOR_TABLET = preload("res://resources/items/acid_meteor_tablet.tres")

#consumables 
const HEAL_TABLET = preload("res://resources/items/consumables/heal_tablet.tres")
const MANA_TABLET = preload("res://resources/items/consumables/mana_tablet.tres")
const STAMINA_TABLET = preload("res://resources/items/consumables/stamina_tablet.tres")

#map_generator
const CORE_TILE_SIZE: float = 8.0
const TUNEL_PADDING: float = 1.0
const WALL_HALF: float = 0.5
