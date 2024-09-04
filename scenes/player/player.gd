class_name Player extends CharacterBody3D

@export var first_skill: Skill

@onready var animation_player = $AnimationPlayer
@onready var camera_scene: CameraScene = $CameraScene
@onready var player_model = $"character-human"
@onready var agr_area = $AgrArea
@onready var body_mesh = $"character-human/Skeleton3D/body-mesh"
@onready var head_mesh = $"character-human/Skeleton3D/head-mesh"
@onready var skill_box: Node = $SkillBox
@onready var soul_component: SoulComponent = $SoulComponent

@onready var player_skill_controller: PlayerSkillController = $PlayerSkillController

@onready var health_component: HealthComponent = $StatsBox/HealthComponent
@onready var mana_component: ManaComponent = $StatsBox/ManaComponent
@onready var stamina_component: StaminaComponent = $StatsBox/StaminaComponent


var player_name: String
var move_direction: Vector3 = Vector3.ZERO
var actions_animations: Array[String] = [
	"attack-melee-right", 
	"attack-melee-left", 
	"take-damage-1", 
	"take-damage-2", 
	"die",
	"holding-both-shoot",
	"sprint"]
var is_dying: bool = false
var last_fontain_coordinates: Vector3

func _ready():
	player_name = "test" # TODO: create simple creation screen with nickname
	GameEvents.emit_change_game_stage(1)
	agr_area.body_entered.connect(on_body_entered)
	agr_area.body_exited.connect(on_body_exited)
	agr_area.area_entered.connect(on_area_entered)
	agr_area.area_exited.connect(on_area_exited)
	GameEvents.damage_player.connect(on_damage_player)
	preload_first_skill()
	last_fontain_coordinates = global_position


func _physics_process(delta):
	if is_dying:
		return
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	velocity.x = -move_direction.x * PlayerParameters.current_speed * delta
	velocity.z = -move_direction.z * PlayerParameters.current_speed * delta

	if !actions_animations.has(animation_player.get_current_animation()):

		if is_on_floor():
			animation_player.play("walk" if move_direction else "idle")
		else:
			animation_player.play("fall")
			velocity.y -= GameConfig.gravity * delta
	move_and_slide()


func _unhandled_input(event):
	# right click
	handle_aiming(event)
	# shift
	handle_run(event)
	# space
	handle_jump(event)
		# space
	handle_push_enemy(event)
	# movement
	handle_mouse_rotations(event)
	# left click
	handle_skill_use(event)


func preload_first_skill() -> void:
	GameEvents.emit_add_skill(first_skill)

func handle_mouse_rotations(event: InputEvent) -> void:
	move_player(event)
	
func move_player(event: InputEvent) -> void:
	if event is InputEventMouseMotion && event.relative.y + event.relative.x != 0:
		rotate_y(-event.relative.x * GameConfig.get_mouse_sensetivity())
		var new_angle = camera_scene.get_rotation().x - event.relative.y * GameConfig.get_mouse_sensetivity();
		if new_angle < GameConfig.MAX_MOUSE_ROTATION_X && new_angle > -GameConfig.MAX_MOUSE_ROTATION_X:
			camera_scene.rotation.x = new_angle

func handle_push_enemy(event: InputEvent) -> void:
	if event.is_action_pressed("push_enemy"):
		animation_player.play("holding-both-shoot")
		player_skill_controller.push_skill.use_skill()

func handle_run(event: InputEvent) -> void:
	player_skill_controller.run_skill.use_skill_with_event(event)

func handle_jump(event: InputEvent) -> void:
	player_skill_controller.jump_skill.use_skill_with_event(event)

func handle_aiming(event: InputEvent) -> void:
	player_skill_controller.aim_skill.use_skill_with_event(event)

func handle_skill_use(event: InputEvent) -> void:
	if event.is_action_pressed("skill_use"):
		player_skill_controller.cast_active_skill()
	elif event.is_action_released("skill_use"):
		player_skill_controller.use_active_skill()


func custom_death_actions():
	if PlayerParameters.lifes - 1 < 0:
		#show game end screen - menu to back to game menu, and restart game. 
		#god of death consume all souls and paid you with some gold which can be spent to buy some heaks and bombs
		return
	PlayerParameters.lifes -= 1;
	soul_component.minus(Vector3(soul_component.souls.x/2, soul_component.souls.y/2, soul_component.souls.z/2))
	is_dying = false
	global_position = last_fontain_coordinates

func get_damage(value: float) -> void:
	health_component.minus(value)
	camera_scene.start_shake(0.1, 8)

func on_body_entered(body: Node3D):
	if body is BasicEnemy:
		body.do_damage()


func on_body_exited(body: Node3D):
	if body is BasicEnemy:
		body.stop_damage()


func on_area_entered(area: Area3D):
	var area_owner: Node3D = area.get_parent()
	if area_owner && area_owner is BasicEnemy:
		area_owner.detect_target(self)


func on_area_exited(area: Area3D):
	var area_owner: Node3D = area.get_parent()
	if area_owner && area_owner is BasicEnemy:
		area_owner.lost_target()


func on_damage_player(damage: float):
	get_damage(damage)
