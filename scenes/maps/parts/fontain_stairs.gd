class_name FontainStairs extends Hoverable

@onready var timer: Timer = $Timer
@onready var stairs_mesh: MeshInstance3D = $StairsMesh
@onready var add_stone_particles: GPUParticles3D = $AddStoneParticles
@onready var static_body_3d: StaticBody3D = $StairsMesh/StaticBody3D
@onready var invisible_pillar: MeshInstance3D = $StairsMesh/InvisiblePillar

const MAX_STONES: int = 10
const STONE_ID: int = 6

var tween: Tween
var min: float = 0.2
var max: float = 0.8
var animation_time: float = 0.8
var stones: int 
var stone_position: Vector3

func do_action() -> bool: 
	var success: bool = false
	var item_bulk: ItemBulk = PlayerParameters.find_item(stone_position)
	if stone_position && item_bulk && item_bulk.item.id == STONE_ID:
		GameEvents.emit_item_remove(stone_position, 1)
		success = true
		stones+=1
	else:
		stone_position = PlayerParameters.find_item_position_by_id(STONE_ID)
		if stone_position != Vector3.ONE * -1:
			GameEvents.emit_item_remove(stone_position, 1)
			success = true
			stones+=1
	if stone_position.x == 3:
		GameEvents.emit_item_update_hand_view(stone_position.z)
	if success:
		add_stone_particles.emitting = true
		flying_text.set_text("Press E to put the items. \n Stones %d / %d" % [stones, MAX_STONES])
	else:
		pass
		flying_text.set_text("Press E to put the items. \n Stones %d / %d \n No stones in inventory!" % [stones, MAX_STONES])
	if stones == MAX_STONES:
		timer.stop()
		if tween:
			tween.kill()
		stairs_mesh.transparency = 0
		static_body_3d.set_collision_layer_value(1, true)
		static_body_3d.set_collision_layer_value(6, false)
		invisible_pillar.queue_free()
	return true

 
func _on_timer_timeout() -> void:
	tween = create_tween()
	tween.tween_property(stairs_mesh, "transparency", min, animation_time).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(stairs_mesh, "transparency", max, animation_time).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	timer.start()

func _on_static_body_3d_mouse_entered() -> void:
	super._on_static_body_3d_mouse_entered()
	flying_text.set_text("Press E to put the items. \n Stones %d / %d" % [stones, MAX_STONES])
