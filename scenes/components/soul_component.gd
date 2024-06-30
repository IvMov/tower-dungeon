class_name SoulComponent extends Node3D

# Abstract souls for all, but -> Money of player ->
# all upgrades, heals, openings will be boutgh by it.  
# RGB pattern, contain one Green soul (players own.)
@export var souls: Vector3

func _ready():
	souls = Vector3(randf()*8, randf()*5, 0)

# returns Vector3 if Vector contains - vaues - it shows tha operation is unsuccessfull
# and negative values not enough, else -  operation successfull
func minus(value: Vector3) -> Vector3:
	var result: Vector3 = souls - value;
	if result.x >= 0 && result.y >= 0 || result.z >= 0:
		souls = result
	
	return result

# can apply negative numbers (for example fake souls - which consume some amount of souls)
func plus(value: Vector3) -> Vector3:
	souls += value
	
	return souls
