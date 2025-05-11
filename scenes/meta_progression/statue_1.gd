class_name Statue1 extends Statue

const ID: int = 1

func _ready() -> void:
	statue = $Statue
	done_particles = $DoneParticles
	add_crystal_particles = $AddCrystalParticles
	add_stone_particles = $AddStoneParticles
	static_body_3d = $Node3D/StaticBody3D
	animation_player = $AnimationPlayer
	common_ready(ID)

func do_action() -> bool: 
	if !add_stones(ID):
		return add_crystals(ID)
	else:
		return true

func _on_static_body_3d_mouse_entered() -> void:
	super._on_static_body_3d_mouse_entered()
	set_text_on_hover()
