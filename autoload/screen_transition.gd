extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready():
	$Sprite2D.visible = false
	

func play_transition():
	animation_player.play("default")
	
func play_transition_back():
	animation_player.play_backwards("default")
