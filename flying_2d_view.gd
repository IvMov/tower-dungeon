class_name Flying2dView extends MarginContainer

@onready var bars: VBoxContainer = $Bars
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var done_label_container: PanelContainer = $DoneLabelContainer
@onready var coins: ProgressBar = $Bars/Coins/Coins
@onready var coins_label: Label = $Bars/Coins/Coins/CoinsLabel
@onready var souls_green: ProgressBar = $Bars/Green/SoulsGreen
@onready var souls_green_label: Label = $Bars/Green/SoulsGreen/SoulsGreenLabel
@onready var souls_blue: ProgressBar = $Bars/Blue/SoulsBlue
@onready var souls_blue_label: Label = $Bars/Blue/SoulsBlue/SoulsBlueLabel
@onready var souls_red: ProgressBar = $Bars/Red/SoulsRed
@onready var souls_red_label: Label = $Bars/Red/SoulsRed/SoulsRedLabel
@onready var done_label: RichTextLabel = $DoneLabelContainer/DoneLabel


func set_coins(real: int, expected:int) -> void: 
	coins.value = real
	coins.max_value = expected
	coins_label.text = "%d / %d" % [real, expected]

func set_green_souls(real: int, expected: int) -> void:
	souls_green.value = real
	souls_green.max_value = expected
	souls_green_label.text = "%d / %d" % [real, expected]

func set_blue_souls(real: int, expected: int) -> void:
	souls_blue.value = real
	souls_blue.max_value = expected
	souls_blue_label.text = "%d / %d" % [real, expected]

func set_red_souls(real: int, expected: int) -> void:
	souls_red.value = real
	souls_red.max_value = expected
	souls_red_label.text = "%d / %d" % [real, expected]
