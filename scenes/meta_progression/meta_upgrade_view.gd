class_name MetaUpgradeView extends Node3D #Hoverable

@onready var flying_upgrade_view: FlyingUpgradeView = $FlyingUpgradeView
@onready var meta_upgrade_holder: Node3D = $MeshInstance3D/MetaUpgradeHolder

const REAL = "real"
const REQ = "required"

var count: int = 0 
var upgrade: MetaUpgrade 
var rich_text_template: String  = "[b] %s [/b] \n \n %s"
var invested: Vector4 = Vector4.ZERO

var test: int = 2
var max_test: int = 10


func init(upgrade: MetaUpgrade, pos: Vector3) -> void:
	self.upgrade = upgrade
	global_position = pos

func prepare_view() -> void:
	var obj: Node3D = upgrade.object.instantiate()
	meta_upgrade_holder.add_child(obj)
	obj.set_disabled()
	flying_upgrade_view.set_rich_text(rich_text_template % [tr(upgrade.title), tr(upgrade.description)])
	var upgrade_data: Dictionary = PlayerParameters.meta_upgrades.get(upgrade.id)
	
	if upgrade_data["is_done"]:
		flying_upgrade_view.set_is_done()
	else:
		flying_upgrade_view.set_coins_progress(upgrade_data[REAL].w, upgrade_data[REQ].w)
		flying_upgrade_view.set_green_souls_progress(upgrade_data[REAL].x, upgrade_data[REQ].x)
		flying_upgrade_view.set_blue_souls_progress(upgrade_data[REAL].y, upgrade_data[REQ].y)
		flying_upgrade_view.set_red_souls_progress(upgrade_data[REAL].z, upgrade_data[REQ].z)

func add_to_axis(axis: int, upgrade_data: Dictionary, real: float, required: float) -> bool:
	if real + 1 > required:
		return false
	else:
		match axis:
			0: 
				PlayerParameters.coins-=1
				upgrade_data[REAL].w+=1
				flying_upgrade_view.set_coins_progress(upgrade_data[REAL].w, required)
				print(PlayerParameters.coins)
				print(upgrade_data[REAL])
				print(upgrade_data[REQ])
			1: 
				PlayerParameters.souls.x-=1
				upgrade_data[REAL].x+=1
				flying_upgrade_view.set_green_souls_progress(upgrade_data[REAL].x, required)
			2: 
				PlayerParameters.souls.y-=1
				upgrade_data[REAL].y+=1
				flying_upgrade_view.set_blue_souls_progress(upgrade_data[REAL].y, required)
			3: 
				PlayerParameters.souls.z-=1
				upgrade_data[REAL].z+=1
				flying_upgrade_view.set_red_souls_progress(upgrade_data[REAL].z, required)
		GameEvents.emit_souls_update_view()
		if upgrade_data[REAL] == upgrade_data[REQ]:
			upgrade_data["is_done"] = true
			flying_upgrade_view.set_is_done()
		return true

func _on_static_body_3d_mouse_entered() -> void:
	flying_upgrade_view.show_bars()


func _on_static_body_3d_mouse_exited() -> void:
	flying_upgrade_view.hide_bars()


func do_action() -> bool: 
	var upgrade_data: Dictionary = PlayerParameters.meta_upgrades.get(upgrade.id)
	if upgrade_data["is_done"]:
		return false
	if PlayerParameters.coins > 0 && upgrade_data[REAL].w+1 <= upgrade_data[REQ].w:
		add_to_axis(0, upgrade_data, upgrade_data[REAL].w, upgrade_data[REQ].w)
	elif PlayerParameters.souls.x > 0 && upgrade_data[REAL].x+1 <= upgrade_data[REQ].x:
		add_to_axis(1, upgrade_data, upgrade_data[REAL].x, upgrade_data[REQ].x)
	elif PlayerParameters.souls.y > 0 && upgrade_data[REAL].y+1 <= upgrade_data[REQ].y:
		add_to_axis(2, upgrade_data, upgrade_data[REAL].y, upgrade_data[REQ].y)
	elif PlayerParameters.souls.z > 0 && upgrade_data[REAL].z+1 <= upgrade_data[REQ].z:
		add_to_axis(3, upgrade_data, upgrade_data[REAL].z, upgrade_data[REQ].z)
	else:
		GameEvents.emit_skill_call_failed(-100, Enums.SkillCallFailedReason.NOT_ENOUGH_ELEMENTS)
		return false

	return true
