class_name SoulsCollectingComponent extends Node3D

func _ready():
	GameEvents.souls_collect.connect(on_souls_collect)

func on_souls_collect(position: Vector3, value: Vector3):
	# run souls movements to player(this component) run magnet method (if in area of collection)
	# when souls near player - emit GameEvents.souls_collect
	# remove souls from map
	# add souls values to player wallet
	print("got signal to collect")
	pass


