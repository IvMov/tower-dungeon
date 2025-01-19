extends Hoverable


var text: String = "No way back, only forward!"

func _ready() -> void:
	flying_text.set_text(text)

func do_action() -> void: 
	flying_text.set_text("I SAID - NO WAY BACK, \n c`mon - beat this level, \nfind some stairs up!")
