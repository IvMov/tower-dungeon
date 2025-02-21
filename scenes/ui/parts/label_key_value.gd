class_name LabelKeyValue extends MarginContainer

@export var key: String
@export var value: String


@onready var key_label: Label = $Key
@onready var value_label: Label = $Value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_label.text = key
	value_label.text = value

func set_value(value: String) -> void:
	value_label.text = value
