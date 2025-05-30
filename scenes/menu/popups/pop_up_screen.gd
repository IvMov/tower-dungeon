class_name PopUpScreen extends PopUp

@onready var label: Label = $MarginContainer/ColoredRect/MarginContainer/Label
@onready var sound_button: SoundButton = $MarginContainer/ColoredRect/MarginContainer2/SoundButton
@onready var sound_button_2: SoundButton = $MarginContainer/ColoredRect/MarginContainer2/SoundButton2

#implement this class and override action()

func set_texts(lbl: String, btn1: String, btn2: String) -> void:
	label.text = tr(lbl)
	sound_button.text = tr(btn1)
	sound_button_2.text = tr(btn2)


func _on_sound_button_pressed() -> void:
	action()


func _on_sound_button_2_pressed() -> void:
	queue_free()
