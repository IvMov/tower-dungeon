extends Node3D

@onready var camera_3d = $Camera3D

const SCROLL_POWER: Vector3 = Vector3.ONE/10
const MAX_ZOOM_OUT: float = 10.0
const MAX_ZOOM_IN: float = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event is InputEventMouseButton:
		var direction_vector: Vector3 = camera_3d.global_position - global_position
		var direction_length: float = direction_vector.length();
		var is_zoom_forward: bool = event.button_index == 4
		var is_zoom_back: bool = event.button_index == 5
		
		if is_zoom_forward && direction_length -  SCROLL_POWER.length() > MAX_ZOOM_IN:
			zoom_forward(direction_vector)
		elif is_zoom_back && direction_length +  SCROLL_POWER.length() < MAX_ZOOM_OUT:
			zoom_back(direction_vector)


func zoom_forward(direction_vector: Vector3) -> void:
		camera_3d.global_position -= SCROLL_POWER * direction_vector
		

func zoom_back(direction_vector: Vector3) -> void:
		camera_3d.global_position += SCROLL_POWER * direction_vector
