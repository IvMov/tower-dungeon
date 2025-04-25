class_name PermanentUpgradeCard extends HBoxContainer

@onready var name_label = $NameLabel
@onready var lvl_label = $LvlLabel
@onready var price_label = $PriceLabel
@onready var sound_button = $SoundButton
@onready var timer = $Timer

var upgrade: MetaUpgrade
var is_available: bool = false
var is_max_lvl: bool = false
var price: int

var current_upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	update_info()
	sound_button.pressed.connect(on_button_pressed)
	
func update_info():
	if !MetaProgression.meta_data["upgrades"].has(upgrade.id):
		MetaProgression.meta_data["upgrades"][upgrade.id] = MetaProgression.add_empty_upgrade(upgrade)
	current_upgrade = MetaProgression.meta_data["upgrades"][upgrade.id]
	price = get_current_price()
	set_labels()
	reset_button()
	
func set_labels():
	name_label.text = upgrade.title
	var current_lvl = current_upgrade["lvl"]
	var lvl = "%d/%d" % [current_lvl, upgrade.max_lvl]
	is_max_lvl = current_lvl == upgrade.max_lvl
	lvl_label.text = lvl
	price_label.text = "%d $" % price
	if current_upgrade["lvl"] == upgrade.max_lvl:
		price_label.text = "sold out"
	reset_button()
	
func reset_button():
	is_available = MetaProgression.meta_data["coins"] >= price 
	if is_available && !is_max_lvl && timer.is_stopped():
		sound_button.disabled = false
	else: 
		sound_button.disabled = true

func get_current_price():
	return upgrade.base_price + (upgrade.base_price * current_upgrade["lvl"] * (upgrade.lvl_price_multiplier-1))

func on_button_pressed():
	if timer.is_stopped() && is_available && !is_max_lvl: 
		MetaProgression.meta_data["coins"]-= price
		GameEvents.emit_permanent_upgrade_buy(upgrade)
		timer.start()
