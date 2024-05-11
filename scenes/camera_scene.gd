extends Node3D 

@onready var camera_3d = $SpringArm3D/Camera3D
@onready var spring_arm_3d = $SpringArm3D


const SCROLL_POWER: float = 0.15
const MAX_ZOOM_OUT: float = 10.0
const MAX_ZOOM_IN: float = 1


func _unhandled_input(event):
	if event is InputEventMouseButton:
		var is_zoom_forward: bool = event.button_index == 4
		var is_zoom_back: bool = event.button_index == 5
		
		if is_zoom_forward && spring_arm_3d.spring_length -  SCROLL_POWER > MAX_ZOOM_IN:
			zoom_forward()
		elif is_zoom_back && spring_arm_3d.spring_length +  SCROLL_POWER < MAX_ZOOM_OUT:
			zoom_back()


func zoom_forward() -> void:
		spring_arm_3d.spring_length -= SCROLL_POWER

		

func zoom_back() -> void:
		spring_arm_3d.spring_length += SCROLL_POWER
		


