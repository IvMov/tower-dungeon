class_name Interactable extends Node3D

@onready var timer: Timer = $Timer
@onready var stairs_1: MeshInstance3D = $Stairs1
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var label: Label = $Sprite3D/SubViewport/MarginContainer/Label
@onready var static_body_3d: StaticBody3D = $Stairs1/StaticBody3D
@onready var mesh_instance_3d: MeshInstance3D = $Stairs1/InvisiblePillar
@onready var add_stone_particles: GPUParticles3D = $AddStoneParticles

const MAX_STONES: int = 10

var tween: Tween
var min: float = 0.2
var max: float = 0.8
var animation_time: float = 0.8
var hovered: bool = false
var stones: int 
var stone_position: Vector3

func add_stone() -> void: 
	var success: bool = false
	var item_bulk: ItemBulk = PlayerParameters.find_item(stone_position)
	if stone_position && item_bulk && item_bulk.item.id == 3:
		GameEvents.emit_item_remove(stone_position, 1)
		success = true
		stones+=1
	else:
		stone_position = PlayerParameters.find_item_position_by_id(3)
		if stone_position != Vector3.ONE * -1:
			GameEvents.emit_item_remove(stone_position, 1)
			success = true
			stones+=1
	if stone_position.x == 3:
		GameEvents.emit_item_update_hand_view(stone_position.z)
	if success:
		add_stone_particles.emitting = true
		label.text = "Press E to put the items. \n Stones %d / %d" % [stones, MAX_STONES]
	else:
		label.text = "Press E to put the items. \n Stones %d / %d \n No stones in inventory!" % [stones, MAX_STONES]
	if stones == MAX_STONES:
		timer.stop()
		stairs_1.transparency = 0
		GameEvents.emit_push_player_back()
		static_body_3d.set_collision_layer(1)
		mesh_instance_3d.queue_free()

func show_is_interactable() -> void:
	hovered = true
	sprite_3d.visible = true
	label.text = "Press E to put the items. \n Stones %d / %d" % [stones, MAX_STONES]
 
func _on_timer_timeout() -> void:
	tween = create_tween()
	tween.tween_property(stairs_1, "transparency", min, animation_time).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(stairs_1, "transparency", max, animation_time).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	timer.start()

func _on_static_body_3d_mouse_entered() -> void:
	show_is_interactable()


func _on_static_body_3d_mouse_exited() -> void:
	hovered = false
	sprite_3d.visible = false
