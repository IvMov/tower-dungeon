extends Node

const ITEM_VIEW_SCENE: PackedScene = preload("res://scenes/ui/item_view.tscn")
const ITEM_VIEW_HOLDER: PackedScene = preload("res://scenes/ui/item_view_holder.tscn")
const FIRE_PROJECTILE: PackedScene = preload("res://scenes/projectiles/fire_projectile.tscn")
const TRAIDER_ITEM: PackedScene = preload("res://scenes/screens/traider_item.tscn")
const TEXT: PackedScene = preload("res://scenes/ui/parts/text.tscn")

const ITEM_STONE: Item = preload("res://resources/items/consumables/stone.tres")
const ITEM_CRYSTAL: Item = preload("res://resources/items/consumables/crystal.tres")
const ITEM_SNOWBALL_TABLET: Item = preload("res://resources/items/snowball_tablet.tres")

#consumables
const HEAL_TABLET = preload("res://resources/items/consumables/heal_tablet.tres")


const CORE_TILE_SIZE: float = 8.0
const TUNEL_PADDING: float = 1.0
const WALL_HALF: float = 0.5
