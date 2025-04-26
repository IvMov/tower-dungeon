extends CanvasLayer

const MAIN: PackedScene = preload("res://scenes/main.tscn")

const CONTINUE_GAME_SCREEN: PackedScene = preload("res://scenes/menu/continue_game_screen.tscn")
const CONTROL_SCREEN: PackedScene = preload("res://scenes/menu/control_screen.tscn")
const MENU_SCREEN: PackedScene = preload("res://scenes/menu/menu_screen.tscn")
const NEW_GAME_SCREEN: PackedScene = preload("res://scenes/menu/new_game_screen.tscn")
const PLAY_SCREEN: PackedScene = preload("res://scenes/menu/play_screen.tscn")
const PROPERTIES_SCREEN: PackedScene = preload("res://scenes/menu/properties_screen.tscn")
const START_GAME_SCREEN: PackedScene = preload("res://scenes/menu/start_game_screen.tscn")

@onready var animation_player = $AnimationPlayer

func _ready():
	$Sprite2D.visible = false
	

func play_transition():
	animation_player.play("default")
	await animation_player.animation_finished
	
func play_transition_back():
	animation_player.play_backwards("default")
