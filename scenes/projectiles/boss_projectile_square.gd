extends Node3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D

@onready var decal: Decal = $Decal
@onready var damage_decal: Decal = $DamageDecal
var max_radius: float = randf_range(1,7)
var damaged: bool

func run() -> void:
	rotate_y(randf_range(-PI, PI))
	decal.scale = Vector3.ONE * 0.1
	decal.modulate = Color(1, 0, 0)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(decal, "scale", Vector3.ONE * max_radius, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(decal, "modulate", Color(2, 0, 0), 0.5).set_ease(Tween.EASE_OUT)
	tween.chain()
	tween.tween_property(decal, "modulate", Color(5, 0, 0), 1).set_ease(Tween.EASE_IN)
	tween.chain()
	tween.tween_property(decal, "scale", Vector3.ONE * 0.1, 0.2)
	tween.chain()
	tween.tween_property(damage_decal, "visible", true, 0.01)
	tween.chain()
	tween.tween_property(damage_decal, "scale", Vector3.ONE * max_radius, 0.2) 
	tween.tween_property(collision_shape_3d, "shape:size", Vector3(max_radius*1.8, 2, max_radius*1.8),0.2)
	tween.chain()
	tween.tween_property(omni_light_3d, "visible", true, 0.01)
	tween.chain()
	tween.tween_property(collision_shape_3d, "shape:size", Vector3(0, 0, 0),0.1)
	tween.tween_property(damage_decal, "scale", Vector3.ONE * 0.1, 0.1) 
	tween.chain()
	tween.tween_callback(queue_free)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !damaged && body is Player:
		damaged = true
		GameEvents.emit_damage_player(100 * (1 - max_radius/10)) 
