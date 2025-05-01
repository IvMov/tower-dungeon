extends CanvasLayer

@onready var back_button = $MarginContainer/Bacground/VBoxContainer/BackButton
@onready var sfx_slider = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/SfxSound/SfxSlider
@onready var music_slider = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/MusicSound/MusicSlider
@onready var window_button = $MarginContainer/Bacground/VBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer/WindowButton
@onready var sfx_random_audio_player_component = $SfxRandomAudioPlayerComponent

var last_scene: CanvasLayer 


func _ready():
	window_button.pressed.connect(on_window_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	#GameEvents.window_changed.connect(on_window_changed)
	update_display()

func _unhandled_key_input(event):
	if event.is_action_pressed("exit"):
		on_back_button_pressed()
		


func update_display():
	window_button.text = "Windowed" if GameConfig.full_screen else "Full screen"
	sfx_slider.value = get_bus_volume("sfx")
	music_slider.value = get_bus_volume("music")


func get_bus_volume(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	
	return db_to_linear(volume_db)


func set_bus_volume(value: float, bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_window_button_pressed():
	GameConfig.resize_screen()
	update_display()


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume(value, bus_name)
	if bus_name == "sfx":
		sfx_random_audio_player_component.play_random_stream()


func on_back_button_pressed():
	last_scene.bacground.color.a = 0.5
	last_scene.v_box_container.visible = true
	queue_free()

func on_window_changed():
	update_display()
