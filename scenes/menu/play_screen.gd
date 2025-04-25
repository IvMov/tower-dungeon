extends CanvasLayer


func  _unhandled_input(event):
	if event.is_action_pressed("exit"):
		_on_back_button_pressed()

func _on_new_game_button_pressed() -> void:
	#just to not forget how did I previously
	#var scene = load("res://scenes/menu/stats_and_upgrade_screen.tscn")
	#var properties = scene.instantiate()
	#get_parent().add_child(properties)
	print("load screen with new game creation, username")


func _on_continue_game_button_pressed() -> void:
	print("load screen with loads")

func _on_back_button_pressed() -> void:
	queue_free()
