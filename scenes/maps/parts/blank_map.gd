class_name  BlankMap extends Node3D

@onready var navigation_region_3d = $NavigationRegion3D

func add_tile(tile: Node3D) -> void:
	if !navigation_region_3d:
		navigation_region_3d = $NavigationRegion3D
	navigation_region_3d.add_child(tile)


func bake_navigation() -> void:
	navigation_region_3d.bake_navigation_mesh()
