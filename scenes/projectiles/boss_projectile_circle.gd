extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D

@onready var decal: Decal = $Decal
@onready var damage_decal: Decal = $DamageDecal
var max_radius: float = randf_range(1,7)
func run() -> void:
	decal.scale = Vector3.ONE * 0.1
	decal.modulate = Color(1, 0, 0)
	var tween: Tween = create_tween().parallel()
	tween.tween_property(decal, "scale", Vector3.ONE * max_radius, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(decal, "modulate", Color(2, 0, 0), 0.5).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_property(decal, "modulate", Color(5, 0, 0), 1).set_ease(Tween.EASE_IN)
	tween.tween_property(decal, "scale", Vector3.ONE * 0.1, 0.3)
	tween.tween_property(omni_light_3d, "visible", true, 0.01)
	tween.tween_property(damage_decal, "visible", true, 0.01)
	tween.tween_property(damage_decal, "scale", Vector3.ONE * max_radius, 0.2) 
	tween.tween_property(damage_decal, "scale", Vector3.ONE * 0.1, 0.1) 
	tween.tween_callback(damage_player)
	tween.tween_callback(queue_free)

func damage_player() -> void:
	var dist: float = (PlayerParameters.get_position() - global_position).length()
	dist = dist if dist > 0 else dist * -1
	if dist < max_radius:
		GameEvents.emit_damage_player(100 * (1 - max_radius/10))
