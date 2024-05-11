extends Node2D

@onready var muzzle_sprite = $MuzzleSprite

func _ready():
	GameEvents.screen_resized.connect(on_screen_resized)
	relocate_muzzle()


func on_screen_resized():
	relocate_muzzle()


func relocate_muzzle():
	var viewport_size: Vector2 =  get_viewport_rect().size
	muzzle_sprite.global_position.x = viewport_size.x/2 
	muzzle_sprite.global_position.y = viewport_size.y/4
