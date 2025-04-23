class_name Soul extends Node3D

@onready var tier_1_soul_particle = $Tier1SoulParticle
@onready var tier_2_soul_particle = $Tier2SoulParticle
@onready var tier_3_soul_particle = $Tier3SoulParticle
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

var souls_count: Vector3

func emit(souls: Vector3):
	souls_count = souls
	tier_1_soul_particle.amount = max(souls.x, 1)
	tier_2_soul_particle.amount = max(souls.y, 1)
	tier_3_soul_particle.amount = max(souls.z, 1)

	if souls.x > 0:
		tier_1_soul_particle.emitting = true
		tier_1_soul_particle.speed_scale = 0.5
	if souls.y > 0:
		tier_2_soul_particle.emitting = true
		tier_2_soul_particle.speed_scale = 0.5
	if souls.z > 0:
		tier_3_soul_particle.emitting = true
		tier_3_soul_particle.speed_scale = 0.5
	

func collect() -> void:
	if tier_1_soul_particle.emitting:
		tier_1_soul_particle.speed_scale = 2.5
	if tier_2_soul_particle.emitting:
		tier_2_soul_particle.speed_scale = 2.5
	if tier_3_soul_particle.emitting:
		tier_3_soul_particle.speed_scale = 2.5
	var tween = create_tween().set_parallel(true)
	tween.tween_property(omni_light_3d, "omni_range", 3, 0.5)
	tween.tween_property(omni_light_3d, "light_energy", 7, 0.5)
	tween.chain()
	tween.tween_property(omni_light_3d, "omni_range", 0, 0.5)
	tween.tween_property(omni_light_3d, "light_energy", 0, 0.5)
	tween.chain()
	tween.tween_callback(emit_collected)
	tween.chain()
	await tween.tween_callback(queue_free)


func emit_collected() -> void:
	GameEvents.emit_souls_collect(global_position, souls_count)

func _on_area_3d_area_entered(_area: Area3D) -> void:
	await collect()
	
