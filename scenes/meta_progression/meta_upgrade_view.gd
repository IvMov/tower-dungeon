class_name MetaUpgradeView extends Hoverable

@onready var flying_upgrade_view: FlyingUpgradeView = $FlyingUpgradeView

var count: int = 0 
var upgrade: MetaUpgrade 
var rich_text_template: String  = "[b] %s [/b] \n \n %s"
var text_template: String  = "Invested: %s \n Target: %s"
var invested: Vector4 = Vector4.ZERO


	#idea
	#set some fields and reuse for progression
	#1) change view to be mesh with book or etc
	#when hovered - shows what need to be added to achieve result
	#add coins, souls - animate - they move around on top or sides and then to this point (reuse soul behaviour)
	#put this metaupgrades in long coridor where names always shown - cause it will help to navigate
#could be bad idea as player not see all list of possible changes

func prepare_view() -> void:
	flying_upgrade_view.set_rich_text(rich_text_template % [tr(upgrade.title), tr(upgrade.description)])
	flying_upgrade_view.set_text(text_template % [invested, upgrade.price])


func add_to_axis(axis: int, upgrade_data: Dictionary, real: float, required: float) -> bool:
	if real + 1 > required:
		return false
	else:
		match axis:
			0: 
				upgrade_data["real"].w+=1
			1: 
				upgrade_data["real"].x+=1
			2: 
				upgrade_data["real"].y+=1
			2: 
				upgrade_data["real"].z+=1
				
		return true

func _on_static_body_3d_mouse_entered() -> void:
	flying_upgrade_view.label.visible = true


func _on_static_body_3d_mouse_exited() -> void:
	flying_upgrade_view.label.visible = false


func do_action() -> bool: 
	print("I feeel it!!!!")
	print(count)
	#add souls/gold/play animation :) 
	count+=1
	return true
