class_name TraiderItem extends MarginContainer

@onready var item_view_holder: ItemViewHolder = $HBoxContainer/ItemViewHolder
@onready var title: Label = $HBoxContainer/Title
@onready var type: Label = $HBoxContainer/Type
@onready var price: Label = $HBoxContainer/Price
@onready var total_price: Label = $HBoxContainer/TotalPrice
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
	recalc_prices()
	update_option_buttons()
	resize()

func recalc_prices() -> void: 
	self.price.text = "%d / %d / %d" % [price_of_one.x, price_of_one.y, price_of_one.z]
	self.total_price.text = "%d / %d / %d" % [price_of_one.x * selected_quantity, price_of_one.y * selected_quantity, price_of_one.z * selected_quantity]
	
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

func get_all_items_quantity() -> int:
	return self.item_view_holder.item_view.item_bulk.quantity

func _on_option_button_item_selected(index: int) -> void:
	selected_quantity = option_button.get_item_id(index) if index != 5 else get_all_items_quantity()
	recalc_prices()
