extends Node3D 

@onready var camera_3d = $SpringArm3D/Camera3D
@onready var spring_arm_3d = $SpringArm3D


const SCROLL_POWER: float = 0.15
const MAX_ZOOM_OUT: float = 10.0
const MAX_ZOOM_IN: float = 1
var in_aiming_mode: bool = false
var current_arm_length: float

func _unhandled_input(event):
	if event is InputEventMouseButton && !in_aiming_mode:
		var is_zoom_forward: bool = event.button_index == 4
		var is_zoom_back: bool = event.button_index == 5
		
		if is_zoom_forward && spring_arm_3d.spring_length -  SCROLL_POWER > MAX_ZOOM_IN:
			zoom_forward()
		elif is_zoom_back && spring_arm_3d.spring_length +  SCROLL_POWER < MAX_ZOOM_OUT:
			zoom_back()

func aiming_mode_in() -> void:
	current_arm_length = spring_arm_3d.spring_length
	spring_arm_3d.spring_length = MAX_ZOOM_IN
	in_aiming_mode = true
	
func aiming_mode_out() -> void:
	spring_arm_3d.spring_length = current_arm_length
	in_aiming_mode = false


func zoom_forward() -> void:
		spring_arm_3d.spring_length -= SCROLL_POWER

		

func zoom_back() -> void:
		spring_arm_3d.spring_length += SCROLL_POWER
		
#func get_crosschair_position() -> Vector3:
	#var from = get_parent().gun.global_position
	#var to = (get_parent().gun.gun_body.global_position * 100)
	### Виявлення колізій для отримання точки кінця променя
	#var space_state = get_world_3d().direct_space_state
	#var param = PhysicsRayQueryParameters3D.create(from, to)
	#param.exclude = [self]
	#var result = space_state.intersect_ray(param)
	#if result:
		#return result.position - direction*.3
	#else:
		#return Vector3.ZERO

