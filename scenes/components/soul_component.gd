class_name SoulComponent extends Node3D

# Abstract souls for all, but -> Money of player ->
# all upgrades, heals, openings will be boutgh by it.  
# RGB pattern, contain one Green soul (players own.)
@export var souls: Vector3
var is_player: bool = false

func _ready():
	souls = Vector3(randi_range(1 * EnemyParameters.drop_modifier,8 * EnemyParameters.drop_modifier), randi_range(1, 5 * EnemyParameters.drop_modifier), randi_range(0, 2 * EnemyParameters.drop_modifier))

# returns Vector3 if Vector contains - vaues - it shows tha operation is unsuccessfull
# and negative values not enough, else -  operation successfull
func minus(value: Vector3) -> Vector3:
	var result: Vector3 = souls - value;
	if result.x >= 0 && result.y >= 0 || result.z >= 0:
		souls = result
	else: 
		souls = Vector3(max(0, result.x),max(0, result.y), max(0, result.z))
	if is_player:
		GameEvents.emit_souls_update_view(souls)
	return result

# can apply negative numbers (for example fake souls - which consume some amount of souls)
func plus(value: Vector3) -> Vector3:
	souls += value
	if is_player:
		GameEvents.emit_souls_update_view(souls)
	return souls
