extends Node3D 

@onready var camera_3d = $SpringArm3D/Camera3D
@onready var spring_arm_3d = $SpringArm3D


const SCROLL_POWER: float = 0.15
const MAX_ZOOM_OUT: float = 10.0
const MAX_ZOOM_IN: float = 1
var in_aiming_mode: bool = false
var current_arm_length: float

var shake_amount = 0.0
var shake_decay: int = 4
var shake_forward: bool = true
var shake_offset: Vector3
func _ready():
	pass

func _physics_process(delta):
	if shake_decay > 0:
		if shake_forward:
			# Apply a small random offset to the camera's position
			shake_offset = Vector3(
				(randf() - 0.5) * shake_amount,
				(randf() - 0.5) * shake_amount,
				(randf() - 0.5) * shake_amount
			)
			global_transform.origin += shake_offset
		else:
			global_transform.origin -= shake_offset
		shake_forward = !shake_forward
		shake_decay = max(shake_decay-1, 0)
		if shake_decay == 0:
			shake_amount = 0
			shake_forward = true

func start_shake(amount:float, decay: int):
	#if shake_decay > 0:
		#return
	shake_amount = amount
	shake_decay = decay



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

