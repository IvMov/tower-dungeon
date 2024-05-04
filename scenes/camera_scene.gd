extends Node3D

@onready var camera_3d = $Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / 500	
		rotation.x -= event.relative.y / 500
	elif event is InputEventMouseButton:
		if event.button_index == 4:
			var direction = camera_3d.global_position - global_position
			camera_3d.global_position -= Vector3.ONE/10 * direction
		elif event.button_index == 5:
			var direction = camera_3d.global_position - global_position
			camera_3d.global_position += Vector3.ONE/10 * direction
