class_name BasicEnemy
extends CharacterBody3D

@onready var animation_player = $"character-orc2/AnimationPlayer"
@onready var agr_area = $AgrArea

var speed: float = 90.0
var player: Player
var direction: Vector3
var rotation_speed: float = 3

func _physics_process(delta):
	if is_on_floor():
		animation_player.play("walk" if velocity.length() > 0.1 else "idle")
	else:
		animation_player.play("fall")
		velocity.y -= GameConfig.gravity * delta
		move_and_slide()
	
	if player:
		direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
		var target_rotation = (player.global_transform.origin - global_transform.origin).normalized()
		var current_rotation = global_transform.basis.z.normalized()
		var new_rotation = current_rotation.lerp(target_rotation, rotation_speed * delta)
		look_at(global_transform.origin + new_rotation, Vector3.UP)
		#look_at(player.global_transform.origin, Vector3.UP)
		self.rotate_object_local(Vector3.UP, PI)
		move_and_slide()

func detect_target(target_player: Player):
	player = target_player
	
	#rotate_y(direction.y) rotate enemy

func lost_target():
	player = null
	direction = Vector3.ZERO
	velocity = Vector3.ZERO
