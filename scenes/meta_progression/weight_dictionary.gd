class_name WeightDictionary

var table: Dictionary[int, Variant]
var array: Array[Dictionary]

func add(new: Dictionary[int, Variant]) -> void:
	array.append(new)

func update(new: Dictionary[int, Variant]) -> void: 
	
	#if array.has()
	pass
