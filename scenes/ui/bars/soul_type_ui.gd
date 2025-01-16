class_name SoulTypeUi extends MarginContainer

@onready var sprite: TextureRect = $Sprite
@onready var quantity_label: Label = $QuantityLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var image: CompressedTexture2D;
@export var quantity: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = image
	quantity_label.text = str(quantity)
