extends CharacterBody3D

@onready var animation_player = $AnimationPlayer
@onready var camera_scene = $CameraScene
@onready var character_human = $"character-human"

const SPEED: float = 5.0
#540 - enogh to jump on 2m wall :) 
const JUMP_VELOCITY: float = 540.0
const SENSETIVITY: float = 0.003
const MAX_ROTATION_TOP: float = 0.6
const MAX_ROTATION_BOTTOM: float = -0.6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	

func _physics_process(delta):

	if !is_on_floor():
		animation_player.play("fall")
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY * delta
		print(velocity.y)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character_human.rotation.y = camera_scene.rotation.y + PI
	if is_on_floor():
		if direction:
			animation_player.play("walk")
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSETIVITY)
		var new_angle = camera_scene.get_rotation().x - event.relative.y * SENSETIVITY;
		if new_angle < MAX_ROTATION_TOP && new_angle > MAX_ROTATION_BOTTOM:
			camera_scene.rotation.x = new_angle
		
