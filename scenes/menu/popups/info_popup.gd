extends PopUp

@onready var panel: PanelContainer = $MarginContainer/Panel
@onready var label: Label = $MarginContainer/Panel/MarginContainer/Label

func set_text(text: String) -> void:
	label.text = text

func _ready() -> void:
	panel.modulate = Color(1, 1, 1, 0)
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN)
	
	tween.tween_property(panel, "modulate", Color(1, 1, 0, 1), 0.7)
	tween.tween_property(panel, "modulate", Color(1, 1, 1, 0), 5)
	tween.tween_callback(queue_free)
