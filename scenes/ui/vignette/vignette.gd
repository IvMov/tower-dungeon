extends CanvasLayer

@onready var color_rect = $ColorRect

@export var vignette_opacity: float
@export var vignette_intensity: float


var base_opacity = 0.2
func _ready():
	GameEvents.damage_player.connect(on_damage_player)
	GameEvents.run_player.connect(on_run_player)
	GameEvents.aiming_player.connect(on_aiming_player)
	

func on_damage_player(value: float):

	var tween = create_tween().set_parallel(true)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", min(1, base_opacity + (base_opacity*value)/2), 0.3)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.98, 0.11, 0.11, 0.5), 0.3)
	tween.chain()
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.24, 0.11, 0.19, 0.5), 0.2)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", base_opacity, 0.2)
	
func on_run_player(value: float):
	var tween = create_tween().set_parallel(true)
	if value > PlayerParameters.BASE_SPEED:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.7, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.11, 0.98, 0.11, 0.2), 0.5)
	else:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.24, 0.11, 0.19, 1), 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", base_opacity, 0.5)

func on_aiming_player(aiming: bool):
	var tween = create_tween().set_parallel(true)
	if aiming:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.05, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", 0.05, 0.5)
	else:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.3, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", base_opacity, 0.5)
