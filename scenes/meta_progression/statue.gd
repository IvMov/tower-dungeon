class_name Statue extends Hoverable

#i'm lazy af, so i dont care to extract 4 statues code here to have it generic

var statue: MeshInstance3D

var done_particles: GPUParticles3D
var add_crystal_particles: GPUParticles3D
var add_stone_particles: GPUParticles3D
var static_body_3d: StaticBody3D
var animation_player: AnimationPlayer

var MAX_STONES: int = 10
var MAX_CRYSTALS: int = 10

var stones: int 
var crystals: int 

var stone_position: Vector3
var crystal_position: Vector3
var is_ready: bool = false

func common_ready(ID: int) -> void:
	stones = PlayerParameters.player_data["statues"][ID]["stones"]
	MAX_STONES = PlayerParameters.player_data["statues"][ID]["stones_max"]
	crystals = PlayerParameters.player_data["statues"][ID]["crystals"]
	MAX_CRYSTALS = PlayerParameters.player_data["statues"][ID]["crystals_max"]
	if PlayerParameters.player_data["statues"][ID]["is_done"]:
		set_is_done(ID)
	elif crystals == MAX_CRYSTALS || stones == MAX_STONES:
		statue.transparency = 0.5


func add_crystals(ID: int) -> bool:
	if crystals == MAX_CRYSTALS && stones == MAX_STONES:
		set_is_done(ID)
		return false
	elif crystals == MAX_CRYSTALS && stones != MAX_STONES:
			flying_text.set_text(tr("statue_no_stones_and_crystals_template") % [stones, MAX_STONES, crystals, MAX_CRYSTALS])
			return false
	if crystals == MAX_CRYSTALS:
		return false
	var success: bool = false
	var item_bulk: ItemBulk = PlayerParameters.find_item(crystal_position)
	if crystal_position && item_bulk && item_bulk.item.id == Constants.ITEM_CRYSTAL_ID:
		GameEvents.emit_item_remove(crystal_position, 1)
		success = true
		crystals+=1
	else:
		crystal_position = PlayerParameters.find_item_position_by_id(Constants.ITEM_CRYSTAL_ID)
		if crystal_position != Vector3.ONE * -1:
			GameEvents.emit_item_remove(crystal_position, 1)
			success = true
			crystals+=1
	if crystal_position.x == 3:
		GameEvents.emit_item_update_hand_view(crystal_position.z)
	if success:
		PlayerParameters.player_data["statues"][ID]["crystals"] = crystals
		add_crystal_particles.emitting = true
		flying_text.set_text(tr("statue_common_info_template") % [stones, MAX_STONES, crystals, MAX_CRYSTALS])
	else:
		flying_text.set_text(tr("statue_no_stones_and_crystals_template") % [stones, MAX_STONES, crystals, MAX_CRYSTALS])
	if crystals == MAX_CRYSTALS && stones == MAX_STONES:
		set_is_done(ID)
		return true
	elif crystals == MAX_CRYSTALS && stones != MAX_STONES:
		statue.transparency = 0.5
	return true

func add_stones(ID: int) ->bool:
	if stones == MAX_STONES:
		return false
	var success: bool = false
	var item_bulk: ItemBulk = PlayerParameters.find_item(stone_position)
	if stone_position && item_bulk && item_bulk.item.id == Constants.ITEM_STONE_ID:
		GameEvents.emit_item_remove(stone_position, 1)
		success = true
		stones+=1
	else:
		stone_position = PlayerParameters.find_item_position_by_id(Constants.ITEM_STONE_ID)
		if stone_position != Vector3.ONE * -1:
			GameEvents.emit_item_remove(stone_position, 1)
			success = true
			stones+=1
	if stone_position.x == 3:
		GameEvents.emit_item_update_hand_view(stone_position.z)
	if success:
		PlayerParameters.player_data["statues"][ID]["stones"] = stones
		add_stone_particles.emitting = true
		if crystals == MAX_CRYSTALS && stones == MAX_STONES:
			set_is_done(ID)
			return false
		elif stones == MAX_STONES:
			statue.transparency = 0.5
		flying_text.set_text(tr("statue_common_info_template") % [stones, MAX_STONES, crystals, MAX_CRYSTALS])
	return success

func set_is_done(ID: int) -> void:
	if !PlayerParameters.player_data["statues"][ID]["is_done"]:
		PlayerParameters.player_data["statues"][ID]["is_done"] = true
		PlayerParameters.player_data["spark_permanent"]["quantity"]+=1
		PlayerParameters.player.add_permanent_spark(ID)
	is_ready = true
	statue.transparency = 0
	static_body_3d.set_collision_layer_value(1, true)
	static_body_3d.set_collision_layer_value(6, false)
	animation_player.play("rotation")
	done_particles.emitting = true
	flying_text.visible = true
	flying_text.set_text(tr("statue_done_text"))
	print("SetISFCKING FONE")
	flying_text.visible = true

func set_text_on_hover() -> void:
	flying_text.set_text(tr("statue_common_info_template") % [stones, MAX_STONES, crystals, MAX_CRYSTALS])

func _on_static_body_3d_mouse_exited() -> void:
	if !is_ready:
		flying_text.visible = false
