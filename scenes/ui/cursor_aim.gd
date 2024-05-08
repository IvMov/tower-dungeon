extends Node2D

@onready var cursorSprite = $CursorSprite
var initialized: bool = false

func _ready():
	var camera = get_tree().get_first_node_in_group("Camera")
	if !camera:
		return

	var viewport_size = get_viewport().size
	var screen_center = viewport_size / 2

	var camera_projection = camera.camera_3d.project_ray_origin(screen_center)
	var camera_direction = camera.camera_3d.project_ray_normal(screen_center)

	var ray_end = camera_projection + camera_direction * 100.0  

	
	cursorSprite.global_transform.origin = ray_end
	initialized = true


func _process(delta):
	if !initialized:
		return
	var camera = get_tree().get_first_node_in_group("Camera")
	if !camera:
		return

	var viewport_size = get_viewport().size
	var screen_center = viewport_size / 2

	var camera_projection = camera.camera_3d.project_ray_origin(screen_center)
	var camera_direction = camera.camera_3d.project_ray_normal(screen_center)

	var ray_end = camera_projection + camera_direction * 100.0  

	
	cursorSprite.global_transform.origin = ray_end

	
