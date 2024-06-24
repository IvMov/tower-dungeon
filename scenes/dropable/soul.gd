class_name Soul extends Node3D

@onready var tier_1_soul_particle = $Tier1SoulParticle
@onready var tier_2_soul_particle = $Tier2SoulParticle
@onready var tier_3_soul_particle = $Tier3SoulParticle

var souls_count: Vector3

func emit(souls: Vector3):
	souls_count = souls
	tier_1_soul_particle.amount = max(souls.x, 1)
	tier_2_soul_particle.amount = max(souls.y, 1)
	tier_3_soul_particle.amount = max(souls.z, 1)
	
	if souls.x > 0:
		tier_1_soul_particle.emitting = true
	if souls.y > 0:
		tier_2_soul_particle.emitting = true
	if souls.z > 0:
		tier_3_soul_particle.emitting = true

func collect():
	#maybe animate with tween - to move somewhere
	tier_1_soul_particle.emitting = false
	tier_2_soul_particle.emitting = false
	tier_3_soul_particle.emitting = false
	print("collected")
	#animate collecting
	queue_free()
	


func _on_area_3d_area_entered(area):
	GameEvents.emit_souls_collect(global_position, souls_count)
	collect()
