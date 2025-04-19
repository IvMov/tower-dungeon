class_name Skill extends Resource

@export var id: int

@export var title: String
@export var description: String
@export var controller: PackedScene

@export var is_maintainable: bool
@export var is_offensive: bool
@export var is_consumable: bool
@export var is_upgradable: bool

@export var parameter: String #if deffensive
@export var base_value: float
@export var base_push_value: float
@export var base_speed: float #if projectile
@export var base_distance: float #if offenisive

@export var energy_type: String 
@export var base_energy_cost: float
@export var base_cast_time: float
@export var base_duration: float
@export var base_cooldown: float

@export var base_fire_dmg_value: float
@export var base_acid_dmg_value: float
@export var base_fire_dmg_per_lvl: float
@export var base_acid_dmg_per_lvl: float

#if is_upgradable, then when skill uses - it should be upgraded with exp
@export var value_per_lvl: float
@export var push_value_per_lvl: float
@export var speed_per_lvl: float
@export var distance_per_lvl: float
@export var energy_per_lvl: float
@export var cast_time_per_lvl: float
@export var duration_per_lvl: float
@export var cooldown_per_lvl: float

@export var max_lvl: int
@export var exp_multiplier: float 

func calc_coolldown() -> float:
	return base_cooldown
