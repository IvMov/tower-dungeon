class_name CameraScene extends Node3D 

@onready var camera_3d = $SpringArm3D/Camera3D
@onready var spring_arm_3d = $SpringArm3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D


const SCROLL_POWER: float = 0.15
const MAX_ZOOM_OUT: float = 10.0
const MAX_ZOOM_IN: float = 2
const MAX_ZOOM_AIM: float = 1

var in_aiming_mode: bool = false
var current_arm_length: float

var shake_amount = 0.0
var shake_decay: int = 4
var shake_forward: bool = true
var shake_offset: Vector3

var last_collider: Node3D

func _ready():
	pass

func _physics_process(_delta):
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

func start_shake(amount:float, decay: int) -> void:
	shake_amount = amount
	shake_decay = decay

func get_camera_position() -> Vector3:
	return camera_3d.global_position

func get_target_object() -> Node3D:
	var collider: Node3D = ray_cast_3d.get_collider()
	if collider:
		return collider
	return null

func _unhandled_input(event):
	if event is InputEventMouseButton && !in_aiming_mode && GameStage.is_stage(GameStage.Stage.GAME):
		var is_zoom_forward: bool = event.button_index == 4
		var is_zoom_back: bool = event.button_index == 5
		
		if is_zoom_forward && spring_arm_3d.spring_length -  SCROLL_POWER > MAX_ZOOM_IN:
			zoom_forward()
		elif is_zoom_back && spring_arm_3d.spring_length +  SCROLL_POWER < MAX_ZOOM_OUT:
			zoom_back()

func aiming_mode_in() -> void:
	current_arm_length = spring_arm_3d.spring_length
	spring_arm_3d.spring_length = MAX_ZOOM_AIM
	in_aiming_mode = true
	
func aiming_mode_out() -> void:
	spring_arm_3d.spring_length = current_arm_length
	in_aiming_mode = false


func zoom_forward() -> void:
		spring_arm_3d.spring_length -= SCROLL_POWER


func zoom_back() -> void:
		spring_arm_3d.spring_length += SCROLL_POWER

func calc_direction() -> Vector3:
	var cursor: Vector2 = get_viewport().get_mouse_position();
	var ray_origin: Vector3 = camera_3d.project_ray_origin(cursor)
	var ray_normal: Vector3 = camera_3d.project_ray_normal(cursor)
	var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_normal*100)
	var collision: Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
	var distance_to_target: int = collision.position.distance_to(ray_origin) if collision else 100
	if distance_to_target == 0:
		distance_to_target = 10
	var cursor_world_position = ray_origin + ray_normal * distance_to_target
	
	return (cursor_world_position - get_camera_position()).normalized();



func _on_timer_timeout() -> void:
	var collider: Node3D = ray_cast_3d.get_collider()
	if !is_instance_valid(last_collider):
		last_collider = null
	if !collider && last_collider:
		last_collider.mouse_exited.emit()
		last_collider = null
	if collider && (collider.get_collision_layer_value(6) || collider.get_collision_layer_value(5)):
		if last_collider && last_collider != collider:
			last_collider.mouse_exited.emit()
			last_collider = collider
			last_collider.mouse_entered.emit()
		elif !last_collider:
			last_collider = collider
			last_collider.mouse_entered.emit()
	
