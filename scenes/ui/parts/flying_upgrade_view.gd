class_name FlyingUpgradeView extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var rich_text_label: RichTextLabel = $Sprite3D/SubViewport/MarginContainer/RichTextLabel
@onready var label: Label = $Sprite3D/SubViewport/MarginContainer/Label


func set_text(text: String) -> void:
	label.text = text

func set_rich_text(text: String) -> void:
	rich_text_label.text = text
