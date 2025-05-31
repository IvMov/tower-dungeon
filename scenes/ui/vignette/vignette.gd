extends CanvasLayer

@onready var color_rect = $ColorRect

@export var vignette_opacity: float
@export var vignette_intensity: float
@onready var timer: Timer = $Timer

var main_color: Color = Color(0.147, 0.213, 0.209, 1)

var base_opacity : float = 0.1
var base_intencity : float = 0.5

#TODO: SET TIMER TO 15-18
func _ready():
	GameEvents.damage_player.connect(on_damage_player)
	GameEvents.run_player.connect(on_run_player)
	GameEvents.aiming_player.connect(on_aiming_player)
	GameEvents.end_game.connect(on_end_game)
	

func on_damage_player(value: float):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", min(1, base_opacity + (base_opacity*value)/2), 0.3)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.98, 0.11, 0.11, 0.5), 0.3)
	tween.chain()
	tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", main_color, 0.2)
	tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", base_opacity, 0.2)
	
func on_run_player(value: float):
	if PlayerParameters.player.is_end:
		return
	var tween = create_tween().set_parallel(true)
	if value > PlayerParameters.BASE_SPEED:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.5, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", 5, 0.5)
	else:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", base_intencity, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", base_opacity, 0.5)

func on_aiming_player(aiming: bool):
	if PlayerParameters.player.is_end:
		return
	var tween = create_tween().set_parallel(true)
	if aiming:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 0.01, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", 0.01, 0.5)
	else:
		tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", base_opacity, 0.5)
		tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", base_intencity, 0.5)

func on_end_game() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	MetaProgression.save_game()
	#layer = 2
	#var tween = create_tween()
	#tween.tween_property(color_rect, "material:shader_parameter/vignette_rgb", Color(0.099, 0.345, 0.266), 0.01)
	#tween.tween_property(color_rect, "material:shader_parameter/vignette_opacity", 1, 2)
	#tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", 20, 5).set_ease(Tween.EASE_IN)
	#tween.tween_property(color_rect, "material:shader_parameter/vignette_intensity", 70, 1)
	#await tween.finished
	
	GameEvents.emit_change_game_stage(GameStage.Stage.END_GAME)
	
