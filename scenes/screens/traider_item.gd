class_name TraiderItem extends MarginContainer

@onready var item_view_holder: ItemViewHolder = $HBoxContainer/ItemViewHolder
@onready var title: Label = $HBoxContainer/Title
@onready var type: Label = $HBoxContainer/Type
@onready var price: Label = $HBoxContainer/Price
@onready var total_price: RichTextLabel = $HBoxContainer/TotalPrice
@onready var option_button: OptionButton = $HBoxContainer/Quantity/OptionButton
@onready var button_buy: Button = $HBoxContainer/ButtonBuy
@onready var quantity: HBoxContainer = $HBoxContainer/Quantity

var buttons_ids: Array[int] = [1, 2, 3, 5, 10, 100]
var selected_quantity: int = 1
var price_of_one: Vector3


func build(item: ItemBulk) -> void:
	self.item_view_holder.item_view.item_bulk = item
	self.item_view_holder.item_view.draw_item()
	self.title.text = item.item.title
	self.type.text = item.item.type
	self.price_of_one = item.item.price
	selected_quantity = 1
	recalc_prices()
	update_option_buttons()
	resize()

func recalc_prices() -> void: 
	self.price.text = "%d / %d / %d" % [price_of_one.x, price_of_one.y, price_of_one.z]
	total_price.text = "".join(update_availability())


func update_availability() -> Array: 
	var green_enough: bool = is_price_afordable(price_of_one.x, PlayerParameters.souls.x)
	var blue_enough: bool = is_price_afordable(price_of_one.y, PlayerParameters.souls.y)
	var red_enough: bool = is_price_afordable(price_of_one.z, PlayerParameters.souls.z)
	button_buy.disabled = !red_enough || !blue_enough || !green_enough
	var parts: Array = []
	
	parts.append("[color=white]" if green_enough else "[color=red]")
	parts.append("%.0f" % (price_of_one.x * selected_quantity))
	parts.append("[/color]")
	parts.append(" / ")

	parts.append("[color=white]" if blue_enough else "[color=red]")
	parts.append("%.0f" % (price_of_one.y * selected_quantity))
	parts.append("[/color]")
	parts.append(" / ")
	
	parts.append("[color=white]" if red_enough else "[color=red]")
	parts.append("%.0f" % (price_of_one.z * selected_quantity))
	parts.append("[/color]")
	
	return parts

func is_price_afordable(price_of_one_soul: int, real_souls: int) -> bool:
	var expected: int = selected_quantity * price_of_one_soul;
	return expected <= real_souls


func resize() -> void:
	item_view_holder.resize()
	quantity.custom_minimum_size =  Vector2(GameConfig.grid_block * 1.5, 0)
	price.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)
	total_price.custom_minimum_size =  Vector2(GameConfig.grid_block * 2.5 , 0)
	type.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)
	title.custom_minimum_size =  Vector2(GameConfig.grid_block * 3.5 , 0)
	button_buy.custom_minimum_size =  Vector2(GameConfig.grid_block * 2 , 0)


func update_option_buttons() -> void:
	option_button.select(0)
	var max_quantity: int = get_all_items_quantity()
	for i in 5:
		if buttons_ids[i] > max_quantity:
			option_button.set_item_disabled(i, true)
		else:
			option_button.set_item_disabled(i, false)
	#enable all btn
	option_button.set_item_disabled(5, false)

func get_all_items_quantity() -> int:
	return self.item_view_holder.item_view.item_bulk.quantity

func _on_option_button_item_selected(index: int) -> void:
	selected_quantity = option_button.get_item_id(index) if index != 5 else get_all_items_quantity()
	recalc_prices()


func _on_button_buy_pressed() -> void:
	item_view_holder.item_view.item_bulk.quantity -= selected_quantity
	GameEvents.emit_item_add(Vector3.ZERO, ItemBulk.new(item_view_holder.item_view.item_bulk.item, selected_quantity))
	PlayerParameters.souls -= price_of_one * selected_quantity
	GameEvents.emit_souls_update_view()
	GameEvents.emit_update_items_prices()
	if item_view_holder.item_view.item_bulk.quantity <= 0:
		queue_free()
	else:
		build(item_view_holder.item_view.item_bulk)


func _on_button_buy_gui_input(event: InputEvent) -> void:
	if button_buy.disabled && event.is_action_pressed("LMB"):
		var tween: Tween = create_tween()
		tween.tween_property(total_price, "scale", Vector2.ONE * 1.2, 0.05)
		tween.tween_property(total_price, "scale", Vector2.ONE, 0.05)
