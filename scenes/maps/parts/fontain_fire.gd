class_name FontainFire extends Hoverable

@onready var add_crystal_particles: GPUParticles3D = $AddCrystalParticles
@onready var timer: Timer = $Timer
@onready var mesh_wrap: Node3D = $MeshWrap
@onready var mesh_instance_3d: MeshInstance3D = $MeshWrap/MeshInstance3D
@onready var mesh_instance_3d_4: MeshInstance3D = $MeshWrap/MeshInstance3D4
@onready var mesh_instance_3d_5: MeshInstance3D = $MeshWrap/MeshInstance3D5
@onready var static_body_3d: StaticBody3D = $MeshWrap/StaticBody3D


const MAX_CRYSTALS: int = 10
const CRYSTAL_ID: int = 7

var min: float = 0.2
var max: float = 0.8
var animation_time: float = 0.8
var crystals: int 
var crystal_position: Vector3
var wall_enemy: WallEnemy
var first_interaction: bool = true

func do_action() -> bool: 
	if first_interaction:
		wall_enemy.tree_exiting.connect(on_tree_exiting)
		first_interaction = false
	var success: bool = false
	var item_bulk: ItemBulk = PlayerParameters.find_item(crystal_position)
	if crystal_position && item_bulk && item_bulk.item.id == CRYSTAL_ID:
		GameEvents.emit_item_remove(crystal_position, 1)
		success = true
		crystals+=1
	else:
		crystal_position = PlayerParameters.find_item_position_by_id(CRYSTAL_ID)
		if crystal_position != Vector3.ONE * -1:
			GameEvents.emit_item_remove(crystal_position, 1)
			success = true
			crystals+=1
	if crystal_position.x == 3:
		GameEvents.emit_item_update_hand_view(crystal_position.z)
	if success:
		add_crystal_particles.emitting = true
		flying_text.set_text("Press E to put the items. \n Crystals %d / %d" % [crystals, MAX_CRYSTALS])
	else:
		pass
		flying_text.set_text("Press E to put the items. \n Crystals %d / %d \n No crystals in inventory!" % [crystals, MAX_CRYSTALS])
	if crystals == MAX_CRYSTALS:
		mesh_wrap.scale = Vector3.ONE * 3
		mesh_instance_3d_4.get_active_material(0)
		mesh_instance_3d_4.get_active_material(0).albedo_color = Color(0.5, 2, 2)
		static_body_3d.set_collision_layer_value(6, false)
		shoot_the_wall()
	return true


func shoot_the_wall() -> void:
	timer.start()
	

func _on_static_body_3d_mouse_entered() -> void:
	super._on_static_body_3d_mouse_entered()
	flying_text.set_text("Press E to put the items. \n Crystals %d / %d" % [crystals, MAX_CRYSTALS])


func _on_timer_timeout() -> void:
	if wall_enemy:
		var projectile: FireProjectile = Constants.FIRE_PROJECTILE.instantiate()
		Constants.PROJECTILES.add_child(projectile)
		projectile.global_position = global_position
		projectile.global_position.y += 0.3
		var target_pos: Vector3 = wall_enemy.global_position
		target_pos.y += 1
		projectile.direction = (target_pos - global_position).normalized()
		projectile.speed = 5
	else:
		timer.stop()

func on_tree_exiting() -> void:
	wall_enemy = null
	timer.stop()
