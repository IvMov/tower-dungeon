class_name PlayerBarsBox extends PanelContainer

@onready var bars_container: VBoxContainer = $BarsContainer

@onready var hp_bar: ProgressBar = $BarsContainer/HpContainer/HpBar
@onready var mp_bar: ProgressBar = $BarsContainer/MpContainer/MpBar
@onready var stamina_bar: ProgressBar = $BarsContainer/StaminaContainer/StaminaBar


func _ready():
	GameEvents.player_entered.connect(on_player_entered)

func reset_bars():
	hp_bar.value = 0
	mp_bar.value = 0
	stamina_bar.value = 0

func recalc_bar_value(bar: ProgressBar, new_value: float):
	if bar.value > new_value:
		bar.animate_minus(new_value - bar.value)
	bar.value = new_value
	bar.current.text = "%.2f" % new_value

func recalc_bar_max_value(bar: ProgressBar, new_value: float):
	bar.max_value = new_value

func set_init_values(player: Player) -> void:
	hp_bar.max_value = player.health_component.max_value
	mp_bar.max_value = player.mana_component.max_value
	stamina_bar.max_value = player.stamina_component.max_value
	
	hp_bar.value = player.health_component.current_value
	mp_bar.value = player.mana_component.current_value
	stamina_bar.value = player.stamina_component.current_value
	
	hp_bar.current.text = "%.2f" % hp_bar.value
	mp_bar.current.text = "%.2f" % mp_bar.value
	stamina_bar.current.text = "%.2f" % stamina_bar.value
	
	hp_bar.regen.text = "+%.2f / s" % player.health_component.regen
	mp_bar.regen.text = "+%.2f / s" % player.mana_component.regen
	stamina_bar.regen.text = "+%.2f / s" % player.stamina_component.regen


func resize():
	for child in bars_container.get_children():
		child.custom_minimum_size =  Vector2(GameConfig.grid_block*5, GameConfig.grid_block/3)

func on_max_value_changed(value: float, bar: ProgressBar) -> void:
	recalc_bar_max_value(bar, value)

func on_value_changed(value: float, current_value: float, bar: ProgressBar) -> void:
	recalc_bar_value(bar, current_value)

func on_regen_changed(value: float, bar: ProgressBar) -> void:
	bar.regen.text = "+%.2f / s" % value

func on_player_entered(player: Player):
	player.health_component.health_changed.connect(on_value_changed.bind(hp_bar))
	player.mana_component.mana_changed.connect(on_value_changed.bind(mp_bar))
	player.stamina_component.stamina_changed.connect(on_value_changed.bind(stamina_bar))
	
	player.health_component.max_value_changed.connect(on_max_value_changed.bind(hp_bar))
	player.mana_component.max_value_changed.connect(on_max_value_changed.bind(mp_bar))
	player.stamina_component.max_value_changed.connect(on_max_value_changed.bind(stamina_bar))
	
	player.health_component.regen_changed.connect(on_regen_changed.bind(hp_bar))
	player.mana_component.regen_changed.connect(on_regen_changed.bind(mp_bar))
	player.stamina_component.regen_changed.connect(on_regen_changed.bind(stamina_bar))
	
	set_init_values(player)
	
	
	
